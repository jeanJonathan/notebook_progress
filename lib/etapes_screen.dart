import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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

          List<QueryDocumentSnapshot> etapesDocuments = snapshot.data!.docs;
          List<Etape> etapes = etapesDocuments.map((doc) => Etape.fromFirestore(doc)).toList();
          final user = FirebaseAuth.instance.currentUser;
          String? userId = user?.uid;

          // Récupération des progressions de l'utilisateur connecté
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('progression').where('userId', isEqualTo: userId).snapshots(),
            builder: (context, progressionSnapshot) {
              if (progressionSnapshot.hasError) {
                return Text('Une erreur s\'est produite');
              }

              if (progressionSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<QueryDocumentSnapshot> progressionDocuments = progressionSnapshot.data!.docs;
              List<Progression> progressions = progressionDocuments.map((doc) => Progression.fromFirestore(doc)).toList();

              // Filtrer les étapes selon des critères
              etapes = etapes.where((etape) => etape.sportRef.id == '2').toList();

              // Compteur d'étapes validées
              int nombreEtapesValidees = 0;
              String? derniereEtapeValidee;

              // Calculer le nombre d'étapes validées et l'identifiant de la dernière étape validée
              for (var progression in progressions) {
                if (progression.etapeRef != null) {
                  nombreEtapesValidees++;
                  derniereEtapeValidee = progression.etapeRef;
                }
              }
              debugPrint('=== Nombre Etapes Validee ===');
              debugPrint('Etape Validee: ${nombreEtapesValidees}');
              debugPrint('Derniere Etape Validee: ${derniereEtapeValidee}');

              // Affichage des données dans la console pour déboguer
              debugPrint('=== Etapes ===');
              for (var etape in etapes) {
                debugPrint('Etape ID: ${etape.etapeId}');
              }

              debugPrint('=== Progressions ===');
              for (var progression in progressions) {
                debugPrint('User ID: ${progression.userId}');
                debugPrint('EtapeRef: ${progression.etapeRef}');
                // Ajoutez d'autres propriétés de progression si nécessaire
              }

              return ListView.builder(
                itemCount: etapes.length,
                itemBuilder: (context, index) {
                  Etape etape = etapes[index];

                  // On vérifie si l'étape est déjà validée
                  bool dejaValidee = progressions.any((progression) => progression.etapeRef == etape.etapeId);
                  // On verifie si l'étape est verrouillée
                  bool estVerouillee = (nombreEtapesValidees + 1 ) <= index;

                  return InkWell(
                    onTap: () {
                      if (estVerouillee) {
                        HapticFeedback.heavyImpact(); // Un retour haptique pour une interaction
                        // Déclencher l'effet visuel ici
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EtapeDetailScreen(etape: etape, etapeId: etape.etapeId),
                          ),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500), // Durée de l'animation
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: estVerouillee ? Colors.grey[200] : Colors.white,
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
                        leading: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: estVerouillee ? Colors.red : Colors.green,
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/wingfoil.jpg',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
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
                            color: Colors.grey,
                          ),
                        ),
                        trailing: estVerouillee
                            ? Icon(Icons.lock, color: Colors.red) // Icône de verrouillage pour les étapes verrouillées
                            : (dejaValidee
                            ? Icon(Icons.arrow_forward, color: Colors.black)
                            : Icon(Icons.lock_open, color: Colors.green)), // Icône appropriée pour l'étape
                      ),
                    ),
                  );
                },
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
          etapes = etapes.where((etape) => etape.sportRef.id == '1').toList();
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
                      color: Colors.grey,
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