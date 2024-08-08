/*
 ******************************************************************************
 * PreferredStayTypeScreen.dart
 *
 * Ce fichier implémente l'écran de sélection du type de séjour préféré par l'utilisateur.
 * L'utilisateur peut choisir parmi plusieurs types de séjours, et cette préférence
 * est ensuite enregistrée dans Firestore.
 *
 * Fonctionnalités :
 * - Sélection du type de séjour via des cartes interactives.
 * - Validation et enregistrement du choix dans Firestore.
 * - Navigation vers l'écran de sélection du niveau d'expérience après enregistrement.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/user_level_screen.dart';

class PreferredStayTypeScreen extends StatefulWidget {
  @override
  _PreferredStayTypeScreenState createState() => _PreferredStayTypeScreenState();
}

class _PreferredStayTypeScreenState extends State<PreferredStayTypeScreen> {
  String? _selectedType;
  Color? _selectedColor;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Construction de l'interface de l'écran
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Type de séjour",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pref.jpg'), // Chemin vers votre image de fond
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Superposition sombre pour améliorer la lisibilité du texte
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      child: Text(
                        "Quel type de séjour préférez-vous ?",
                        style: theme.textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Options de sélection du type de séjour
                    _buildOptionCard('Adventure', Color(0xFF1B5E20), "Activités excitantes et explorations"),
                    _buildOptionCard('Relax', Color(0xFF01579B), "Retraites paisibles avec spa et yoga"),
                    _buildOptionCard('Culture', Color(0xFFF9A825), "Immersion culturelle et expériences locales"),
                    _buildOptionCard('Family', Color(0xFF6A1B9A), "Pour les familles avec activités pour tous"),
                    _buildOptionCard('View', Color(0xFFEF6C00), "Emplacements spectaculaires avec vues"),
                    SizedBox(height: 20),
                    // Bouton pour continuer
                    ElevatedButton(
                      onPressed: _selectedType == null ? null : _savePreferredType,
                      child: Text(
                        'Suivant',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedType == null ? Colors.grey : _selectedColor,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour construire une carte d'option
  Widget _buildOptionCard(String type, Color color, String description) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => _selectType(type, color),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Réduire la hauteur
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity, // Augmenter la largeur
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withOpacity(0.9),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligner le texte à gauche
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 20, // Ajuster la taille de la police
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 5), // Ajuster l'espacement
            Text(
              description,
              style: TextStyle(
                fontSize: 14, // Ajuster la taille de la police
                color: isSelected ? Colors.white70 : Colors.black45,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour sélectionner le type de séjour
  void _selectType(String type, Color color) {
    setState(() {
      _selectedType = type;
      _selectedColor = color;
    });
  }

  // Fonction pour enregistrer le type de séjour préféré
  void _savePreferredType() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedType != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'preferredStayType': _selectedType,
      });
      // Navigation vers l'écran de sélection du niveau d'expérience
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserLevelScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez vous connecter pour enregistrer vos préférences.')));
    }
  }
}
