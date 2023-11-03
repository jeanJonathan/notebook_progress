import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'etape.dart';
import 'singIn_screen.dart';
import 'form_screen.dart';

class EtapeDetailScreen extends StatelessWidget {
  final String etapeId;
  final String sportRef;
  final Etape etape;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  EtapeDetailScreen({required this.etape, required this.etapeId, required this.sportRef});

  @override
  Widget build(BuildContext context) {
    String videoId = YoutubePlayer.convertUrlToId(etape.video) ?? '';
    String youtubeUrl = 'https://www.youtube.com/embed/$videoId';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Description de l\'étape',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/desc_etapes.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6),
                  BlendMode.srcOver,
                ),
              ),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  '🚀 ${etape.name}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '🌟 ${etape.description}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
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
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_auth.currentUser != null) {
                      _navigateToFormScreen(context);
                    } else {
                      _navigateToSignInScreen(context);
                    }
                  },
                  icon: Icon(Icons.check, size: 24),
                  label: Text(
                    'Valider l\'étape',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    primary: Colors.white, // Changer la couleur du bouton selon vos besoins
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
          return FormScreen(etapeRef: etape.etapeId, sportRef: etape.sportRef.id);
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
