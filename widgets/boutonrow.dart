import 'package:flutter/material.dart';
class BoutonRow extends StatelessWidget {
  final List<Widget> boutons;

  const BoutonRow({super.key, required this.boutons});

  @override
  Widget build(BuildContext context) {
    return Row(
       
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: null,
                child: Text('Connexion',
                style: TextStyle(fontFamily: 'Times New Roman'),
              ),
              ),
              
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: null,
                child: Text('Inscription',
                style: TextStyle(fontFamily: 'Times New Roman',
                fontSize: 16),
                ),
              ),
             
            ],  
    );
  }
}