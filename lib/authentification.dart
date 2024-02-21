import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Handle successful signup, such as navigating to the home screen
    } on FirebaseAuthException catch (e) {
      // Handle errors, such as displaying a snackbar
    }
  }

  Future<void> _signInWithGoogle() async {
    // TODO: Implement Google Sign-In
  }

  Future<void> _signInWithFacebook() async {
    // TODO: Implement Facebook Sign-In
  }

  Future<void> _signInWithApple() async {
    // TODO: Implement Apple Sign-In
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUpWithEmailPassword,
                child: Text('SE CONNNECTER'),
              ),
              TextButton(
                onPressed: _signInWithGoogle,
                child: Text('Continuer avec Google'),
              ),
              TextButton(
                onPressed: _signInWithFacebook,
                child: Text('Continuer avec Facebook'),
              ),
              TextButton(
                onPressed: _signInWithApple,
                child: Text('Continuer avec Apple'),
              ),
              // Ajoutez des liens vers votre politique de confidentialité et vos CGU ici
            ],
          ),
        ),
      ),
    );
  }
}
