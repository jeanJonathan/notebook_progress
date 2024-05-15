import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Preferences',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TravelPreferences(),
    );
  }
}

class TravelPreferences extends StatefulWidget {
  @override
  _TravelPreferencesState createState() => _TravelPreferencesState();
}

class _TravelPreferencesState extends State<TravelPreferences> {
  GoogleMapController? mapController;
  final TextEditingController _typeAheadController = TextEditingController();
  final LatLng _initialCenter = const LatLng(20.5937, 78.9629);
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  Map<String, LatLng> countryCoordinates = {
    'France': LatLng(48.8566, 2.3522),
    'Germany': LatLng(52.5200, 13.4050),
    'Spain': LatLng(40.4168, -3.7038),
    'Italy': LatLng(41.9028, 12.4964),
  };

  Future<List<String>> _getCountrySuggestions(String query) async {
    // Suppose to fetch country data
    return ['France', 'Germany', 'Spain', 'Italy'];
  }

  void _onSuggestionSelected(String suggestion) {
    LatLng countryCoords = countryCoordinates[suggestion] ?? _initialCenter; // Fallback to initial center if country not found
    mapController?.animateCamera(CameraUpdate.newLatLng(countryCoords));
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(suggestion),
          position: countryCoords,
          infoWindow: InfoWindow(title: suggestion),
        ),
      );
      FirebaseFirestore.instance.collection('users').doc('user_id').update({
        'visitedCountries': FieldValue.arrayUnion([suggestion])
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Preferences'),
      ),
      body: SingleChildScrollView( // S'assurer que tout le contenu peut défiler
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: InputDecoration(labelText: 'Search Country'),
                ),
                suggestionsCallback: _getCountrySuggestions,
                itemBuilder: (context, String suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: _onSuggestionSelected,
              ),
            ),
            Container(
              height: 500, // Une hauteur fixe pour la carte Google
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _initialCenter,
                  zoom: 2,
                ),
                markers: _markers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
