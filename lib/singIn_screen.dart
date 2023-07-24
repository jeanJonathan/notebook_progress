import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook_progress/form_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // L'utilisateur est connecté avec succès, effectuez les actions souhaitées ici
      // Si la connexion reussie aller vers l'ecran du formulaire.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormScreen(), // Remplacez "AutreEcran" par l'écran que vous souhaitez afficher après la connexion réussie.
        ),
      );
    } catch (e) {
      // Une erreur s'est produite lors de l'authentification, affichez un message d'erreur ou effectuez des actions supplémentaires ici
      print('Erreur lors de l\'authentification : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
