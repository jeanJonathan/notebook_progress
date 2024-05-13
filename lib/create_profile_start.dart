import 'package:flutter/material.dart';
import 'package:notebook_progress/basic_info_screen.dart';

class CreateProfileStart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0), // Ajusté pour un meilleur espace latéral
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center, // Assure que tout est centré
                children: <Widget>[
                  SizedBox(height: 100),
                  Text(
                    'Bienvenue chez Ocean Adventure',
                    style: TextStyle(
                      fontSize: 40, // Taille augmentée pour plus de présence
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64C8C8), // Couleur pour écho à la marque Ocean Adventure
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Commencez par gérer votre profil pour une expérience personnalisée.',
                    style: TextStyle(
                      fontSize: 18, // Légère augmentation de la taille pour une meilleure lisibilité
                      color: Colors.grey[700], // Couleur douce pour le texte explicatif
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  ClipRRect( // Utilisation de ClipRRect pour arrondir les coins de l'image
                    borderRadius: BorderRadius.circular(20.0), // Rayon de 20.0 pour les coins arrondis
                    child: Image.asset(
                      'assets/welcome_image.jpg', // Assurez-vous que l'image est visuellement attrayante
                      width: MediaQuery.of(context).size.width * 0.8, // Utilise 80% de la largeur de l'écran
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Utilisation de Navigator pour pousser la nouvelle route nommée
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BasicInfoScreen()),
                      );
                    },
                    child: Text(
                      'Démarrer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF64C8C8), // Couleur de bouton qui se distingue
                      minimumSize: Size(double.infinity, 60), // Bouton plus grand pour une meilleure touchabilité
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Boutons avec coins arrondis
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Logique pour revenir à l'écran précédent ou à l'écran de connexion
                      Navigator.of(context).pop(); // Retour à l'écran précédent
                    },
                    child: Text(
                      'Je ne souhaite pas maintenant',
                      style: TextStyle(
                        color: Colors.grey[700], // Une couleur neutre mais visible
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
