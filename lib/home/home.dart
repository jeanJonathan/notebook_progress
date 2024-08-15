import 'package:flutter/material.dart';
import 'package:notebook_progress/home/ocean_adventure_home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:notebook_progress/home/profile_screen.dart';
import 'package:notebook_progress/home/wishlist_screen.dart';
import '../tutoriels/kitesurf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                      return SizedBox(width: 48); // Placeholder pour garder la mise en page
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: user == null
          ? Center(
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
      )
          : widget.recommendedCamps.isEmpty
          ? Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/desolé.jpg', // Image de fond
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
                  _imagePageController.previousPage(
                      duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }
              } else {
                if (_imagePageController.page!.toInt() < camp['image_urls'].length - 1) {
                  _imagePageController.nextPage(
                      duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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
        List<dynamic> camps = userData['camps'] ?? []; // On récupère la liste des camps ou crée une nouvelle liste vide

        int index = camps.indexWhere((item) => item['camp_link'] == camp['booking_link']);
        if (index >= 0) {
          camps.removeAt(index); // On supprime le camp de la liste
          setState(() {
            favoriteCamps.remove(camp['booking_link']);
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camp retiré de votre wishlist')));
        } else {
          camps.insert(0, campData); // On ajoute le camp au début de la liste
          setState(() {
            favoriteCamps[camp['booking_link']] = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camp ajouté à votre wishlist')));
        }

        await userDoc.update({'camps': camps}); // On met à jour la liste des camps dans Firestore
      } else {
        // Si le document n'existe pas
        Map<String, dynamic> newUserDoc = {
          'camps': [campData], // On crée un nouveau document avec une liste contenant le camp
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
      currentIndex: 0, // Assurez-vous que l'index 0 est sélectionné pour l'écran d'accueil
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Color(0xFF64C8C8)), // Couleur pour l'onglet "Accueil"
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, color: Colors.grey), // Couleur grise pour "Wishlist"
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school, color: Colors.grey), // Couleur grise pour "Tutoriels"
          label: 'Tutoriels',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle, color: Colors.grey), // Couleur grise pour "Profil"
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
          // Reste sur l'écran d'accueil, aucun besoin de faire quoi que ce soit
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
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => KitesurfScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
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
    );
  }

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
