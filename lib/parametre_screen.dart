import 'package:flutter/material.dart';
import 'package:notebook_progress/singIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notebook_progress/startup_screen.dart';

class ParametresScreen extends StatefulWidget {
  @override
  _ParametresScreenState createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        children: [
          /*ListTile(
            leading: Text('⭐',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Essayer la version premium gratuitement '),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Essayer la version premium gratuitement"
            },
          ),
          ListTile(
            leading: Text('👤',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Mon profil '),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Mon profil"
            },
          ),
          ListTile(
            leading: Text('🚩',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Objectifs'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Objectifs"
            },
          ),
          ListTile(
            leading: Text('🔒',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Centre de confidentialité'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Centre de confidentialité"
            },
          ),
          ListTile(
            leading: Text('🙈',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Partage et vie privée '),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Partage et vie privée"
            },
          ),
          ListTile(
            leading: Text('❓',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Aide'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Aide"
            },
          ),  */
          ListTile(
            leading: Text('🚪',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Déconnexion'),
            onTap: _deconnexion, // Appel de la fonction de déconnexion
          ),
        ],
      ),
    );
  }

  Future<void> _deconnexion() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OceanAdventureHome()), // Redirection vers l'écran de connexion
      );
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
      // Gérer les erreurs lors de la déconnexion, si nécessaire
    }
  }
}
