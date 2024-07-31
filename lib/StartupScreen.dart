/*
 ******************************************************************************
 * StartupScreen.dart
 *
 * Ce fichier implémente l'écran de démarrage de l'application.
 * Cet écran sert d'introduction à l'application avec une vidéo de démarrage,
 * des options pour s'authentifier ou découvrir plus sur l'application.
 *
 * Fonctionnalités :
 * - Lecture automatique d'une vidéo d'introduction.
 * - Navigation vers l'écran d'authentification.
 * - Accès direct au site web externe de l'entreprise.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : url_launcher, video_player
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'UserAuthenticationScreen.dart';

void main() => runApp(OceanAdventureApp());

// Application principale
class OceanAdventureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Configuration de l'application avec la route initiale
    return MaterialApp(
      title: 'Ocean Adventure Surf',
      home: OceanAdventureHome(),
    );
  }
}

// Écran d'accueil principal avec vidéo de démarrage
class OceanAdventureHome extends StatefulWidget {
  @override
  _OceanAdventureHomeState createState() => _OceanAdventureHomeState();
}

class _OceanAdventureHomeState extends State<OceanAdventureHome> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur vidéo
    _controller = VideoPlayerController.asset('assets/demarrage.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setLooping(true) // La vidéo boucle continuellement
      ..play(); // Démarrage automatique de la vidéo
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface de l'écran d'accueil
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Affichage de la vidéo si elle est initialisée
          _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo de l'application
              Image.asset(
                'assets/logoOcean.png',
                width: 300,
                height: 100,
              ),
              SizedBox(height: 20),
              // Bouton pour se connecter ou s'inscrire
              ElevatedButton(
                onPressed: () {
                  // Navigation vers l'écran d'authentification
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                  );
                },
                child: Text('S\'AUTHENTIFIER OU S\'INSCRIRE'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF64C8C8), backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              // Bouton pour découvrir plus sur l'application
              OutlinedButton(
                onPressed: () async {
                  const url = 'https://oceanadventure.surf/';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text('DECOUVRIR LES AVANTAGES DE L\'APPLICATION'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Libération des ressources du contrôleur vidéo
    _controller.dispose();
  }
}
