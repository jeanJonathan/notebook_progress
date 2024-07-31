/*
 ******************************************************************************
 * UserAuthenticationScreen.dart
 *
 * Ce fichier définit l'écran d'authentification de l'application,
 * offrant des options pour l'authentification via email et mot de passe,
 * Google Sign-In, et Apple Sign-In... Il fournit également une navigation vers
 * l'écran d'inscription et la récupération de mot de passe.
 *
 * Fonctionnalités :
 * - Authentification utilisateur par email et mot de passe.
 * - Authentification tierce avec Google et Apple.
 * - Redirection vers l'écran de création de profil après connexion réussie.
 * - Option de récupération de mot de passe.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, google_sign_in, flutter_facebook_auth, sign_in_with_apple
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notebook_progress/singUp_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/gestures.dart';
import 'create_profile_start.dart';
import 'StartupScreen.dart';

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

  // Connexion via email et mot de passe
  Future<void> _signInWithEmailPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigation vers l'écran de création de profil après une connexion réussie
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CreateProfileStart()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Erreur de connexion', e.message);
    }
  }

  // Connexion via Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigation vers l'écran de création de profil après une connexion réussie
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CreateProfileStart()),
        );
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Erreur de connexion avec Firebase', e.message);
    } catch (e) {
      _showErrorDialog('Erreur lors de la connexion avec Google', e.toString());
    }
  }

  // Connexion via Apple
  Future<void> _signInWithApple() async {
    try {
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      // Navigation vers l'écran de création de profil après une connexion réussie
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CreateProfileStart()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Erreur de connexion avec Firebase', e.message);
    } catch (e) {
      _showErrorDialog('Erreur lors de la connexion avec Apple', e.toString());
    }
  }

  // Affichage des messages d'erreur
  void _showErrorDialog(String title, String? message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message ?? 'Une erreur est survenue. Veuillez réessayer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Réinitialisation du mot de passe
  void _resetPassword() {
    showDialog(
      context: context,
      builder: (context) {
        final emailController = TextEditingController();
        return AlertDialog(
          title: Text('Réinitialiser le mot de passe'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Entrez votre e-mail'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('E-mail de réinitialisation envoyé')),
                );
              },
              child: Text('Envoyer'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Détecter les glissements horizontaux pour la navigation
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => OceanAdventureApp()),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4, // 1/4 de la longueur de l'écran
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/connexion.jpg'), // Image d'arrière-plan
                    fit: BoxFit.cover, // Couvre la largeur de l'écran
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Lien vers l'inscription
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(text: 'Vous n\'avez pas de compte ? '),
                          TextSpan(
                            text: 'Inscrivez-vous ici',
                            style: TextStyle(color: Color(0xFF64C8C8)),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpScreen()));
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 26),
                    // Champ de texte pour l'email
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'E-mail'),
                    ),
                    SizedBox(height: 15),
                    // Champ de texte pour le mot de passe
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                    ),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: Text(
                          'Mot de passe oublié ?',
                          style: TextStyle(color: Color(0xFF64C8C8)),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    // Bouton de connexion
                    ElevatedButton(
                      onPressed: _signInWithEmailPassword,
                      child: Text(
                        'SE CONNECTER',
                        style: TextStyle(
                          color: Color(0xFF64C8C8), // Couleur du texte
                        ),
                      ),
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
                        // Bouton de connexion via Google
                        ElevatedButton(
                          onPressed: _signInWithGoogle,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            side: BorderSide(color: Colors.grey[300]!, width: 1),
                            alignment: Alignment.centerLeft,
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/icones/google.png', height: 24.0),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  'Continuer avec Google',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Bouton de connexion via Apple
                        ElevatedButton(
                          onPressed: _signInWithApple,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            side: BorderSide(color: Colors.grey[300]!, width: 1),
                            alignment: Alignment.centerLeft,
                          ),
                          child: Row(
                            children: [
                              Image.asset('assets/icones/logo-apple.png', height: 24.0),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  'Continuer avec Apple',
                                  textAlign: TextAlign.center,
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
      ),
    );
  }
}
