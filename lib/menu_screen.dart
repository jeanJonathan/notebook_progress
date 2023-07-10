import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.people_outlined),
            title: Text('Qui sommes nous'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Essayer la version premium gratuitement"
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_page),
            title: Text('Contact'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Mon profil"
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: Text('Connexion'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Objectifs"
            },
          ),
          ListTile(
            leading: Icon(Icons.travel_explore_outlined),
            title: Text('Acceder au site'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Centre de confidentialité"
            },
          ),
        ],
      ),
    );
  }
}