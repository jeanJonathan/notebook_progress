import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recommendedCamps;

  WelcomeScreen({required this.recommendedCamps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: recommendedCamps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = recommendedCamps[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Icon(Icons.nature, color: Colors.green), // Adjusted icon
              title: Text(
                camp['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(camp['description']),
                  SizedBox(height: 5),
                  Text('Prix: ${camp['price']}€'),
                  SizedBox(height: 5),
                  Text('Note: ${camp['rating']}'),
                  SizedBox(height: 5),
                  Text('Activités: ${camp['activities'].join(', ')}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Naviguer vers les détails du camp ou ajouter à la wishlist
              },
            ),
          );
        },
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
                break;
              case 2:
              // Naviguer vers la page de recherche
                break;
              case 3:
              // Naviguer vers la page de tutoriel
                break;
              case 4:
              // Naviguer vers la page de profil
                break;
            }
          }
      ),
    );
  }
}
