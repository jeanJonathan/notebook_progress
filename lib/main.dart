import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Wingfoil.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'package:notebook_progress/menu_screen.dart';
import 'etapes_screen.dart';
import 'firebase_options.dart';
import 'data_firestore.dart';

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
      home: Kitesurf(),
      routes: {
        '/menu': (context) => MenuScreen(),
        '/parametres': (context) => ParametresScreen(),
        '/etapesW': (context) => EtapesScreenWingfoil(),
        '/etapesK': (context) => EtapesScreenKitesurf(),
        '/etapesS': (context) => EtapesScreenSurf(),
      },
    );
  }
}

class Kitesurf extends StatelessWidget {
  Offset? _initialPosition;
  bool _showSwipeIndicator = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        _initialPosition = details.globalPosition;
        _showSwipeIndicator = true; // Pour afficher l'indicateur au début du glissement
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (_initialPosition != null) {
          final offset = details.globalPosition;
          final difference = offset.dx - _initialPosition!.dx;

          // Si le mouvement est vers la droite
          if (difference < 10) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Wingfoil()));
          }
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        _initialPosition = null;
        _showSwipeIndicator = false; // Pour masquer l'indicateur lorsque le glissement se termine
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          actions: [
            const SizedBox(width: kToolbarHeight),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logoIONCLUB.png',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    'assets/logoOcean.png',
                    width: 130,
                    height: 100,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/parametres');
              },
            ),
          ],
          title: const Text(''),
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/kitesurf3.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            if (_showSwipeIndicator)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                left: 16,
                right: 16,
                child: Text(
                  'Faites glisser vers la gauche pour Wingfoil',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: 16,
              right: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'KITE SURF',
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64C8C8),
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                      fontFamily: 'Concert One',
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Let's while",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontFamily: 'Concert One',
                    ),
                  ),
                  SizedBox(height: 46),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/etapesK');
                    },
                    child: Text(
                      'VOIR LES ÉTAPES',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Open Sans',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 250,
              right: 5,
              child: Icon(Icons.arrow_forward_ios, size: 50, color: Color(0xFFF5F5F5)),
            ),
          ],
        ),
      ),
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
