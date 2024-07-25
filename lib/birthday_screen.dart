import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/preferred_staytype_screen.dart';

class BirthdateScreen extends StatefulWidget {
  @override
  _BirthdateScreenState createState() => _BirthdateScreenState();
}

class _BirthdateScreenState extends State<BirthdateScreen> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Date de naissance",
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Quelle est votre date de naissance ?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64C8C8),
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _pickDate(context),
                icon: Icon(Icons.calendar_today, color: Colors.white),
                label: Text(
                  _selectedDate == null
                      ? "Sélectionner la date"
                      : "Né le: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} (${DateTime.now().year - _selectedDate!.year} ans)",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF64C8C8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _selectedDate == null || (DateTime.now().year - _selectedDate!.year < 18) ? null : _saveBirthdate,
                child: Text(
                  'Suivant',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF64C8C8),
                  disabledBackgroundColor: Colors.grey.withOpacity(0.12),
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(1900),
      lastDate: eighteenYearsAgo,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF64C8C8), // Color of the header
              onPrimary: Colors.white, // Color of the header text
              onSurface: Colors.black, // Color of the body text
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate && picked.isBefore(eighteenYearsAgo.add(Duration(days: 1)))) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveBirthdate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedDate != null && (DateTime.now().year - _selectedDate!.year >= 18)) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'birthdate': _selectedDate,
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => PreferredStayTypeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Veuillez vous connecter pour enregistrer votre date de naissance.'))
      );
    }
  }
}
