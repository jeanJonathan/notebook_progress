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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Préféreriez-vous un séjour plus tôt ?",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          _buildOptionCard('Festif', Colors.deepOrangeAccent[200]!, "Animations, concerts, et vie nocturne"),
          _buildOptionCard('Tranquille', Colors.lightBlue[200]!, "Détente, nature, et calme"),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: _selectedType == null ? null : _savePreferredType,
            child: Text('Suivant',style: TextStyle(fontSize: 18, color: Colors.white),),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF64C8C8),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String type, Color color, String description) {
    return GestureDetector(
      onTap: () => _selectType(type),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _selectedType == type ? color : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Text(type, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text(description, style: TextStyle(fontSize: 16, color: Colors.white70)),
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
      // Assuming ExperienceLevelScreen is already set up
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExperienceLevelScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to save your preferences.'))
      );
    }
  }
}
