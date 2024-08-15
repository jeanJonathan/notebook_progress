import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/tutoriels/etapes_screen.dart';
import 'package:notebook_progress/home/profile_screen.dart';
import 'package:notebook_progress/services/recommandation_service.dart';
import 'package:notebook_progress/home/ocean_adventure_home.dart';
import 'package:notebook_progress/home/wishlist_screen.dart';
import '../auth/user_authentication_screen.dart';
import 'Wingfoil.dart';
import 'Surf.dart';
import '../home/home.dart';
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
            Navigator.of(context).pushReplacement(_createPageTurnTransition(WingfoilScreen()));
          }
          // Si le mouvement est vers la droite
          if (difference > 10) {
            Navigator.of(context).pushReplacement(_createPageTurnTransition(SurfScreen(), isRightTurn: false));
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
                children: [
                  Expanded(
                    child: SizedBox(), // Espace vide pour pousser le logo au centre
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
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight, // Alignement à droite du bouton
                      child: StreamBuilder<User?>(
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
                                  _showLogoutDialog(context, isUserLoggedIn: true); // Affichage du dialogue de déconnexion
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
                            return Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: InkWell(
                                onTap: () {
                                  _showLogoutDialog(context, isUserLoggedIn: false); // Affichage du dialogue de connexion
                                },
                                child: Icon(Icons.login, color: Color(0xFF64C8C8)),
                              ),
                            );
                          }
                        },
                      ),
                    ),
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
                  textAlign: TextAlign.center,
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
          currentIndex: 2, // Cet écran est sur l'onglet "Tutoriels", donc index 2
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Tutoriels',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profil',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                RecommendationService recommendationService = RecommendationService();
                recommendationService.getRecommendedCamps().then((recommendedCamps) {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => HomeScreen(recommendedCamps: recommendedCamps),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                });
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => WishlistScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
              case 2:
              // Do nothing since we are on the KitesurfScreen which is already under "Tutoriels"
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => ProfileScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Route _createPageTurnTransition(Widget screen, {bool isRightTurn = true}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: isRightTurn ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, {required bool isUserLoggedIn}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUserLoggedIn ? 'Déconnexion' : 'Connexion'),
          content: Text(isUserLoggedIn
              ? 'Voulez-vous vraiment vous déconnecter?'
              : 'Voulez-vous vraiment vous connecter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Annuler',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (isUserLoggedIn) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => OceanAdventureHome()), // Redirige vers l'écran de connexion
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => AuthScreen()), // Redirige vers l'écran de connexion
                  );
                }
              },
              child: Text(
                isUserLoggedIn ? 'Déconnexion' : 'Connexion',
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
