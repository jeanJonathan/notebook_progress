import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/etapes_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/search_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Wingfoil.dart';
import 'Surf.dart';
import 'welcome_screen.dart';

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
              'assets/kitesurf.jpg',
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
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF64C8C8),
          unselectedItemColor: Colors.grey,
          iconSize: 30,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color(0xFF64C8C8)),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Color(0xFF64C8C8)),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school, color: Color(0xFF64C8C8)),
              label: 'Tutoriels',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: Color(0xFF64C8C8)),
              label: 'Profil',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen(recommendedCamps: [])),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kitesurf()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}
