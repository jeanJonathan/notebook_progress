import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:notebook_progress/singUp_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/gestures.dart';
import 'create_profile_start.dart';
import 'splash_screen.dart';

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

  Future<void> _signInWithEmailPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CreateProfileStart()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Erreur de connexion', e.message);
    }
  }

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

        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => CreateProfileStart()),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorDialog('Erreur de connexion avec Firebase', e.message);
    } catch (e) {
      _showErrorDialog('Erreur lors de la connexion avec Apple', e.toString());
    }
  }

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
                    ElevatedButton(
                      onPressed: _signInWithEmailPassword,
                      child: Text(
                        'SE CONNECTER',
                        style: TextStyle(
                          color: Color(0xFF64C8C8), // Ici, nous définissons la couleur du texte.
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
