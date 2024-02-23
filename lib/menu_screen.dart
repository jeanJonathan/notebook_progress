import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          /*
          ListTile(
            leading: Text('👥',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Qui sommes nous'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Qui sommes nous"
            },
          ),
          ListTile(
            leading: Text('📇',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Contact'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Contact"
            },
          ),
          ListTile(
            leading: Text('🔑',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Connexion'),
            onTap: () {
              // Action lorsque l'utilisateur clique sur "Connexion"
            },
          ),*/
          ListTile(
            leading: Text('🌐',
              style: TextStyle(
                fontSize: 26,),
            ),
            title: Text('Accéder au site'),
            onTap: () async {
              const url = 'https://oceanadventure.surf/';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                // Afficher une erreur ou gérer l'incapacité à lancer l'URL
              }
            },
          ),
        ],
      ),
    );
  }
}
