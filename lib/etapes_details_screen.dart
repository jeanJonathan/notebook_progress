import 'package:flutter/material.dart';
import 'package:notebook_progress/etape.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EtapeDetailScreen extends StatelessWidget {
  final Etape etape;

  EtapeDetailScreen({required this.etape});

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
                    onPressed: () {
                      // Action à effectuer lors du clic sur le bouton "Valider l'étape"
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

