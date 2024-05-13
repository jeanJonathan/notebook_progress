import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        _saveExperienceLevel();
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
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'experienceLevel': _selectedLevel,
      });
      // Optionally navigate to another screen or show a confirmation
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to save your preferences.'))
      );
    }
  }
}
