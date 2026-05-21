import 'package:flutter/material.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
import 'package:appli_chorale_francaise/appchorale.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important pour async avant runApp

  // Chemin de la base de données
//final dbPath = join(await getDatabasesPath(), 'chants.db');

  // ⚠️ Supprime l'ancienne base pour repartir à zéro (TEST uniquement)
//await deleteDatabase(dbPath);

  // Lancer l'application
  runApp(const ChoraleApp());
}
