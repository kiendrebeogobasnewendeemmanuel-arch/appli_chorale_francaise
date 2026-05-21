import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/chant.dart';

class ChantDetailPage extends StatefulWidget {
  final Chant chant;

  const ChantDetailPage({super.key, required this.chant});

  @override
  State<ChantDetailPage> createState() => _ChantDetailPageState();
}

class _ChantDetailPageState extends State<ChantDetailPage> {

  double _fontSize = 20;

  // Charger la taille sauvegardée
  @override
  void initState() {
    super.initState();
    _loadFontSize();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? 20;
    });
  }

  // Sauvegarder la taille
  Future<void> _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
  }

  // Zoom +
  void _zoomIn() {
    if (_fontSize < 40) {
      setState(() {
        _fontSize += 2;
      });
      _saveFontSize();
    }
  }

  // Zoom -
  void _zoomOut() {
    if (_fontSize > 14) {
      setState(() {
        _fontSize -= 2;
      });
      _saveFontSize();
    }
  }

  // Reset taille
  void _resetZoom() {
    setState(() {
      _fontSize = 20;
    });
    _saveFontSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 155, 243),

        title: Text(
          '${widget.chant.numero}-${widget.chant.titre}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 252, 253, 253),
          ),
        ),

        actions: [

          // Zoom -
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: _zoomOut,
          ),

          // Zoom +
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _zoomIn,
          ),

          // Reset
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetZoom,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent, width: 1.5),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),

          child: Text(
            widget.chant.contenu,
            style: TextStyle(
              fontSize: _fontSize,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}