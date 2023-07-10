import 'package:flutter/material.dart';
import 'Wingfoil.dart';
import 'package:notebook_progress/parametre_screen.dart';
import 'package:notebook_progress/menu_screen.dart';


Future<void> main() async {
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
          0xFF074868,
          <int, Color>{
            50: Color(0xFF074868),
            100: Color(0xFF074868),
            200: Color(0xFF074868),
            300: Color(0xFF074868),
            400: Color(0xFF074868),
            500: Color(0xFF074868),
            600: Color(0xFF074868),
            700: Color(0xFF074868),
            800: Color(0xFF074868),
            900: Color(0xFF074868),
          },
        ),
      ),
      home: Kitesurf(),
      routes: {
        '/menu': (context) => MenuScreen(),
        '/parametres': (context) => ParametresScreen(),
      },
    );
  }
}
class Kitesurf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //fetchData(); // Appel de la méthode pour récupérer les données lors de la création du widget
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
              ),
            ),
            const SizedBox(width: kToolbarHeight),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/parametres');
              },
            ),
          ],
          centerTitle: true,
          title: const Text('Kitesurf'),
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
                      ),
                    ),
                    SizedBox(height: 26),
                    Text(
                      "Let's while",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Action du bouton
                      },
                      child: Text(
                        'VOIR LES ETAPES',
                        style: TextStyle(fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        primary: Color(0xFF64C8C8), // Modifier la couleur ici
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
                  color: Color(0xFF074868),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


