import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BirthdateScreen extends StatefulWidget {
  @override
  _BirthdateScreenState createState() => _BirthdateScreenState();
}

class _BirthdateScreenState extends State<BirthdateScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quelle est votre date de naissance ?"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Choisissez votre date de naissance",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(
              _selectedDate == null
                  ? "Date de naissance (0 ans)"
                  : "Date de naissance: ${_selectedDate!.day} ${_selectedDate!.month} ${_selectedDate!.year} (${DateTime.now().year - _selectedDate!.year} ans)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _pickDate(context),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedDate == null ? null : _saveBirthdate,
            child: Text('Suivant'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Color when disabled
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveBirthdate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedDate != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'birthdate': _selectedDate,
      });
      Navigator.of(context).pushNamed('/nextScreen'); // Adjust the route as necessary
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in to save your birthdate.'))
      );
    }
  }
}
