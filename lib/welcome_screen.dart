import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'kitesurf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recommendedCamps;

  WelcomeScreen({required this.recommendedCamps});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late PageController _pageController;
  late PageController _imagePageController;

  Map<String, bool> favoriteCamps = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _imagePageController = PageController();
    _initializeFavorites();
  }

  void _initializeFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> camps = userData['camps'] ?? [];
        setState(() {
          favoriteCamps = {for (var camp in camps) camp['camp_link']: true};
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
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
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Image.asset(
                  'assets/logoOcean.png',
                  width: 250,
                  height: 100,
                ),
                SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: widget.recommendedCamps.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Aucun camp ne correspond aux critères renseignés. Veuillez réessayer avec d'autres préférences.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : PageView.builder(
        controller: _pageController,
        itemCount: widget.recommendedCamps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = widget.recommendedCamps[index];
          bool isFavorite = favoriteCamps[camp['booking_link']] ?? false;
          return GestureDetector(
            onTapDown: (TapDownDetails details) {
              double screenWidth = MediaQuery.of(context).size.width;
              if (details.localPosition.dx < screenWidth / 2) {
                if (_imagePageController.page!.toInt() > 0) {
                  _imagePageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              } else {
                if (_imagePageController.page!.toInt() < camp['image_urls'].length - 1) {
                  _imagePageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    controller: _imagePageController,
                    itemCount: camp['image_urls'].length,
                    itemBuilder: (context, imageIndex) {
                      return Image.network(
                        camp['image_urls'][imageIndex],
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.error, color: Colors.red, size: 50));
                        },
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(camp['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(camp['description'], style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('Activités: ${camp['activities'].join(', ')}', style: TextStyle(fontSize: 16, color: Colors.white)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          MaterialButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            onPressed: () => _launchURL(camp['booking_link']),
                            child: Text('Visitez maintenant'),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 36,
                            ),
                            onPressed: () => _toggleWishlist(camp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: widget.recommendedCamps.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Color(0xFF64C8C8),
                        dotColor: Colors.white,
                        dotHeight: 8.0,
                        dotWidth: 8.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _toggleWishlist(Map<String, dynamic> camp) async {
    User? user = FirebaseAuth.instance.currentUser; // Récupère l'utilisateur actuel
    if (user != null) {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid); // Référence au document de l'utilisateur
      DocumentSnapshot docSnapshot = await userDoc.get(); // Récupère le document de l'utilisateur

      // Crée un objet avec les données essentielles du camp
      Map<String, dynamic> campData = {
        'camp_link': camp['booking_link'], // Identifiant unique du camp
        'name': camp['name'], // Nom du camp
        'image_url': camp['image_urls'].isNotEmpty ? camp['image_urls'][0] : '', // Image représentative du camp
      };

      if (docSnapshot.exists) {
        // Si le document existe
        Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> camps = userData['camps'] ?? []; // Récupère la liste des camps ou crée une nouvelle liste vide

        int index = camps.indexWhere((item) => item['camp_link'] == camp['booking_link']);
        if (index >= 0) {
          camps.removeAt(index); // Supprime le camp de la liste
          setState(() {
            favoriteCamps.remove(camp['booking_link']);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camp retiré de votre wishlist')));
        } else {
          camps.insert(0, campData); // Ajoute le camp au début de la liste
          setState(() {
            favoriteCamps[camp['booking_link']] = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camp ajouté à votre wishlist')));
        }

        await userDoc.update({'camps': camps}); // Met à jour la liste des camps dans Firestore
      } else {
        // Si le document n'existe pas
        Map<String, dynamic> newUserDoc = {
          'camps': [campData], // Crée un nouveau document avec une liste contenant le camp
        };
        await userDoc.set(newUserDoc);

        setState(() {
          favoriteCamps[camp['booking_link']] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camp ajouté à votre wishlist')));
      }
    }
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
            break; // Désactivé sur l'écran d'accueil
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
    );
  }
}
