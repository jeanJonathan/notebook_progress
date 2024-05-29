import 'package:flutter/material.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/search_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'kitesurf.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recommendedCamps;

  WelcomeScreen({required this.recommendedCamps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Hauteur de l'en-tête ajustée
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40.0), // Ajustez le padding pour le positionnement
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Image.asset(
                  'assets/logoOcean.png',
                  width: 250, // Ajustez la largeur comme vous le souhaitez
                  height: 100, // Ajustez la hauteur comme vous le souhaitez
                ),
                SizedBox(width: 48), // Espace réservé pour équilibrer le logo
              ],
            ),
          ),
        ),
      ),
      body: PageView.builder(
        itemCount: recommendedCamps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = recommendedCamps[index];
          return Stack(
            children: [
              // Image en arrière-plan
              Positioned.fill(
                child: Image.network(
                  camp['image_url'],
                  fit: BoxFit.cover,
                ),
              ),
              // Gradient pour améliorer la lisibilité du texte
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
              // Textes et boutons
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(camp['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(camp['description'], style: TextStyle(fontSize: 16, color: Colors.white)),
                    Text('Activités: ${camp['activities'].join(', ')}', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz, color: Colors.red), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, color: Colors.purple), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.blue), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.school, color: Colors.amber), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, color: Colors.green), label: ''),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
            // Naviguer vers la wishlist
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen(recommendedCamps: recommendedCamps)),
              );
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
    );
  }
}
