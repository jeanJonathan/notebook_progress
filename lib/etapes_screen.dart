/*
 ******************************************************************************
 * EtapesScreen.dart
 *
 * Ce fichier implémente les écrans pour afficher et gérer les étapes de progression
 * pour différents sports (Wingfoil, Kitesurf, Surf). Les utilisateurs peuvent voir
 * leurs étapes, vérifier leurs progrès, et obtenir des informations supplémentaires.
 *
 * Fonctionnalités :
 * - Affichage des étapes de progression pour chaque sport.
 * - Validation des étapes en fonction de la progression de l'utilisateur.
 * - Affichage de dialogues informatifs sur chaque sport.
 * - Navigation vers les détails des étapes.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore, flutter, flutter/services.dart
 ******************************************************************************
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'etape.dart';
import 'etapes_details_screen.dart';
import 'package:notebook_progress/progression.dart';

// Écran des étapes de Wingfoil
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

  // Récupère les données des étapes et de la progression de l'utilisateur depuis Firebase
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
          setState(() {});
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
          setState(() {});
        }
      }
    });
  }

  // Affiche un dialogue avec des informations supplémentaires sur le Wingfoil
  void _showAdditionalInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🌟 Infos Wingfoil 🌟',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Bienvenue dans la section Wingfoil! 👋',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ici, vous pouvez accéder à différentes étapes pour améliorer vos compétences dans le wingfoil. Chaque étape a ses propres défis et objectifs. Les étapes verrouillées nécessitent de valider les étapes précédentes pour être accessibles. 🔒🎯',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    child: Text(
                      'Fermer',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Étapes Wingfoil',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showAdditionalInfo(context);
            },
          ),
        ],
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
                    content: Text('Cette étape est verrouillée. 🔒'),
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
                        'assets/wingfoil1.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '🚀 ${etape.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '🌟 ${etape.description}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
                trailing: estVerouillee
                    ? Text('🔒', style: TextStyle(color: Colors.red))
                    : (dejaValidee
                    ? Text('🔓', style: TextStyle(color: Colors.green))
                    : Icon(Icons.arrow_forward, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Écran des étapes de Kitesurf
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

  // Affiche un dialogue avec des informations supplémentaires sur le Kitesurf
  void _showAdditionalInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🌟 Infos Kitesurf 🌟',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Bienvenue dans la section Kitesurf! 👋',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ici, vous pouvez accéder à différentes étapes pour améliorer vos compétences dans le kitesurf. Chaque étape a ses propres défis et objectifs. Les étapes verrouillées nécessitent de valider les étapes précédentes pour être accessibles. 🔒🎯',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    child: Text(
                      'Fermer',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Étapes Kitesurf',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showAdditionalInfo(context);
            },
          ),
        ],
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cette étape est verrouillée. 🔒'),
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
                        sportRef: '1',
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
                        'assets/kite.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '🚀 ${etape.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '🌟 ${etape.description}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
                trailing: estVerouillee
                    ? Text('🔒', style: TextStyle(color: Colors.red))
                    : (dejaValidee
                    ? Text('🔓', style: TextStyle(color: Colors.green))
                    : Icon(Icons.arrow_forward, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Écran des étapes de Surf
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

  // Affiche un dialogue avec des informations supplémentaires sur le Surf
  void _showAdditionalInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🌟 Infos Surf 🌟',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Bienvenue dans la section Surf! 👋',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Ici, vous pouvez accéder à différentes étapes pour améliorer vos compétences dans le surf. Chaque étape a ses propres défis et objectifs. Les étapes verrouillées nécessitent de valider les étapes précédentes pour être accessibles. 🔒🎯',
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    child: Text(
                      'Fermer',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
              ],
            ),
          ),
        );
      },
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showAdditionalInfo(context);
            },
          ),
        ],
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cette étape est verrouillée. 🔒'),
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
                        sportRef: '3',
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
                        'assets/surf2.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  '🚀 ${etape.name}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '🌟 ${etape.description}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
                trailing: estVerouillee
                    ? Text('🔒', style: TextStyle(color: Colors.red))
                    : (dejaValidee
                    ? Text('🔓', style: TextStyle(color: Colors.green))
                    : Icon(Icons.arrow_forward, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}
