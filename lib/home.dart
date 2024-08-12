import 'package:flutter/material.dart';
import 'package:notebook_progress/ocean_adventure_home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_authentication_screen.dart';
import 'kitesurf.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> recommendedCamps;

  HomeScreen({required this.recommendedCamps});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    User? user = FirebaseAuth.instance.currentUser;

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
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {
                        _showLogoutDialog(context); // Affichage du dialogue de déconnexion
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(user.email?.substring(0, 2).toUpperCase() ?? '',
                              style: TextStyle(fontSize: 16, color: Color(0xFF64C8C8), fontFamily: 'Open Sans')),
                          SizedBox(width: 4),
                          Icon(Icons.logout, color: Color(0xFF64C8C8)), // Icône de déconnexion
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: IconButton(
                      icon: const Icon(Icons.login, color: Color(0xFF64C8C8)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: user == null
          ? _buildNotLoggedInContent()
          : widget.recommendedCamps.isEmpty
          ? _buildNoCampsContent()
          : _buildCampsContent(),
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  Widget _buildNotLoggedInContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Vous devez vous connecter puis remplir votre profil pour voir les meilleurs surfcamps.",
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 8.0,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildNoCampsContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/desolé.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Aucun camp ne correspond aux critères renseignés. Veuillez réessayer avec d'autres préférences.",
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 8.0,
                    color: Colors.black.withOpacity(0.9),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampsContent() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.recommendedCamps.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> camp = widget.recommendedCamps[index];
        bool isFavorite = favoriteCamps[camp['booking_link']] ?? false;
        return GestureDetector(
          onTapDown: (TapDownDetails details) {
            _handleImagePageSwipe(details, camp['image_urls'].length);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: _imagePageController,
                  itemCount: camp['image_urls'].length,
                  itemBuilder: (context, imageIndex) {
                    return _buildCampImage(camp['image_urls'][imageIndex]);
                  },
                ),
              ),
              _buildImageOverlay(),
              _buildCampDetails(camp, isFavorite),
              _buildPageIndicator(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCampImage(String imageUrl) {
    return Image.network(
      imageUrl,
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
  }

  Widget _buildImageOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildCampDetails(Map<String, dynamic> camp, bool isFavorite) {
    return Positioned(
      bottom: 60,
      left: 20,
      right: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(camp['name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(camp['description'], style: TextStyle(fontSize: 16, color: Colors.white)),
          Text('Activités: ${camp['activities'].join(', ')}',
              style: TextStyle(fontSize: 16, color: Colors.white)),
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
    );
  }

  Widget _buildPageIndicator() {
    return Positioned(
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
    );
  }

  void _handleImagePageSwipe(TapDownDetails details, int imageCount) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (details.localPosition.dx < screenWidth / 2) {
      if (_imagePageController.page!.toInt() > 0) {
        _imagePageController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    } else {
      if (_imagePageController.page!.toInt() < imageCount - 1) {
        _imagePageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }
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
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid); // Référence au document de l'utilisateur
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
    } else {
      // Si l'utilisateur n'est pas connecté, afficher un message demandant la connexion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez vous connecter pour ajouter des favoris.')));
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
      currentIndex: 0, // Met à jour dynamiquement selon l'index sélectionné
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
              child: Text(
                'Annuler',
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
              child: Text(
                'Déconnexion',
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
