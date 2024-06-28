import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/basic_info_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/recommandation_service.dart';
import 'package:notebook_progress/welcome_screen.dart';

import 'loading_screen.dart';

class CreateProfileStart extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0), // pour un meilleur espace latéral
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      'assets/welcome_image.jpg',
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
                    onPressed: () => _saveDefaultDataAndExit(context),
                    child: Text(
                      'Je ne souhaite pas maintenant',
                      style: TextStyle(
                        color: Colors.grey[700],
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
  void _saveDefaultDataAndExit(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'preferredStayType': 'Festif',
          'experienceLevel': 'Débutant',
        }, SetOptions(merge: true));

        // Simuler un chargement avant de récupérer les recommandations
        await Future.delayed(Duration(seconds: 5));  // Réduire à 5 secondes pour le rendre moins long

        // Supposant que RecommendationService est une classe existante qui gère la logique de recommandation
        RecommendationService recommendationService = RecommendationService();
        List<Map<String, dynamic>> recommendedCamps = await recommendationService.getRecommendedCamps();

        // Naviguer vers WelcomeScreen avec les camps recommandés
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomeScreen(recommendedCamps: recommendedCamps)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save default data. Please try again.'), backgroundColor: Colors.red)
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user logged in.'), backgroundColor: Colors.red)
      );
    }
  }
}


