import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'wave_cliper.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerAccount() async {
    if (_formKey.currentState!.validate()) {
      // Assurez-vous que les mots de passe correspondent avant d'essayer de créer un compte
      if (_passwordController.text == _confirmPasswordController.text) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
          // Enregistrement réussi - Naviguer vers la page suivante ou afficher un message de succès
        } on FirebaseAuthException catch (e) {
          // Gérer les erreurs d'enregistrement, par exemple en affichant un message d'erreur
        }
      } else {
        // Gérer le cas où les mots de passe ne correspondent pas
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

