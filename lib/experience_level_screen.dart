/*
 ******************************************************************************
 * ExperienceLevelScreen.dart
 *
 * Ce fichier implémente l'écran de sélection du niveau d'expérience de l'utilisateur.
 * L'utilisateur peut choisir parmi plusieurs niveaux d'expérience, et cette préférence
 * est ensuite enregistrée dans Firestore.
 *
 * Fonctionnalités :
 * - Sélection du niveau d'expérience via des cartes interactives.
 * - Validation et enregistrement du choix dans Firestore.
 * - Navigation vers l'écran de préférences de voyage après enregistrement.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/travel_preferences.dart';

class ExperienceLevelScreen extends StatefulWidget {
  @override
  _ExperienceLevelScreenState createState() => _ExperienceLevelScreenState();
}

class _ExperienceLevelScreenState extends State<ExperienceLevelScreen> {
  String? _selectedLevel;

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface de l'écran
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Niveau d'expérience",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Color(0xFF64C8C8),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Superposition sombre pour améliorer la lisibilité du texte
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: <Widget>[
                // Cartes de sélection du niveau d'expérience
                Expanded(child: _buildLevelCard('Débutant', 'assets/debutant.jpg', "Idéal pour les débutants ou ceux qui découvrent le sport.")),
                Expanded(child: _buildLevelCard('Intermédiaire', 'assets/intermediaire.jpg', "Pour ceux qui ont une certaine expérience et compétence.")),
                Expanded(child: _buildLevelCard('Avancé', 'assets/avance.jpg', "Conçu pour les experts qui maîtrisent pleinement le sport.")),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: _selectedLevel != null ? _navigateOrConfirm : null,
                    child: Text('Suivant', style: TextStyle(fontSize: 18, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedLevel != null ? Color(0xFF64C8C8) : Colors.grey,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour construire une carte de niveau d'expérience
  Widget _buildLevelCard(String level, String imagePath, String description) {
    bool isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLevel = level;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: isSelected ? null : ColorFilter.mode(Colors.grey.withOpacity(0.7), BlendMode.darken),
          ),
          border: isSelected ? Border.all(color: Colors.greenAccent, width: 3) : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              level,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.greenAccent : Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.greenAccent.withOpacity(0.7) : Colors.white.withOpacity(0.7),
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour enregistrer le niveau d'expérience
  void _saveExperienceLevel() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedLevel != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'experienceLevel': _selectedLevel,
        });
        // Navigation vers l'écran de préférences de voyage seulement si l'enregistrement réussit
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TravelPreferences()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save experience level. Please try again.'), backgroundColor: Colors.red)
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to save your preferences.'), backgroundColor: Colors.red)
      );
    }
  }

  // Fonction pour naviguer ou confirmer l'action
  void _navigateOrConfirm() {
    _saveExperienceLevel();
  }
}
