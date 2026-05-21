import 'package:flutter/material.dart';
import '../data/chant.dart';
import '../data/chant_database.dart';
import 'chant_detail_page.dart';

class ChantsListPage extends StatefulWidget {
  final String langue;

  const ChantsListPage({super.key, required this.langue});

  @override
  State<ChantsListPage> createState() => _ChantsListPageState();
}

class _ChantsListPageState extends State<ChantsListPage> {

  List<Chant> chants = [];
  List<Chant> chantsFiltres = [];

  @override
  void initState() {
    super.initState();
    _chargerChants();
  }

  Future<void> _chargerChants() async {

    if (widget.langue == 'favori') {
      chants = await ChantDatabase.instance.getFavoris();
    } else {
      chants = await ChantDatabase.instance
          .getChantsByLangue(widget.langue);
    }

    // 🔥🔥🔥 ICI LA GÉNÉRATION AUTOMATIQUE DES NUMÉROS 🔥🔥🔥
    chants = List.generate(chants.length, (index) {
      final chant = chants[index];

      return Chant(
        id: chant.id,
        numero: (index + 1).toString(), // ✅ numéro automatique ici
        titre: chant.titre,
        contenu: chant.contenu,
        favori: chant.favori, langue: widget.langue,
      );
    });
    // 🔥🔥🔥 FIN DE LA GÉNÉRATION 🔥🔥🔥

    chantsFiltres = chants;

    setState(() {});
  }

  // 🔎 Recherche
  void _rechercherChant(String query) {
    final recherche = query.toLowerCase().trim();

    setState(() {
      if (recherche.isEmpty) {
        chantsFiltres = chants;
      } else {
        chantsFiltres = chants.where((chant) {
          return chant.titre.toLowerCase().contains(recherche) ||
                 chant.numero.toString().contains(recherche);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 155, 243),
        title: Text(
          widget.langue == 'favori'
              ? '⭐ Chants Favoris'
              : 'Chants en ${widget.langue}',
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 252, 253, 253)),
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: _rechercherChant,
              decoration: InputDecoration(
                hintText: "Rechercher un chant...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: chantsFiltres.length,
              itemBuilder: (context, index) {

                final chant = chantsFiltres[index];

                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      /*decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 58, 159, 241),
                        borderRadius: BorderRadius.circular(20),
                      ),*/
                      child: Text(
                        "${chant.numero}-${chant.titre}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChantDetailPage(chant: chant),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(
                      chant.favori == 1
                          ? Icons.star
                          : Icons.star_border,
                      color: chant.favori == 1
                          ? Colors.amber
                          : Colors.grey,
                    ),
                    onPressed: () async {
                      await ChantDatabase.instance
                          .toggleFavori(chant.id!, chant.favori);

                      await _chargerChants();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}