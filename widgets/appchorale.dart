
import 'package:appli_chorale_francaise/page/chants_list_page.dart';
import 'package:flutter/material.dart';
import 'package:appli_chorale_francaise/widgets/menu_button.dart';
import 'package:appli_chorale_francaise/widgets/theme.dart';
import 'package:appli_chorale_francaise/page/page_chargement.dart';
import 'package:share_plus/share_plus.dart';
import 'package:appli_chorale_francaise/profil.dart';
///import 'package:appli_chorale_francaise/page/bouton/page_chargement2.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChoraleApp());
}

class ChoraleApp extends StatefulWidget {
  const ChoraleApp({super.key});

  // ignore: library_private_types_in_public_api
  static _ChoraleAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ChoraleAppState>();

  @override
  State<ChoraleApp> createState() => _ChoraleAppState();
}

class _ChoraleAppState extends State<ChoraleApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chorale Française',
      theme: AppThemes.lightTheme,
      home: const SplashScreen(),
    );
  }
}



/* ---------------- MENU PRINCIPAL ---------------- */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 58, 159, 241),
        
        actions: [
          //Presentation de Profil
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              );
            },
          ),

          PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 8,
                onSelected: (value) {
                  _handleMenuAction(context, value);
                },
                itemBuilder: (context) => const [

          PopupMenuItem(
            value: 'share',
            child: ListTile(
              leading: Icon(Icons.share, color: Colors.blue),
              title: Text(
                "Partager l'application",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),

          PopupMenuItem(
            value: 'about',
            child: ListTile(
              leading: Icon(Icons.info_outline, color: Colors.blue),
              title: Text(
                "À propos",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),

        ],
      ),


    ],   
      ),
      body: const BoutonsMenu(),
    );
  }
  
  void _shareApp() {
    // ignore: deprecated_member_use
    Share.share('''Découvrez l'application Chorale Française pour les hymnes chrétiens en français, 
    mooré et d'autres langues !'''
    );
  }
  
  void _handleMenuAction(BuildContext context, String value) {
     if (value== 'share') {
              _shareApp();
            } else if (value == 'about') {
              showAboutDialog(
                context: context,
                applicationName: 'Chorale Française',
                applicationVersion: '1.0.0',
              );
            }
  }
  
}

/* ---------------- Widget Texte nom chorale ---------------- */

class NomChorale extends StatelessWidget {
  const NomChorale({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      const Text(
      'CHORALE \n FRANÇAISE',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),

      const Text(
      'ZONE PILOTE',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.blue,
      ),
    ),
    ],  
    );

  }
}

/* ---------------- Boutonsmenu---------------- */
class BoutonsMenu extends StatelessWidget {
  const BoutonsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    

    // 1️⃣ Définition du style (UNE seule fois) fonction
    final ButtonStyle styleBouton = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 58, 159, 241),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.all(20),
      textStyle: const TextStyle(fontSize: 18),
      alignment: Alignment.center,
      minimumSize: const Size(300, 50),
    );

    // 2️⃣ Interface
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100], // fond léger
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blueAccent, width: 3),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          const NomChorale(),

          const SizedBox(height: 32),

          MenuButton(
            icon: Icons.music_note,
            label: 'Hymnes en Français',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChantsListPage(langue: 'Francais'),
                ),
              );
            },
            //appel de la fonction de style de boutons
            style: styleBouton,
          ),

          const SizedBox(height: 20),

          MenuButton(
            icon: Icons.music_note,
            label: 'Hymnes en Mooré et Autres',
            onTap: () { 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChantsListPage(langue: 'Moore et Autres'),
                ),
              );
              
            },
            //appel de la focnction de style boutons
            style: styleBouton,
          ),

          const SizedBox(height: 20),

         
          MenuButton(
            icon: Icons.star,
            label: 'Favoris',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChantsListPage(langue: 'favori'),
                ),
              );
              
            },
           //appel de la fonction de  style 
            style: styleBouton,
          ),

          const SizedBox(height: 16),

          //Verset Aleatoire
         Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [

                    const Icon(
                      Icons.menu_book,
                      size: 35,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      '''Psaumes 34:2 - Je bénirai l'Éternel en tout temps; Sa louange sera toujours dans ma bouche.''',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          
        ],
      ),
    )
      )
    );
  }
}


