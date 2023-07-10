import 'package:flutter/material.dart';
import 'Wingfoil.dart';

class Surf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.primaryVelocity! > 0) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Wingfoil()),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/parametres');
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
            Positioned(
              top: 250,
              left: 5,
              child: Icon(Icons.arrow_back_ios, size: 50),
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
                    ),
                  ),
                  SizedBox(height: 26),
                  Text(
                    "Let's while",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Action du bouton
                    },
                    child: Text(
                      'VOIR LES ETAPES',
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Color(0xFF64C8C8), // Modifier la couleur ici
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
