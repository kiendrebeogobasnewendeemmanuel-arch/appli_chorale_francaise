class Chant {
  final int? id;
  final String langue;
  final String titre;
  final String contenu;
  final String numero;
  final int favori; // 0 = non favori, 1 = favori

  Chant({
    this.id,
    required this.langue,
    required this.titre,
    required this.contenu,
    required this.numero,
    this.favori = 0,
  });

  // Convertir un objet Chant en Map (pour SQLite)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'langue': langue,
      'titre': titre,
      'contenu': contenu,
      'favori': favori,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // **Ajoute cette factory** pour créer un Chant depuis une map SQLite
  factory Chant.fromMap(Map<String, dynamic> map) {
    return Chant(
      id: map['id'] as int,
      langue: map['langue'] as String,
      titre: map['titre'] as String,
      contenu: map['contenu'] as String,
      favori: map['favori'] ?? 0, numero: '', // Par défaut 0 si la colonne n'existe pas
    );
  }
}
