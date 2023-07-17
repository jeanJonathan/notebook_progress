import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'etape.dart';
import 'data_firestore.dart';

class EtapesScreen extends StatelessWidget {
  /*
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> etapesData = simulateDataEtapesWingfoil();

    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des étapes'),
      ),
      body: ListView.builder(
        itemCount: etapesData.length,
        itemBuilder: (context, index) {
          final etape = etapesData[index];
          return Card(
            child:
              ListTile(
                leading: Image.asset('assets/kitesurf.jpg'),
                title: Text(etape['name']),
                subtitle: Text(etape['description']),
                trailing: Icon(Icons.more_vert),
              )
          );
        },
      ),
    );
  }
  */
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
              return Card(
                  child:
                  ListTile(
                    leading: Image.asset('assets/kitesurf.jpg'),
                    title: Text(etape.name),
                    subtitle: Text(etape.description),
                    trailing: Icon(Icons.more_vert),
                  )
              );
            },
          );
        },
      ),
    );
  }
}
