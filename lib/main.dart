import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notebook_progress/basic_info_screen.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'package:notebook_progress/splash_screen.dart';
import 'Wingfoil.dart';
import 'authentification.dart';
import 'etapes_screen.dart';
import 'firebase_options.dart';
import 'data_firestore.dart';
import 'kitesurf.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialisation de firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //sendEtapesWingfoil(); //envoies des donnees dans firestore
  //sendEtapesKitesurf();
  //sendEtapesSurf();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFFF5F5F5,
          <int, Color>{
            50: Color(0xFFF5F5F5),
            100: Color(0xFFF5F5F5),
            200: Color(0xFFF5F5F5),
            300: Color(0xFFF5F5F5),
            400: Color(0xFFF5F5F5),
            500: Color(0xFFF5F5F5),
            600: Color(0xFFF5F5F5),
            700: Color(0xFFF5F5F5),
            800: Color(0xFFF5F5F5),
            900: Color(0xFFF5F5F5),
          },
        ),
    ),
      //Pour enlever l'icone debug
      debugShowCheckedModeBanner: false,
      home: OceanAdventureApp(),//Ecran de demarrage de l'application
      routes: {
        '/authentification': (context) => AuthScreen(),
        '/wingfoil': (context) => Wingfoil(), //wingfoil etant l'ecran d'acceuil
        '/menu': (context) => MenuScreen(),
        '/parametres': (context) => ParametresScreen(),
        '/etapesW': (context) => EtapesScreenWingfoil(),
        '/etapesK': (context) => EtapesScreenKitesurf(),
        '/etapesS': (context) => EtapesScreenSurf(),
        '/createProfileForm': (context) => BasicInfoScreen(), // L'écran du formulaire de création de profil
      },
    );
  }
}

//Methode disposee a envoyer les donnees des etapes dans firestore
void sendEtapesWingfoil() async {
  try {
    List<Map<String, dynamic>> etapesData = simulateDataEtapesWingfoil();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference etapesCollection = firestore.collection('etapes');

    for (var data in etapesData) {
      DocumentReference document = etapesCollection.doc(data['id'].toString());
      await document.set(data);
      print('Document créé: ${document.path}');
    }
  } catch (e) {
    print('Erreur lors de la création des étapes : $e');
  }
}
void sendEtapesKitesurf() async {
  try {
    List<Map<String, dynamic>> etapesData = simulateDataEtapesKitesurf();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference etapesCollection = firestore.collection('etapes');

    for (var data in etapesData) {
      DocumentReference document = etapesCollection.doc(data['id'].toString());
      await document.set(data);
      print('Document créé: ${document.path}');
    }
  } catch (e) {
    print('Erreur lors de la création des étapes : $e');
  }
}

void sendEtapesSurf() async {
  try {
    List<Map<String, dynamic>> etapesData = simulateDataEtapesSurf();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference etapesCollection = firestore.collection('etapes');

    for (var data in etapesData) {
      DocumentReference document = etapesCollection.doc(data['id'].toString());
      await document.set(data);
      print('Document créé: ${document.path}');
    }
  } catch (e) {
    print('Erreur lors de la création des étapes : $e');
  }
}
// Création d'une instance de FirebaseAuth
final FirebaseAuth _auth = FirebaseAuth.instance;
// Méthode pour s'authentifier avec l'e-mail et le mot de passe
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