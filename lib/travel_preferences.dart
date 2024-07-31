/*
 ******************************************************************************
 * TravelPreferencesScreen.dart
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
  Map<String, LatLng> countryCoordinates = {};
  Set<String> selectedCountries = {};  // Garde la trace des pays sélectionnés

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
          item['country']: LatLng(item['lat'], item['lng'])
      };
    });
  }

  Future<List<String>> _getCountrySuggestions(String query) async {
    return countryCoordinates.keys
        .where((country) => country.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _onSuggestionSelected(String suggestion) {
    LatLng countryCoords = countryCoordinates[suggestion] ?? _initialCenter;
    mapController?.animateCamera(CameraUpdate.newLatLng(countryCoords));
    setState(() {
      if (selectedCountries.contains(suggestion)) {
        selectedCountries.remove(suggestion);
        _markers.removeWhere((m) => m.markerId.value == suggestion);
        _removeVisitedCountryFromFirestore(suggestion);  // Retire le pays de Firestore
      } else {
        selectedCountries.add(suggestion);
        _markers.add(
          Marker(
            markerId: MarkerId(suggestion),
            position: countryCoords,
            infoWindow: InfoWindow(title: suggestion),
          ),
        );
        _addVisitedCountryToFirestore(suggestion);  // Ajoute le pays à Firestore
      }
    });
  }

  void _addVisitedCountryToFirestore(String countryName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'visitedCountries': FieldValue.arrayUnion([countryName])
      }, SetOptions(merge: true));
    }
  }

  void _removeVisitedCountryFromFirestore(String countryName) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'visitedCountries': FieldValue.arrayRemove([countryName])
      });
    }
  }

  Future<void> _savePreferencesToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'visitedCountries': selectedCountries.toList()
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
                    final isSelected = selectedCountries.contains(suggestion);
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
