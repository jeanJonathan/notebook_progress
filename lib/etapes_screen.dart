import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:notebook_progress/progression.dart';
import 'etape.dart';
import 'etapes_details_screen.dart';

/*Utilisation d'un statefull pour gerer bien la dynamie et l'etat de la classe*/
class EtapesScreenWingfoil extends StatefulWidget {
  @override
  _EtapesScreenWingfoilState createState() => _EtapesScreenWingfoilState();
}

class _EtapesScreenWingfoilState extends State<EtapesScreenWingfoil> {
  List<Etape> etapes = [];
  String? userId;
  List<Progression> progressions = [];

  @override
  void initState() { // Pour reccuperer et initialiser les donnees de firebase
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    // Récupération des étapes
    FirebaseFirestore.instance.collection('etapes').snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        etapes = snapshot.docs.map((doc) => Etape.fromFirestore(doc)).where((etape) => etape.sportRef.id == '2').toList();
        setState(() {});
      }
    });

    // Récupération des progressions de l'utilisateur connecté
    FirebaseFirestore.instance
        .collection('progression')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((progressionSnapshot) {
      if (progressionSnapshot.docs.isNotEmpty) {
        progressions = progressionSnapshot.docs.map((doc) => Progression.fromFirestore(doc)).toList();
        setState(() {});
      }
    });
  }


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
      body: ListView.builder(
        itemCount: etapes.length,
        itemBuilder: (context, index) {
          Etape etape = etapes[index];

          bool dejaValidee = progressions.any((progression) => progression.etapeRef == etape.etapeId);
          bool estVerouillee = (progressions.length + 1) <= index;

          return InkWell(
            onTap: () {
              if (estVerouillee) {
                HapticFeedback.heavyImpact();
                // Trigger visual effect here
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
              duration: const Duration(milliseconds: 500),
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
                    ? Icon(Icons.lock, color: Colors.red)
                    : (dejaValidee ? Icon(Icons.arrow_forward, color: Colors.black) : Icon(Icons.lock_open, color: Colors.green)),
              ),
            ),
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