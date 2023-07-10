import 'package:flutter/material.dart';

class ParametresScreen extends StatefulWidget {
  @override
  _ParametresScreenState createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<ParametresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Essayer la version premium gratuitement'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Essayer la version premium gratuitement"
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Mon profil'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Mon profil"
            },
          ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('Objectifs'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Objectifs"
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Centre de confidentialité'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Centre de confidentialité"
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Partage et vie privée'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Partage et vie privée"
            },
          ),ListTile(
            leading: Icon(Icons.help),
            title: Text('Aide'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Aide"
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Déconnexion'),
            onTap: _deconnexion, // Appel de la fonction de déconnexion
          ),
        ],
      ),
    );
  }

  void _deconnexion() {//fonction pour gerer la deconnexion
  }
}