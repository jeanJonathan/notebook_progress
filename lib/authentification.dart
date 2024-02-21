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
                  Text(
                    'Vous n\'avez pas de compte ? Inscrivez-vous ici',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'E-mail'),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _signUpWithEmailPassword,
                    child: Text('SE CONNECTER'),
                  ),
                  SizedBox(height: 10),
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
                  SizedBox(height: 8),
                  // Bouton pour la connexion Google
                  ElevatedButton.icon(
                    icon: Image.asset('assets/icones/facebook.png', height: 24.0), // Mettez le logo de Google
                    label: Text('Continuer avec Google'),
                    onPressed: _signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Bords arrondis
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0), // Ajustez le padding si nécessaire
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset('assets/icones/google.png', height: 24.0), // Mettez le logo de Facebook
                    label: Text('Continuer avec Facebook'),
                    onPressed: _signInWithFacebook,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Bords arrondis
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0), // Ajustez le padding si nécessaire
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: Image.asset('assets/icones/logo-apple.png', height: 24.0), // Mettez le logo d'Apple
                    label: Text('Continuer avec Apple'),
                    onPressed: _signInWithApple,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Bords arrondis
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.0), // Ajustez le padding si nécessaire
                    ),
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
