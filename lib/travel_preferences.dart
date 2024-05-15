import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TravelPreferences extends StatefulWidget {
  @override
  _TravelPreferencesState createState() => _TravelPreferencesState();
}

class _TravelPreferencesState extends State<TravelPreferences> {
  GoogleMapController? mapController;
  final TextEditingController _typeAheadController = TextEditingController();
  final LatLng _initialCenter = const LatLng(20.5937, 78.9629);
  Set<Marker> _markers = {};
  Map<String, LatLng> countryCoordinates = {};

  @override
  void initState() {
    super.initState();
    loadCountryData();
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> loadCountryData() async {
    final String response = await rootBundle.loadString('assets/countries.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      countryCoordinates = {
        for (var item in data)
          item['name']: LatLng(item['latitude'], item['longitude'])
      };
    });
  }

  Future<List<String>> _getCountrySuggestions(String query) async {
    return countryCoordinates.keys
        .where((country) => country.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
      _addVisitedCountryToFirestore(suggestion);
    });
  }

  void _addVisitedCountryToFirestore(String countryName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'visitedCountries': FieldValue.arrayUnion([countryName])
        }, SetOptions(merge: true));
        // Affichez un message de succès ou effectuez une autre action
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pays ajouté avec succès à votre liste de visites!'))
        );
      } catch (e) {
        // Affichez une erreur si l'enregistrement échoue
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l ajout du pays. Veuillez réessayer.'))
        );
      }
    } else {
      // Gérez le cas où l'utilisateur n'est pas connecté
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Aucun utilisateur connecté trouvé. Veuillez vous connecter et réessayer.'))
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos Destinations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _typeAheadController,
                  decoration: InputDecoration(labelText: 'Rehercher une destination'),
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
              height: 500,
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
