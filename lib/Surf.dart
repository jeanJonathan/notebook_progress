import 'package:flutter/material.dart';
import 'package:notebook_progress/etapes_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/search_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'Wingfoil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'kitesurf.dart';

class Surf extends StatelessWidget {
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Kitesurf()));
          }
          // Si le mouvement est vers la droite
          if (difference > 10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Wingfoil()));
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
                  // Le texte a été supprimé pour mettre en évidence le logo
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
              'assets/surf.jpg',
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
                  'Faites glisser vers la gauche pour Kitesurf, et vers la droite pour Wingfoil',
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
                    'SURF',
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
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EtapesScreenSurf()),
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
                break;
              case 1:
              // Naviguer vers la wishlist
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WishlistScreen()),
                );
                break;
              case 2:
              // Naviguer vers la page de recherche
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
                break;
              case 3:
              // Naviguer vers la page de tutoriel
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kitesurf()),
                );
                break;
              case 4:
              // Naviguer vers la page de profil
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
