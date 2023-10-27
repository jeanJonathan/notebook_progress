import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notebook_progress/progression.dart';
import 'etape.dart';
import 'data_firestore.dart';
import 'etapes_details_screen.dart';

class EtapesScreenWingfoil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des étapes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('etapes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<Etape> etapes = documents.map((doc) => Etape.fromFirestore(doc)).toList();
          final user = FirebaseAuth.instance.currentUser;
          String? userId = user?.uid;
          // filtrage des progressions via l'id
          List<Progression> progressions = documents
              .map((doc) => Progression.fromFirestore(doc))
              .where((progression) => progression.userId == userId)
              .toList();
          // On filtre les étapes dont sportRef est égal à 1
          etapes = etapes.where((etape) => etape.sportRef.id == '1').toList();

          return ListView.builder(
            itemCount: etapes.length,
            itemBuilder: (context, index) {
              Etape etape = etapes[index];
              bool isLocked = true; // Initialisation à true

              for (var progression in progressions) {
                if (etape.etapeId == progression.etapeRef) {
                  // L'étape n'est pas verrouillée car elle a été validée
                  isLocked = false;
                  break;
                }
              }

              return InkWell(
                onTap: () {
                  if (!isLocked) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EtapeDetailScreen(etape: etape, etapeId: etape.etapeId),
                      ),
                    );
                  } else {
                    // L'étape est verrouillée, vous pouvez afficher un message à l'utilisateur
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Étape verrouillée'),
                        content: Text('Vous devez d\'abord valider les étapes précédentes.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Fermer'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/wingfoil.jpg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      etape.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      etape.description,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: isLocked ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class EtapesScreenKitesurf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des étapes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.blue, // Modifier la couleur de l'AppBar selon vos besoins
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('etapes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<Etape> etapes = documents.map((doc) => Etape.fromFirestore(doc)).toList();
          // On filtre les étapes dont sportRef est égal à 1
          etapes = etapes.where((etape) => etape.sportRef.id == '2').toList();
          return ListView.builder(
            itemCount: etapes.length,
            itemBuilder: (context, index) {
              Etape etape = etapes[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EtapeDetailScreen(etape: etape, etapeId: etape.etapeId,),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Changement de l'ombre selon vos préférences
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/kite.jpg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      etape.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      etape.description,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey, // Modifier la couleur de l'icône selon vos besoins
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class EtapesScreenSurf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liste des étapes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        //backgroundColor: Colors.blue, // Modifier la couleur de l'AppBar selon vos besoins
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('etapes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Une erreur s\'est produite');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
          List<Etape> etapes = documents.map((doc) => Etape.fromFirestore(doc)).toList();

          // On filtre les étapes dont sportRef est égal à 1
          etapes = etapes.where((etape) => etape.sportRef.id == '3').toList();
          return ListView.builder(
            itemCount: etapes.length,
            itemBuilder: (context, index) {
              Etape etape = etapes[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EtapeDetailScreen(etape: etape,etapeId: etape.etapeId,),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2), // Changement de l'ombre selon vos préférences
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/surf2.jpg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      etape.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      etape.description,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Colors.grey, // Modifier la couleur de l'icône selon vos besoins
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}