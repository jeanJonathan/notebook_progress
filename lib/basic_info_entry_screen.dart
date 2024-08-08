/*
 ******************************************************************************
 * basic_info_entry_screen.dart
 *
 * Ce fichier implémente l'écran de saisie des informations de base de l'utilisateur.
 * L'utilisateur entre son prénom et son nom, qui sont ensuite enregistrés dans Firestore.
 *
 * Fonctionnalités :
 * - Formulaire de saisie pour le prénom et le nom.
 * - Validation des champs de texte.
 * - Sauvegarde des informations dans Firestore.
 * - Navigation vers l'écran de saisie de la date de naissance.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'birthdate_entry_screen.dart';
import 'validator.dart';

class BasicInfoScreen extends StatefulWidget {
  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  @override
  void dispose() {
    // Libération des ressources
    _firstNameController.dispose();
    _lastNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface de l'écran
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Votre nom",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Entrez vos informations de base',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64C8C8),
                    fontFamily: 'Roboto',
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Champ de texte pour le prénom
                _buildTextField(_firstNameController, 'Prénom', Validator.validateName, _firstNameFocusNode),
                SizedBox(height: 16),
                // Champ de texte pour le nom
                _buildTextField(_lastNameController, 'Nom', Validator.validateName, _lastNameFocusNode),
                SizedBox(height: 30),
                // Bouton de soumission du formulaire
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Construction d'un champ de texte avec validation
  Widget _buildTextField(TextEditingController controller, String label, Function(String) validator, FocusNode focusNode) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color(0xFF64C8C8)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF64C8C8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF64C8C8), width: 2),
        ),
      ),
      cursorColor: Color(0xFF64C8C8),
      validator: (value) => validator(value ?? ''),
      onTap: () => focusNode.requestFocus(),
    );
  }

  // Construction du bouton de soumission
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
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
        backgroundColor: Color(0xFF64C8C8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: EdgeInsets.symmetric(vertical: 16),
        elevation: 5,
      ),
    );
  }

  // Soumission du formulaire
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _saveInfoToFirestore();
    }
  }

  // Sauvegarde des informations dans Firestore
  void _saveInfoToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
      }, SetOptions(merge: true));
      // Navigation vers l'écran de saisie de la date de naissance
      Navigator.push(context, MaterialPageRoute(builder: (context) => BirthdateScreen()));
    } else {
      // Affichage d'un message d'erreur si aucun utilisateur n'est connecté
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Aucun utilisateur connecté trouvé.')));
    }
  }
}
