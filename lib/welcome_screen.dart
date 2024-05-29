import 'package:flutter/material.dart';
import 'package:notebook_progress/Wingfoil.dart';
import 'package:notebook_progress/kitesurf.dart';
import 'package:notebook_progress/profile_screen.dart';
import 'package:notebook_progress/search_screen.dart';
import 'package:notebook_progress/wishlist_screen.dart';

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
      body: PageView.builder(
        itemCount: recommendedCamps.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = recommendedCamps[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      camp['image_url'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(camp['name'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(camp['description']),
                      SizedBox(height: 8),
                      Text('Prix: ${camp['price']}€', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('Note: ${camp['rating']} / 5', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      Text('Activités: ${camp['activities'].join(', ')}'),
                    ],
                  ),
                ),
              ],
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

