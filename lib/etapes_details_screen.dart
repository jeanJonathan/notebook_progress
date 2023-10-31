import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/etape.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'singIn_screen.dart';
import 'form_screen.dart';

class EtapeDetailScreen extends StatelessWidget {
  final String etapeId; // Variable pour stocker l'identifiant de l'étape
  final Etape etape;
  final FirebaseAuth _auth = FirebaseAuth.instance; //

  EtapeDetailScreen({required this.etape,required this.etapeId});

  @override
  Widget build(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(etape.video) ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Description de l\'étape',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/desc_etapes.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Modifier la couleur et l'opacité du filtre de superposition selon vos besoins
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Center(
                  child: Text(
                    etape.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Modifier la couleur du texte selon vos besoins
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    etape.description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Modifier la couleur du texte selon vos besoins
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // Définir le rapport d'aspect de la vidéo selon vos besoins
                    child: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: videoId,
                        flags: YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.amber,
                      progressColors: ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Action à effectuer lors du clic sur le bouton "Valider l'étape"
                      // On verifie si l'utilisateur est déjà connecté
                      if (_auth.currentUser != null) {
                        // On navigue vers l'écran du formulaire FormScreen
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 250),
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return FormScreen(etapeRef: etape.etapeId);
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
                      } else {
                        // On navigue vers l'écran d'authentification (SignInScreen par exemple)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(etapeId: etape.etapeId),
                            ),
                          );
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      //primary: Colors.blue, // Modifier la couleur du bouton selon vos besoins
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Valider l\'étape',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        //color: Colors.white, // Modifier la couleur du texte selon vos besoins
                      ),
                    ),

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


