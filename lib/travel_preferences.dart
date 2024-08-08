/*
 ******************************************************************************
 * user_level_screen.dart
 *
 * Ce fichier implémente l'écran des préférences de voyage de l'utilisateur.
 * L'utilisateur peut sélectionner ses destinations préférées sur une carte et ces choix
 * sont enregistrés dans Firestore. Les destinations sélectionnées sont marquées sur la carte.
 *
 * Fonctionnalités :
 * - Affichage d'une carte interactive avec Google Maps.
 * - Recherche et sélection de destinations.
 * - Marquage des destinations sélectionnées sur la carte.
 * - Enregistrement des destinations sélectionnées dans Firestore.
 * - Navigation vers l'écran d'accueil après la sauvegarde des préférences.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : cloud_firestore, firebase_auth, google_maps_flutter, flutter_typeahead
 ******************************************************************************
 */

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notebook_progress/recommandation_service.dart';
import 'package:notebook_progress/home.dart';

class TravelPreferencesScreen extends StatefulWidget {
  @override
  _TravelPreferencesScreenState createState() => _TravelPreferencesScreenState();
}

class _TravelPreferencesScreenState extends State<TravelPreferencesScreen> {
  GoogleMapController? mapController;
  final TextEditingController _typeAheadController = TextEditingController();
  final LatLng _initialCenter = const LatLng(20.5937, 78.9629);
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> destinations = [];
  Set<String> selectedDestinations = {};  // Garde la trace des destinations sélectionnées

  @override
  void initState() {
    super.initState();
    loadDestinationData();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _zoomToFitDestinations();
  }

  Future<void> loadDestinationData() async {
    final String response = await rootBundle.loadString('assets/destinations.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      destinations = data.map((item) => {
        "city": item["city"],
        "country": item["country"],
        "coordinates": LatLng(item["lat"], item["lng"])
      }).toList();
      _addInitialMarkers();
    });
  }

  void _addInitialMarkers() {
    setState(() {
      destinations.forEach((destination) {
        _markers.add(
          Marker(
            markerId: MarkerId(destination["city"]),
            position: destination["coordinates"],
            infoWindow: InfoWindow(title: destination["city"]),
          ),
        );
      });
    });
  }

  void _zoomToFitDestinations() {
    if (mapController != null && destinations.isNotEmpty) {
      LatLngBounds bounds = _createBounds();
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
      mapController?.animateCamera(cameraUpdate);
    }
  }

  LatLngBounds _createBounds() {
    double x0 = destinations.first["coordinates"].latitude;
    double x1 = destinations.first["coordinates"].latitude;
    double y0 = destinations.first["coordinates"].longitude;
    double y1 = destinations.first["coordinates"].longitude;

    destinations.forEach((destination) {
      LatLng latLng = destination["coordinates"];
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    });

    return LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );
  }

  Future<List<String>> _getDestinationSuggestions(String query) async {
    return destinations
        .where((destination) => destination["city"].toLowerCase().contains(query.toLowerCase()))
        .map((destination) => destination["city"] as String)
        .toList();
  }

  void _onSuggestionSelected(String suggestion) {
    var destination = destinations.firstWhere((d) => d["city"] == suggestion);
    LatLng destinationCoords = destination["coordinates"] ?? _initialCenter;
    mapController?.animateCamera(CameraUpdate.newLatLng(destinationCoords));
    setState(() {
      if (selectedDestinations.contains(suggestion)) {
        selectedDestinations.remove(suggestion);
        _markers.removeWhere((m) => m.markerId.value == suggestion);
        _removeVisitedDestinationFromFirestore(suggestion);  // Retire la destination de Firestore
      } else {
        selectedDestinations.add(suggestion);
        _markers.add(
          Marker(
            markerId: MarkerId(suggestion),
            position: destinationCoords,
            infoWindow: InfoWindow(title: suggestion),
          ),
        );
        _addVisitedDestinationToFirestore(suggestion);  // Ajoute la destination à Firestore
      }
    });
  }

  void _addVisitedDestinationToFirestore(String destinationName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'visitedDestinations': FieldValue.arrayUnion([destinationName])
      }, SetOptions(merge: true));
    }
  }

  void _removeVisitedDestinationFromFirestore(String destinationName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'visitedDestinations': FieldValue.arrayRemove([destinationName])
      });
    }
  }

  Future<void> _savePreferencesToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'visitedDestinations': selectedDestinations.toList()
      }, SetOptions(merge: true));
    }
  }

  void _navigateToHomeScreen(BuildContext context) async {
    await _savePreferencesToFirestore(); // Sauvegarde les préférences avant de naviguer

    RecommendationService recommendationService = RecommendationService();
    List<Map<String, dynamic>> recommendedCamps = await recommendationService.getRecommendedCamps();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(recommendedCamps: recommendedCamps),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos Destinations'),
        backgroundColor: Color(0xFF8AB4F8),  // Couleur de fond pour l'AppBar
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialCenter,
              zoom: 2,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: SingleChildScrollView(
              child: Container(
                color: Color(0xFF8AB4F8),  // Couleur de fond pour le bloc de recherche
                padding: const EdgeInsets.all(8.0),
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher une destination',
                      labelStyle: TextStyle(color: Color(0xFF8AB4F8)),  // Couleur du texte du label
                      filled: true,
                      fillColor: Colors.white,  // Couleur de fond pour le champ de texte
                    ),
                    cursorColor: Color(0xFF64C8C8),  // Couleur du curseur
                  ),
                  suggestionsCallback: _getDestinationSuggestions,
                  itemBuilder: (context, String suggestion) {
                    final isSelected = selectedDestinations.contains(suggestion);
                    return ListTile(
                      title: Text(suggestion),
                      tileColor: isSelected ? Color(0xFFF5F5F5) : null,  // Change la couleur si sélectionné
                    );
                  },
                  onSuggestionSelected: _onSuggestionSelected,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 50.0,
            child: FloatingActionButton(
              onPressed: () {
                _navigateToHomeScreen(context);
              },
              child: Icon(Icons.check),
              backgroundColor: Color(0xFF64C8C8),  // Couleur du bouton
            ),
          ),
        ],
      ),
    );
  }
}
