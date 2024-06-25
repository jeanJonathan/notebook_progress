import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'authentification.dart';

void main() => runApp(OceanAdventureApp());

class OceanAdventureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocean Adventure Surf',
      home: OceanAdventureHome(),
    );
  }
}

class OceanAdventureHome extends StatefulWidget {
  @override
  _OceanAdventureHomeState createState() => _OceanAdventureHomeState();
}

class _OceanAdventureHomeState extends State<OceanAdventureHome> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/demarrage.mp4')
      ..initialize().then((_) {
        setState(() {});
      })..setLooping(true)..play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logoOcean.png', // Remplacez par le chemin de votre image/logo
                width: 300,
                height: 100,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
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
              OutlinedButton(
                onPressed: () {},
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
    _controller.dispose();
  }
}
