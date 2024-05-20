import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recommendedCamps;

  WelcomeScreen({required this.recommendedCamps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Naviguer vers le profil de l'utilisateur
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recommendedCamps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = recommendedCamps[index];
          return ListTile(
            title: Text(camp['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(camp['description']),
                Text('Prix: ${camp['price']}€'),
                Text('Note: ${camp['rating']}'),
                Text('Activités: ${camp['activities'].join(', ')}'),
              ],
            ),
            onTap: () {
              // Naviguer vers les détails du camp ou ajouter à la wishlist
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
        ],
        onTap: (index) {
          // Naviguer vers les différentes sections de l'application
        },
      ),
    );
  }
}
