import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/etapes_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/recommandation_service.dart';
import 'package:notebook_progress/ocean_adventure_home.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'Wingfoil.dart';
import 'Surf.dart';
import 'home.dart';
import 'package:url_launcher/url_launcher.dart';

class KitesurfScreen extends StatelessWidget {
  Offset? _initialPosition;
  bool _showSwipeIndicator = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        _initialPosition = details.globalPosition;
        _showSwipeIndicator = true; // Affichage de l'indicateur de glissement
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (_initialPosition != null) {
          final offset = details.globalPosition;
          final difference = offset.dx - _initialPosition!.dx;

          // Si le mouvement est vers la gauche
          if (difference < -10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => WingfoilScreen()));
          }
          // Si le mouvement est vers la droite
          if (difference > 10) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SurfScreen()));
          }
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _initialPosition = null;
        _showSwipeIndicator = false; // Masquage de l'indicateur de glissement
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // Hauteur ajustée pour correspondre à l'autre écran
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MenuScreen()),
                      );
                    },
                  ),
                  GestureDetector(
                    onTap: () async {
                      const url = 'https://oceanadventure.surf/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Image.asset(
                      'assets/logoOcean.png',
                      width: 250,
                      height: 100,
                    ),
                  ),
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
                              _showLogoutDialog(context); // Affichage du dialogue de déconnexion
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(initials, style: TextStyle(fontSize: 16, color: Color(0xFF64C8C8), fontFamily: 'Open Sans')),
                                SizedBox(width: 4),
                                Icon(Icons.logout, color: Color(0xFF64C8C8)), // Icône de déconnexion
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
            ),
            title: const Text(''),
          ),
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
                RecommendationService recommendationService = RecommendationService();
                recommendationService.getRecommendedCamps().then((recommendedCamps) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(recommendedCamps: recommendedCamps)),
                  );
                });
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
                  MaterialPageRoute(builder: (context) => KitesurfScreen()),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Voulez-vous vraiment vous déconnecter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => OceanAdventureHome()), // Redirige vers l'écran de connexion
                );
              },
              child: Text('Déconnexion',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
