import 'package:flutter/material.dart';
import 'package:notebook_progress/etape.dart';

class EtapeDetailScreen extends StatelessWidget {
  final Etape etape;

  EtapeDetailScreen({required this.etape});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'étape'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etape.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              etape.description,
              style: TextStyle(fontSize: 18),
            ),
            // Ajoutez d'autres widgets pour afficher plus de détails de l'étape si nécessaire
          ],
        ),
      ),
    );
  }
}
