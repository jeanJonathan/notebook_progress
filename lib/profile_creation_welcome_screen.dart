/*
 ******************************************************************************
 * profile_creation_welcome_screen.dart
 *
 * Ce fichier implémente l'écran de démarrage de la création de profil.
 * Cet écran accueille l'utilisateur et lui permet de commencer à gérer son profil,
 * ou de sauter cette étape pour accéder à des recommandations par défaut.
 *
 * Fonctionnalités :
 * - Message de bienvenue et instructions pour démarrer.
 * - Image d'illustration.
 * - Navigation vers l'écran de saisie des informations de base.
 * - Option de sauter l'étape et d'obtenir des recommandations par défaut.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore
 ******************************************************************************
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/basic_info_entry_screen.dart';
import 'package:notebook_progress/recommandation_service.dart';
import 'package:notebook_progress/home.dart';

class CreateProfileStart extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Construire l'interface de l'écran
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0), // Meilleur espace latéral
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 100),
                  // Message de bienvenue
                  Text(
                    'Bienvenue chez Ocean Adventure',
                    style: TextStyle(
                      fontSize: 40, // Taille augmentée pour plus de présence
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64C8C8), // Couleur pour écho à la marque Ocean Adventure
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1), // Décalage de l'ombre
                          blurRadius: 1.0, // Rayon de flou de l'ombre
                          color: Colors.black.withOpacity(0.1), // Couleur de l'ombre avec transparence
                        ),
                      ],
                      letterSpacing: 1.5, // Espacement entre les lettres pour améliorer la lisibilité
                      fontFamily: 'Roboto', // Police moderne et professionnelle
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  // Instructions pour commencer
                  Text(
                    'Commencez par gérer votre profil pour une expérience personnalisée.',
                    style: TextStyle(
                      fontSize: 18, // Légère augmentation de la taille pour une meilleure lisibilité
                      color: Colors.grey[700], // Couleur douce pour le texte explicatif
                      height: 1.5, // Hauteur de ligne augmentée pour améliorer la lisibilité
                      letterSpacing: 0.2, // Espacement entre les lettres pour une apparence plus aérée
                      fontFamily: 'Roboto', // Police moderne et professionnelle
                      fontWeight: FontWeight.w500, // Poids de police intermédiaire pour un meilleur contraste
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  // Image d'illustration avec coins arrondis
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // Rayon de 20.0 pour les coins arrondis
                    child: Image.asset(
                      'assets/welcome_image.jpg',
                      width: MediaQuery.of(context).size.width * 0.8, // Utilise 80% de la largeur de l'écran
                    ),
                  ),
                  SizedBox(height: 40),
                  // Bouton pour démarrer la gestion du profil
                  ElevatedButton(
                    onPressed: () {
                      // Navigation vers l'écran de saisie des informations de base
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BasicInfoScreen()),
                      );
                    },
                    child: Text(
                      'Démarrer',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold, // Ajout de gras pour un texte plus affirmé
                        letterSpacing: 1.2, // Espacement entre les lettres pour une apparence plus aérée
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF64C8C8), // Couleur du texte
                      minimumSize: Size(double.infinity, 60), // Bouton plus grand pour une meilleure touchabilité
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Boutons avec coins arrondis
                      ),
                      elevation: 5, // Ajout d'une légère ombre pour un effet de profondeur
                      padding: EdgeInsets.symmetric(vertical: 15), // Augmenter le padding vertical pour un bouton plus haut
                    ),
                  ),
                  SizedBox(height: 10),
                  // Bouton pour ignorer la gestion du profil
                  TextButton(
                    onPressed: () => _applyAlgorithmAndExit(context),
                    child: Text(
                      'Je ne souhaite pas maintenant',
                      style: TextStyle(
                        fontSize: 16, // Taille de police augmentée pour une meilleure lisibilité
                        color: Colors.grey[700], // Couleur du texte explicatif
                        fontFamily: 'Roboto', // Utilisation d'une police moderne
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Couleur de texte pour le bouton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Coins légèrement arrondis pour un style moderne
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Appliquer l'algorithme de recommandation et naviguer vers l'écran de bienvenue
  void _applyAlgorithmAndExit(BuildContext context) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Utiliser les préférences de l'utilisateur enregistrées dans Firebase
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          // Si l'utilisateur n'a pas de données de préférences, on utilise des valeurs par défaut
          await _firestore.collection('users').doc(user.uid).set({
            'preferredStayType': 'Adventure',
            'experienceLevel': 'Débutant',
          }, SetOptions(merge: true));
        }

        // Appliquer l'algorithme de recommandation
        RecommendationService recommendationService = RecommendationService();
        List<Map<String, dynamic>> recommendedCamps = await recommendationService.getRecommendedCamps();

        // Navigation vers WelcomeScreen avec les camps recommandés
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(recommendedCamps: recommendedCamps)),
        );
      } catch (e) {
        // Affichage d'un message d'erreur en cas d'échec de chargement des recommandations
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Échec du chargement des recommandations. Veuillez réessayer.'), backgroundColor: Colors.red),
        );
      }
    } else {
      // Gérer les erreurs en cas de non-connexion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur non connecté. Veuillez réessayer.'), backgroundColor: Colors.red),
      );
    }
  }
}
