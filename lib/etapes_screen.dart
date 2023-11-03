import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'etape.dart';
import 'etapes_details_screen.dart';
import 'package:notebook_progress/progression.dart';

class EtapesScreenWingfoil extends StatefulWidget {
  @override
  _EtapesScreenWingfoilState createState() => _EtapesScreenWingfoilState();
}

class _EtapesScreenWingfoilState extends State<EtapesScreenWingfoil> {
  List<Etape> etapes = [];
  String? userId;
  List<Progression> progressions = [];
  late StreamSubscription<QuerySnapshot> etapesSubscription;
  late StreamSubscription<QuerySnapshot> progressionsSubscription;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;
    fetchDataFromFirebase();
  }

  @override
  void dispose() {
    etapesSubscription.cancel();
    progressionsSubscription.cancel();
    super.dispose();
  }

  void fetchDataFromFirebase() {
    etapesSubscription = FirebaseFirestore.instance
        .collection('etapes')
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        if (snapshot.docs.isNotEmpty) {
          etapes = snapshot.docs
              .map((doc) => Etape.fromFirestore(doc))
              .where((etape) => etape.sportRef.id == '2')
              .toList();
          if (mounted) {
            setState(() {});
          }
        }
      }
    });

    progressionsSubscription = FirebaseFirestore.instance
        .collection('progression')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((progressionSnapshot) {
      if (mounted) {
        if (progressionSnapshot.docs.isNotEmpty) {
          progressions = progressionSnapshot.docs
              .map((doc) => Progression.fromFirestore(doc))
              .toList();
          if (mounted) {
            setState(() {});
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'étapes wingfoil',
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

          bool dejaValidee = progressions.any((progression) => progression.etapeRef == etape.etapeId && progression.sportRef == '2');
          bool estVerouillee = (progressions.where((progression) => progression.sportRef == '2').length + 1) <= index;

          return InkWell(
            onTap: () {
              if (estVerouillee) {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cette étape est verrouillée.'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.grey,
                    duration: Duration(milliseconds: 500),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 250),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return EtapeDetailScreen(
                        etape: etape,
                        etapeId: etape.etapeId,
                        sportRef: '2',
                      );
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var tween = Tween(begin: begin, end: end);
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
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
                    : (dejaValidee
                    ? Icon(Icons.lock_open, color: Colors.green)
                    : Icon(Icons.arrow_forward, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}




class EtapesScreenKitesurf extends StatefulWidget {
  @override
  _EtapesScreenKitesurfState createState() => _EtapesScreenKitesurfState();
}

class _EtapesScreenKitesurfState extends State<EtapesScreenKitesurf> {
  List<Etape> etapes = [];
  String? userId;
  List<Progression> progressions = [];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    FirebaseFirestore.instance.collection('etapes').snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        etapes = snapshot.docs.map((doc) => Etape.fromFirestore(doc)).where((etape) => etape.sportRef.id == '1').toList();
        if (mounted) {
          setState(() {});
        }
      }
    });

    FirebaseFirestore.instance
        .collection('progression')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((progressionSnapshot) {
      if (progressionSnapshot.docs.isNotEmpty) {
        progressions = progressionSnapshot.docs.map((doc) => Progression.fromFirestore(doc)).toList();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Étapes kitesurf',
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

          bool dejaValidee = progressions.any((progression) => progression.etapeRef == etape.etapeId && progression.sportRef == '1');
          bool estVerouillee = (progressions.where((progression) => progression.sportRef == '1').length + 1) <= index;


          return InkWell(
            onTap: () {
              if (estVerouillee) {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Cette étape est verrouillée.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.grey,
                  duration: Duration(milliseconds: 500),
                ));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EtapeDetailScreen(etape: etape, etapeId: etape.etapeId, sportRef: '1',),
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
                        'assets/kite.jpg',
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
                    : (dejaValidee ? Icon(Icons.lock_open, color: Colors.green) : Icon(Icons.arrow_forward, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}



class EtapesScreenSurf extends StatefulWidget {
  @override
  _EtapesScreenSurfState createState() => _EtapesScreenSurfState();
}

class _EtapesScreenSurfState extends State<EtapesScreenSurf> {
  List<Etape> etapes = [];
  String? userId;
  List<Progression> progressions = [];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    userId = user?.uid;

    FirebaseFirestore.instance.collection('etapes').snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        etapes = snapshot.docs.map((doc) => Etape.fromFirestore(doc)).where((etape) => etape.sportRef.id == '3').toList();
        if (mounted) {
          setState(() {});
        }
      }
    });

    FirebaseFirestore.instance
        .collection('progression')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((progressionSnapshot) {
      if (progressionSnapshot.docs.isNotEmpty) {
        progressions = progressionSnapshot.docs.map((doc) => Progression.fromFirestore(doc)).toList();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Étapes Surf',
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

          bool dejaValidee = progressions.any((progression) => progression.etapeRef == etape.etapeId && progression.sportRef == '3');
          bool estVerouillee = (progressions.where((progression) => progression.sportRef == '3').length + 1) <= index;

          return InkWell(
            onTap: () {
              if (estVerouillee) {
                HapticFeedback.heavyImpact();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Cette étape est verrouillée.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.grey,
                  duration: Duration(milliseconds: 500),
                ));
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EtapeDetailScreen(etape: etape, etapeId: etape.etapeId, sportRef: '3',),
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
                        'assets/surf2.jpg',
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
                    ? IconButton(
                  icon: Icon(Icons.lock),
                  color: Colors.red,
                  onPressed: () {
                    _handleEtapeValidation(etape.etapeId, dejaValidee);
                  },
                )
                    : (dejaValidee
                    ? IconButton(
                  icon: Icon(Icons.lock_open),
                  color: Colors.green,
                  onPressed: () {
                    _handleEtapeValidation(etape.etapeId, dejaValidee);
                  },
                )
                    : Icon(Icons.arrow_forward, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleEtapeValidation(String etapeId, bool dejaValidee) {
    // Mettre en œuvre la logique de validation de l'étape et l'interaction avec la base de données Firestore
    if (dejaValidee) {
      // Ici, implémentez la logique de déverrouillage de l'étape si déjà validée
      // Par exemple, supprimer l'étape de la progression dans Firestore
      FirebaseFirestore.instance
          .collection('progression')
          .where('userId', isEqualTo: userId)
          .where('etapeRef', isEqualTo: etapeId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } else {
      // Ici, implémentez la logique de validation de l'étape
      // Par exemple, ajouter l'étape à la progression dans Firestore
      FirebaseFirestore.instance.collection('progression').add({
        'userId': userId,
        'etapeRef': etapeId,
        'dateValidated': DateTime.now(),
      });
    }
  }
}
