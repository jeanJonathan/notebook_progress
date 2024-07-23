import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/etapes_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Wingfoil.dart';
import 'Surf.dart';

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

          // Si le mouvement est vers la gauche
          if (difference < -10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Wingfoil()));
          }
          // Si le mouvement est vers la droite
          if (difference > 10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Surf()));
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
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
                      const url = 'https://oceanadventure.surf/'; // URL de votre choix
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                      'assets/logoOcean.png',
                      width: 200, // Ajustez la largeur comme vous le souhaitez
                      height: 205, // Ajustez la hauteur comme vous le souhaitez
                    ),
                  ),
                  SizedBox(width: 10), // Vous pouvez ajuster l'espace si nécessaire
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ParametresScreen()),
                );
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
                  '👉 Faites glisser vers la gauche pour Wingfoil 👈',
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
                    '🌊 KITE SURF 🌊',
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
                    "Let's ride the waves! 🏄‍♂️",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Concert One',
                    ),
                  ),
                  SizedBox(height: 46),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EtapesScreenKitesurf()),
                      );
                    },
                    child: Text(
                      'VOIR LES ÉTAPES 📝',
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
                      ),
                      backgroundColor: Colors.white,
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
          selectedItemColor: Color(0xFF64C8C8), // Highlight the selected icon
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
