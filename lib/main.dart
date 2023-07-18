import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/menu');
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
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! < 0) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Wingfoil()),
              );
            }
          },
          child: Stack(
            children: [
              Image.asset(
                'assets/kitesurf.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                //color: Color.fromRGBO(0, 0, 0, 0.4), // Pour rendre la couleur foncée avec une opacité de 0.4
                //colorBlendMode: BlendMode.darken, // Pour rendre l'image plus sombre
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
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 50,
                  color: Color(0xFFF5F5F5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Methode disposee a envoyer les donnees des etapes dans firestore
/*void createEtapes() async {
  List<Map<String, dynamic>> etapesData = simulateDataEtapesWingfoil();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference etapesCollection = firestore.collection('etapes');

  for (var data in etapesData) {
    DocumentReference document = etapesCollection.doc(data['id'].toString());
    await document.set(data);
    print('Document cree: ${document.path}');
  }
}
*/


