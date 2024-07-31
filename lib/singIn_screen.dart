import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook_progress/form_screen.dart';
import 'package:notebook_progress/home.dart';

class SignInScreen extends StatefulWidget {
  final String etapeId; // Pour stocker l'identifiant de l'étape
  SignInScreen({required this.etapeId});
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
            builder: (context) => HomeScreen(recommendedCamps: [])),// // Remplacez "AutreEcran" par l'écran que vous souhaitez afficher après la connexion réussie.
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
        title: Text(''),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logoOcean.png',
                width: 250,
                height: 150,
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.black), // Couleur noire pour le label
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF64C8C8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                labelStyle: TextStyle(color: Colors.black), // Couleur noire pour le label
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF64C8C8)),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Se connecter'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), backgroundColor: Color(0xFF64C8C8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 6),
            TextButton(
              onPressed: () {
                // Action pour réinitialiser le mot de passe (à implémenter plustard)
              },
              child: Text(
                'Mot de passe oublié ?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}