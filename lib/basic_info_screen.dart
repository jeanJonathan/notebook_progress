import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'birthday_screen.dart';

class BasicInfoScreen extends StatefulWidget {
  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment vous appelez-vous ?"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 24),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF64C8C8), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre prénom' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF64C8C8), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Veuillez entrer votre nom' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF64C8C8), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value == null || !value.contains('@') ? 'Veuillez entrer un email valide' : null,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Suivant'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF64C8C8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      _saveInfoToFirestore();
    }
  }
  void _saveInfoToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
        });
        // Affichez un message de succès ou naviguez vers une autre page
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Informations enregistrées avec succès!'))
        );
        // Redirection vers l'écran des détails démographiques
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BirthdateScreen()),
        );
        //Navigator.of(context).pushNamed('/demographicDetailsScreen');
      } catch (e) {
        // Affichez une erreur si l'enregistrement échoue
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l enregistrement des informations. Veuillez réessayer.'))
        );
      }
    } else {
      // Gérez le cas où l'utilisateur n'est pas connecté ou l'instance est nulle
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun utilisateur connecté trouvé. Veuillez vous connecter et réessayer.'))
      );
    }
  }
}
