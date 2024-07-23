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
        title: Text("Date de naissance"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Quelle est votre date de naissance ?",
              style: theme.textTheme.headline6,
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
                style: theme.textTheme.bodyText1,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle: theme.textTheme.button,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _selectedDate == null || (DateTime.now().year - _selectedDate!.year < 18) ? null : _saveBirthdate,
              child: Text('Suivant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF64C8C8), // Active color
                disabledForegroundColor: Colors.grey.withOpacity(0.38), disabledBackgroundColor: Colors.grey.withOpacity(0.12), // Disabled color
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              ),
            ),
          ],
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
              primary: Colors.blue, // Color of the header
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
