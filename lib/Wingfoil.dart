import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/etapes_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'Surf.dart';
import 'kitesurf.dart';
import 'package:url_launcher/url_launcher.dart';

class Wingfoil extends StatelessWidget {
  Offset? _initialPosition;
  bool _showSwipeIndicator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min, // Utilisez l'espace minimum nécessaire
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                const url = 'https://oceanadventure.surf/'; // URL de votre choix
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Image.asset(
                'assets/logoOcean.png',
                width: 250, // Ajustez la largeur comme vous le souhaitez
                height: 205, // Ajustez la hauteur comme vous le souhaitez
              ),
            ),
          ],
        ), // Titre vide pour cet exemple
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
                User user = snapshot.data!;
                String initials = '';
                if (user.email != null) {
                  initials = user.email!.split('@').first[0].toUpperCase();
                  if (user.email!.split('@').first.length > 1) {
                    initials += user.email!.split('@').first[1].toUpperCase();
                  }
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ParametresScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Utilisez l'espace minimum nécessaire
                      children: [
                        Text(initials, style: TextStyle(fontSize: 16, color: Color(0xFF64C8C8),fontFamily: 'Open Sans')), // Les initiales de l'utilisateur
                        SizedBox(width: 4), // Espacement entre le texte et l'icône
                        Icon(Icons.person, color: Color(0xFF64C8C8)), // Icône avec la couleur modifiée
                      ],
                    ),
                  ),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    // Rediriger vers l'écran de connexion
                  },
                );
              }
            },
          ),
        ],
      ),
        body:
        Stack(
          children: [
            Image.asset(
              'assets/wingfoil.png',
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
                  'Faites glisser vers la gauche pour Wingfoil, et vers la droite pour Kitesurf',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              top: 250,
              left: 5,
              child: Icon(Icons.arrow_back_ios, size: 50, color: Color(0xFFF5F5F5)),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 16,
              right: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'WING FOIL',
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
                      color: Color(0xFF074868),
                      fontFamily: 'Concert One',
                    ),
                  ),
                  SizedBox(height: 46),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EtapesScreenWingfoil()),
                      );
                    },
                    child: Text(
                      'VOIR LES ÉTAPES',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF074868),
                        fontFamily: 'Open Sans',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ), backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
      );
  }
}
