import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'etape.dart';

class EtapesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des étapes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('etapes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<Etape> etapes = documents.map((doc) => Etape.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: etapes.length,
            itemBuilder: (context, index) {
              Etape etape = etapes[index];
              return ListTile(
                title: Text(etape.name),
                subtitle: Text(etape.description),
                // Ajoutez d'autres widgets pour afficher les autres propriétés de l'étape
              );
            },
          );
        },
      ),
    );
  }
}
