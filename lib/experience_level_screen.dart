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
    return Scaffold(
      appBar: AppBar(
        title: Text("Niveau d'expérience"),
        backgroundColor: Color(0xFF64C8C8),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: _buildLevelCard('Débutant', 'assets/debutant.jpg', "Idéal pour les débutants ou ceux qui découvrent le sport.")),
          Expanded(child: _buildLevelCard('Intermédiaire', 'assets/intermediaire.jpg', "Pour ceux qui ont une certaine expérience et compétence.")),
          Expanded(child: _buildLevelCard('Avancé', 'assets/avance.jpg', "Conçu pour les experts qui maîtrisent pleinement le sport.")),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _selectedLevel != null ? _navigateOrConfirm : null,
              child: Text('Suivant', style: TextStyle(fontSize: 18,color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF64C8C8),
                disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Color when disabled
                padding: EdgeInsets.symmetric(vertical: 12),
                minimumSize: Size(double.infinity, 50), // Make the button wide
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded rectangle
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        ),
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.all(20),
        child: Text(
          level,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.greenAccent : Colors.white,
          ),
        ),
      ),
    );
  }

  void _saveExperienceLevel() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedLevel != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'experienceLevel': _selectedLevel,
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TravelPreferences()),
        ); // Move to the next screen only if save succeeds
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

  void _navigateOrConfirm() {
    _saveExperienceLevel();
  }
}