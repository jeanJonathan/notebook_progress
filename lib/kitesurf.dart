import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Wingfoil.dart';

class Kitesurf extends StatelessWidget {
  Offset? _initialPosition;
  bool _showSwipeIndicator = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        _initialPosition = details.globalPosition;
        _showSwipeIndicator = true; // Pour afficher l'indicateur au début du glissement
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (_initialPosition != null) {
          final offset = details.globalPosition;
          final difference = offset.dx - _initialPosition!.dx;

          // Si le mouvement est vers la droite
          if (difference < 10) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wingfoil()));
          }
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _initialPosition = null;
        _showSwipeIndicator = false; // Pour masquer l'indicateur lorsque le glissement se termine
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          actions: [
            const SizedBox(width: kToolbarHeight),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      const url = 'https://www.ion-club.net/fr/home/'; // Remplacer par l'URL souhaitée
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                      'assets/logoIONCLUB.png',
                      width: 130,
                      height: 135,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      const url = 'https://oceanadventure.surf/'; // Remplacer par l'URL souhaitée
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                      'assets/logoOcean.png',
                      width: 145,
                      height: 140,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/parametres');
              },
            ),
          ],
          title: const Text(''),
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/kitesurf3.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            if (_showSwipeIndicator)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: 16,
                right: 16,
                child: Text(
                  'Faites glisser vers la gauche pour Wingfoil',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 16,
              right: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'KITE SURF',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64C8C8),
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                      fontFamily: 'Concert One',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Let's while",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Concert One',
                    ),
                  ),
                  SizedBox(height: 46),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/etapesK');
                    },
                    child: Text(
                      'VOIR LES ÉTAPES',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 250,
              right: 5,
              child: Icon(Icons.arrow_forward_ios, size: 50, color: Color(0xFFF5F5F5)),
            ),
          ],
        ),
      ),
    );
  }
}
