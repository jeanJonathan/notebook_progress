/*
 ******************************************************************************
 * EtapeDetailScreen.dart
 *
 * Ce fichier implémente l'écran de détail d'une étape pour un sport spécifique.
 * Il permet la visualisation de la vidéo associée à l'étape et la validation
 * de l'étape après authentification de l'utilisateur.
 *
 * Fonctionnalités :
 * - Affichage de la vidéo YouTube associée à l'étape.
 * - Mise en pause automatique de la vidéo lorsque l'application passe en arrière-plan.
 * - Validation de l'étape après authentification de l'utilisateur.
 * - Navigation vers l'écran de connexion si l'utilisateur n'est pas authentifié.
 * - Affichage des boutons "Retour" et "Valider l'étape" en mode portrait.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, youtube_player_flutter, flutter
 ******************************************************************************
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/auth/singIn_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/etape.dart';
import 'form_screen.dart';

class EtapeDetailScreen extends StatefulWidget {
  final String etapeId; // ID de l'étape
  final String sportRef; // Référence du sport
  final Etape etape; // Instance de l'étape

  EtapeDetailScreen({
    required this.etape,
    required this.etapeId,
    required this.sportRef,
  });

  @override
  _EtapeDetailScreenState createState() => _EtapeDetailScreenState();
}

class _EtapeDetailScreenState extends State<EtapeDetailScreen> with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Ajout de l'observateur pour écouter les changements de cycle de vie de l'application
    String videoId = YoutubePlayer.convertUrlToId(widget.etape.video) ?? ''; // Extraction de l'ID de la vidéo YouTube
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        isLive: false,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Retrait de l'observateur lors de la destruction du widget
    _controller.dispose(); // Libération des ressources du contrôleur YouTube
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Mettre la vidéo en pause lorsque l'application passe en arrière-plan ou devient inactive
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              // Affichage du lecteur YouTube
              Expanded(
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () {
                    _controller.addListener(() {});
                  },
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                    FullScreenButton(),
                  ],
                ),
              ),
              // Affichage des boutons "Retour" et "Valider l'étape" uniquement en mode portrait
              if (orientation == Orientation.portrait)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Bouton "Retour"
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Color(0xFF64C8C8),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        label: Text(
                          'Retour',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Bouton "Valider l'étape"
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_auth.currentUser != null) {
                            _navigateToFormScreen(context);
                          } else {
                            _navigateToSignInScreen(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: Color(0xFF64C8C8),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                        icon: Icon(Icons.check, color: Colors.white),
                        label: Text(
                          'Valider l\'étape',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Navigation vers l'écran de formulaire pour valider l'étape
  void _navigateToFormScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FormScreen(
            etapeRef: widget.etape.etapeId,
            sportRef: widget.etape.sportRef.id,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var tween = Tween(begin: begin, end: end);
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  // Navigation vers l'écran de connexion si l'utilisateur n'est pas authentifié
  void _navigateToSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(etapeId: widget.etape.etapeId, sportRef: '',),
      ),
    );
  }
}
