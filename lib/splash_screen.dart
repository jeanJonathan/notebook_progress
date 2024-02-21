import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
    _controller = VideoPlayerController.asset('assets/Canaries.mp4')
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
              Text(
                'YOUR WORLD. OCEAN ADVENTURE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: Text('S\'authentifier ou S\'inscrire'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.blue,
                ),
              ),
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {},
                child: Text('Découvrir les avantages de l\'application'),
                style: OutlinedButton.styleFrom(
                  primary: Colors.white,
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
