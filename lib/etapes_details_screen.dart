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
        title: Text('Détails de l\'étape'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etape.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              etape.description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
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
          ],
        ),
      ),
    );
  }
}
