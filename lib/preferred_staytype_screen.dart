import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/experience_level_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/experience_level_screen.dart';

class PreferredStayTypeScreen extends StatefulWidget {
  @override
  _PreferredStayTypeScreenState createState() => _PreferredStayTypeScreenState();
}

class _PreferredStayTypeScreenState extends State<PreferredStayTypeScreen> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Type de séjour"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pref.jpg'), // Path to your background image in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    child: Text(
                      "Quel type de séjour préférez-vous ?",
                      style: theme.textTheme.headline6?.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildOptionCard('Adventure', Color(0xFF1B5E20), "Activités excitantes et explorations"),
                  _buildOptionCard('Relax', Color(0xFF01579B), "Retraites paisibles avec spa et yoga"),
                  _buildOptionCard('Culture', Color(0xFFF9A825), "Immersion culturelle et expériences locales"),
                  _buildOptionCard('Family', Color(0xFF6A1B9A), "Pour les familles avec activités pour tous"),
                  _buildOptionCard('View', Color(0xFFEF6C00), "Emplacements spectaculaires avec vues"),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _selectedType == null ? null : _savePreferredType,
                    child: Text('Continuer'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String type, Color color, String description) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => _selectType(type),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200]?.withOpacity(0.9),
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
          children: [
            Text(type, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16, color: isSelected ? Colors.white70 : Colors.black45)),
          ],
        ),
      ),
    );
  }

  void _selectType(String type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _savePreferredType() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedType != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'preferredStayType': _selectedType,
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => ExperienceLevelScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez vous connecter pour enregistrer vos préférences.')));
    }
  }
}
