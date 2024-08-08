import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/singIn_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'etape.dart';
import 'form_screen.dart';

class EtapeDetailScreen extends StatefulWidget {
  final String etapeId;
  final String sportRef;
  final Etape etape;

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
    WidgetsBinding.instance.addObserver(this); // Ajout de l'observateur
    String videoId = YoutubePlayer.convertUrlToId(widget.etape.video) ?? '';
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
    WidgetsBinding.instance.removeObserver(this); // Retrait de l'observateur
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
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
              if (orientation == Orientation.portrait)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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

  void _navigateToSignInScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(etapeId: widget.etape.etapeId),
      ),
    );
  }
}
