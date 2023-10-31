import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'etape.dart'; // Assurez-vous que le fichier etape.dart est importé correctement

import 'singIn_screen.dart';
import 'form_screen.dart';

class EtapeDetailScreen extends StatelessWidget {
  final String etapeId;
  final Etape etape;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EtapeDetailScreen({required this.etape, required this.etapeId});

  @override
  Widget build(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(etape.video) ?? '';
    String youtubeUrl = 'https://www.youtube.com/embed/$videoId';

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
            color: Colors.black.withOpacity(0.6),
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
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    etape.description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: WebView(
                    initialUrl: youtubeUrl,
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
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
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      primary: Colors.blue, // Changer la couleur du bouton selon vos besoins
                    ),
                    child: Text(
                      'Valider l\'étape',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Changer la couleur du texte selon vos besoins
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

  void _navigateToFormScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
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
  }

  void _navigateToSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(etapeId: etape.etapeId),
      ),
    );
  }
}
