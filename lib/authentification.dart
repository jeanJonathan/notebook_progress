import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:notebook_progress/singUp_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:flutter/gestures.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4, // 1/4 de la longueur de l'écran
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/connexion.jpg'), // Votre image
                  fit: BoxFit.cover, // Couvre la largeur de l'écran
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(text: 'Vous n\'avez pas de compte ? '),
                        TextSpan(
                          text: 'Inscrivez-vous ici',
                          style: TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Insérez ici la logique pour naviguer vers l'écran d'inscription
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'E-mail'),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _signUpWithEmailPassword,
                    child: Text('SE CONNECTER'),
                  ),
                  SizedBox(height: 35),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('OU'),
                      ),
                      Expanded(
                        child: Divider(thickness: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 35),
                  Column(
                    children: [
                      // Bouton pour la connexion Google
                      ElevatedButton(
                        onPressed: _signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          side: BorderSide(color: Colors.grey[300]!, width: 1),
                          alignment: Alignment.centerLeft, // Aligner le contenu à gauche
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/icones/google.png', height: 24.0), // Le logo de Google
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Continuer avec Google',
                                textAlign: TextAlign.center, // Centrer le texte dans l'espace disponible
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Répétez le même pattern pour les autres boutons
                      ElevatedButton(
                        onPressed: _signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          side: BorderSide(color: Colors.grey[300]!, width: 1),
                          alignment: Alignment.centerLeft, // Aligner le contenu à gauche
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/icones/facebook.png', height: 24.0), // Le logo de Facebook
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Continuer avec Facebook',
                                textAlign: TextAlign.center, // Centrer le texte
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signInWithGoogle,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          side: BorderSide(color: Colors.grey[300]!, width: 1),
                          alignment: Alignment.centerLeft, // Aligner le contenu à gauche
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/icones/logo-apple.png', height: 24.0), // Le logo d'Apple
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                'Continuer avec Apple',
                                textAlign: TextAlign.center, // Centrer le texte
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
