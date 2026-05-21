import 'package:flutter/material.dart';
import 'package:appli_chorale_francaise/appchorale.dart';

/* ---------------- SPLASH SCREEN Ecran de Chargement ---------------- */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Exécuter après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
          );
       });
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [

        /// ================================
        /// 1️⃣ FOND DÉGRADÉ PRINCIPAL
        /// ================================
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              // Départ du dégradé (haut de l'écran)
              begin: Alignment.topCenter,

              // Fin du dégradé (bas de l'écran)
              end: Alignment.bottomCenter,

              // Couleurs utilisées (du haut vers le bas)
              colors: [
                Color.fromARGB(255, 33, 150, 243), // vert foncé
                Color.fromARGB(255, 33, 150, 243), // vert moyen
                Color.fromARGB(255, 33, 150, 243), // vert clair
                Color.fromARGB(255, 33, 150, 243), // presque blanc
              ],
            ),
          ),
        ),

        /// ================================
        /// 2️⃣ FORME ARRONDIE EN HAUT
        /// ================================
        Positioned(
          top: 0,
          left: 0,
          right: 0,

          child: Container(
            height: 140, // hauteur de la forme

            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // couleur claire

              // Bordures arrondies en bas
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
          ),
        ),
       
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'CHORALE \n FRANÇAISE',
               textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
              const SizedBox(height: 20),
            const Text(
              'ZONE PILOTE',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 20),
            Image(
             image: const AssetImage('assets/images/christian_cross_PNG23009.png'),
             height: 300,
             width: MediaQuery.of(context).size.width * 1,
              ),

              const SizedBox(height: 20),
              
            const Text(
              'Chargement...',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontStyle: FontStyle.italic,),
            ),
              const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ],
      ),
    );
  }
}