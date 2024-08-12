import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:notebook_progress/profile/basic_info_entry_screen.dart';
import 'package:notebook_progress/tutoriels/kitesurf.dart';
import 'package:notebook_progress/tutoriels/Wingfoil.dart';
import 'package:notebook_progress/auth/user_authentication_screen.dart';
import 'package:notebook_progress/tutoriels/etapes_screen.dart';
import 'package:notebook_progress/services/firebase_options.dart';
import 'package:notebook_progress/services/data_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocean Adventure',
      theme: ThemeData(
        primaryColor: Color(0xFF64C8C8),
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black87),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement: ${snapshot.error}'));
          } else {
            return KitesurfScreen();
          }
        },
      ),
      routes: {
        '/authentification': (context) => AuthScreen(),
        '/wingfoil': (context) => WingfoilScreen(),
        '/etapesW': (context) => EtapesScreenWingfoil(),
        '/etapesK': (context) => EtapesScreenKitesurf(),
        '/etapesS': (context) => EtapesScreenSurf(),
        '/createProfileForm': (context) => BasicInfoScreen(),
      },
    );
  }

  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'initialisation de Firebase: $e');
    }
  }
}

// Services Firebase: vous pouvez déplacer les méthodes Firebase dans des services dédiés.

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print('Erreur lors de l\'authentification : $e');
      return null;
    }
  }

  Future<void> sendEtapes(String type) async {
    try {
      List<Map<String, dynamic>> etapesData;
      if (type == 'wingfoil') {
        etapesData = simulateDataEtapesWingfoil();
      } else if (type == 'kitesurf') {
        etapesData = simulateDataEtapesKitesurf();
      } else {
        etapesData = simulateDataEtapesSurf();
      }

      CollectionReference etapesCollection = _firestore.collection('etapes');

      for (var data in etapesData) {
        DocumentReference document = etapesCollection.doc(data['id'].toString());
        await document.set(data);
        print('Document créé: ${document.path}');
      }
    } catch (e) {
      print('Erreur lors de la création des étapes : $e');
    }
  }

  Future<void> sendCampsData() async {
    try {
      List<Map<String, dynamic>> campsData = dataTopCamps();

      CollectionReference campsCollection = _firestore.collection('camps');

      for (var data in campsData) {
        DocumentReference document = campsCollection.doc();
        await document.set(data);
        print('Document créé: ${document.path}');
      }
    } catch (e) {
      print('Erreur lors de la création des camps : $e');
    }
  }
}
