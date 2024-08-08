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

class UserLevelScreen extends StatefulWidget {
  @override
  _UserLevelScreenState createState() => _UserLevelScreenState();
}

class _UserLevelScreenState extends State<UserLevelScreen> {
  GoogleMapController? mapController;
  final TextEditingController _typeAheadController = TextEditingController();
  final LatLng _initialCenter = const LatLng(20.5937, 78.9629);
  Set<Marker> _markers = {};
  Map<String, LatLng> destinationCoordinates = {
    "Dakhla, Maroc": LatLng(23.6845, -15.9570),
    "Taghazout, Maroc": LatLng(30.5451, -9.7085),
    "Essaouira, Maroc": LatLng(31.5085, -9.7595),
    "Imsouane, Maroc": LatLng(30.8407, -9.8258),
    "Fuerteventura, Canaries": LatLng(28.3587, -14.0537),
    "Lisbonne, Portugal": LatLng(38.7223, -9.1393),
    "Nazaré, Portugal": LatLng(39.6020, -9.0684),
    "Peniche, Portugal": LatLng(39.3575, -9.3815),
    "Açores, Portugal": LatLng(37.7412, -25.6756),
    "Bilbao, Espagne": LatLng(43.2630, -2.9350),
    "Biarritz, France": LatLng(43.4832, -1.5593),
    "Hossegor, France": LatLng(43.6644, -1.3702),
    "Lacanau, France": LatLng(45.0016, -1.0882),
    "Pays de la Loire, France": LatLng(47.7633, -0.3294),
    "Stagone, Sicile, Italie": LatLng(37.8609, 12.4839),
    "Santa Teresa, Costa Rica": LatLng(9.6469, -85.1671),
    "Canggu, Bali, Indonésie": LatLng(-8.6478, 115.1385),
    "Ahangama, Sri Lanka": LatLng(5.9737, 80.3623)
  };
  Set<String> selectedDestinations = {};  // Garde la trace des destinations sélectionnées

  @override
  void initState() {
    super.initState();
    _addInitialMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _zoomToFitDestinations();
  }

  void _addInitialMarkers() {
    setState(() {
      destinationCoordinates.forEach((destination, coords) {
        _markers.add(
          Marker(
            markerId: MarkerId(destination),
            position: coords,
            infoWindow: InfoWindow(title: destination),
          ),
        );
      });
    });
  }

  void _zoomToFitDestinations() {
    if (mapController != null && destinationCoordinates.isNotEmpty) {
      LatLngBounds bounds = _createBounds();
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
      mapController?.animateCamera(cameraUpdate);
    }
  }

  LatLngBounds _createBounds() {
    double x0 = destinationCoordinates.values.first.latitude;
    double x1 = destinationCoordinates.values.first.latitude;
    double y0 = destinationCoordinates.values.first.longitude;
    double y1 = destinationCoordinates.values.first.longitude;

    destinationCoordinates.values.forEach((latLng) {
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

  Future<List<String>> _getCountrySuggestions(String query) async {
    return destinationCoordinates.keys
        .where((destination) => destination.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _onSuggestionSelected(String suggestion) {
    LatLng destinationCoords = destinationCoordinates[suggestion] ?? _initialCenter;
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
                  suggestionsCallback: _getCountrySuggestions,
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
