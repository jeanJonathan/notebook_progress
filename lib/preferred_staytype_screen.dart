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
        title: Text("Type de séjour préféré"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/pref.jpg'), // Path to your background image in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content over the background image
          Container(
            color: Colors.black.withOpacity(0.5), // Optional: Add a semi-transparent overlay for better contrast
            child: Center( // Use Center to align children both horizontally and vertically
              child: Column(
                mainAxisSize: MainAxisSize.min, // Centers the column vertically in the available space
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Préféreriez-vous un séjour plus tôt ?",
                      style: theme.textTheme.headline6?.copyWith(color: Colors.white), // Ensure the text is visible on the background
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildOptionCard('Festif', Color(0xFF0077B6), "Animations, concerts, et vie nocturne"),
                  _buildOptionCard('Tranquille', Color(0xFF2D2F31), "Détente, nature, et calme"),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _selectedType == null ? null : _savePreferredType,
                    child: Text('Suivant'),
                    style: ElevatedButton.styleFrom(
                      disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Color when disabled
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: theme.textTheme.button,
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
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[200]?.withOpacity(0.9), // Slightly transparent when not selected
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please log in to save your preferences.')));
    }
  }
}
