import 'package:flutter/material.dart';

class CreateProfileStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Rejoignez Ocean Adventure',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Gerez votre profil pour ',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Image.asset('assets/welcome_image.jpg'), // Assurez-vous d'avoir une image correspondante dans le dossier assets
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour naviguer vers le formulaire de création de compte
                    },
                    child: Text('Démarrer'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // largeur infinie, hauteur de 50
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Logique pour naviguer vers l'écran de connexion
                    },
                    child: Text('Je ne souhaite pas maintenant'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
