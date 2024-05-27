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
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        _initialPosition = details.globalPosition;
        _showSwipeIndicator = true;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (_initialPosition != null) {
          final offset = details.globalPosition;
          final difference = offset.dx - _initialPosition!.dx;

          // Si le mouvement est vers la gauche
          if (difference < -10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Surf()));
          }
          // Si le mouvement est vers la droite
          if (difference > 10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Kitesurf()));
          }
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _initialPosition = null;
        _showSwipeIndicator = false;
      },
      child: Scaffold(
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
        body: Stack(
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
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Ensures all icons are shown
          selectedItemColor: Colors.deepPurple, // Highlight the selected icon
          unselectedItemColor: Colors.grey, // Color for unselected items
          iconSize: 30, // Increased icon size for better visibility
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz, color: Colors.red), // Placeholder icon
              label: '', // Removed label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.purple), // Icon for wishlist
              label: '', // Removed label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.blue), // Icon for search
              label: '', // Removed label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school, color: Colors.amber), // Icon for tutorial
              label: '', // Removed label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Colors.green), // Icon for profile
              label: '', // Removed label
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
              // Action pour l'icône placeholder (à définir)
                Navigator.pushNamed(context, '/placeholder');
                break;
              case 1:
              // Naviguer vers la wishlist
                Navigator.pushNamed(context, '/wishlist');
                break;
              case 2:
              // Naviguer vers la page de recherche
                Navigator.pushNamed(context, '/search');
                break;
              case 3:
              // Naviguer vers la page de tutoriel
                Navigator.pushNamed(context, '/tutorial');
                break;
              case 4:
              // Naviguer vers la page de profil
                Navigator.pushNamed(context, '/profile');
                break;
            }
          },
        ),
      ),
    );
  }
}
