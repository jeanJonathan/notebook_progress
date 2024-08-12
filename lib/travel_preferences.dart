import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:notebook_progress/home.dart';
import 'package:notebook_progress/recommandation_service.dart';

class TravelPreferencesScreen extends StatefulWidget {
  @override
  _TravelPreferencesScreenState createState() => _TravelPreferencesScreenState();
}

class _TravelPreferencesScreenState extends State<TravelPreferencesScreen> {
  GoogleMapController? mapController;
  final TextEditingController _typeAheadController = TextEditingController();
  Set<Marker> _markers = {};
  List<Map<String, dynamic>> destinations = [];
  Set<String> selectedDestinations = {};

  BitmapDescriptor? defaultIcon;
  BitmapDescriptor? selectedIcon;

  @override
  void initState() {
    super.initState();
    loadDestinationData();
    _setCustomMapPins();
    _loadVisitedDestinationsFromFirestore();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _setCustomMapPins() async {
    defaultIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    selectedIcon = await BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    setState(() {});
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
      _updateMarkers();
    });
  }

  Future<void> _loadVisitedDestinationsFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc['visitedDestinations'] != null) {
        setState(() {
          selectedDestinations = Set<String>.from(userDoc['visitedDestinations']);
          _updateMarkers();
        });
      }
    }
  }

  void _updateMarkers() {
    _markers.clear();
    for (var destination in destinations) {
      _markers.add(
        Marker(
          markerId: MarkerId(destination["city"]),
          position: destination["coordinates"],
          icon: selectedDestinations.contains(destination["city"]) ? selectedIcon! : defaultIcon!,
          infoWindow: InfoWindow(title: destination["city"]),
          onTap: () => _onMarkerTapped(destination["city"]),
        ),
      );
    }
  }

  Future<List<String>> _getDestinationSuggestions(String query) async {
    return destinations
        .where((destination) => destination["city"].toLowerCase().contains(query.toLowerCase()))
        .map((destination) => destination["city"] as String)
        .toList();
  }

  void _onMarkerTapped(String city) {
    bool isSelected = selectedDestinations.contains(city);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSelected ? 'Supprimer la destination' : 'Ajouter la destination'),
          content: Text(isSelected
              ? 'Voulez-vous supprimer $city de vos top destinations?'
              : 'Voulez-vous ajouter $city à vos top destinations?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isSelected ? 'Supprimer' : 'Ajouter'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (isSelected) {
                    selectedDestinations.remove(city);
                    _removeVisitedDestinationFromFirestore(city);
                  } else {
                    selectedDestinations.add(city);
                    _addVisitedDestinationToFirestore(city);
                  }
                  _updateMarkers();
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _onSuggestionSelected(String suggestion) {
    var destination = destinations.firstWhere((d) => d["city"] == suggestion);
    LatLng destinationCoords = destination["coordinates"];
    mapController?.animateCamera(CameraUpdate.newLatLng(destinationCoords));
    setState(() {
      if (selectedDestinations.contains(suggestion)) {
        selectedDestinations.remove(suggestion);
        _removeVisitedDestinationFromFirestore(suggestion);
      } else {
        selectedDestinations.add(suggestion);
        _addVisitedDestinationToFirestore(suggestion);
      }
      _updateMarkers();
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

  void _navigateToNextScreen() {
    RecommendationService recommendationService = RecommendationService();
    recommendationService.getRecommendedCamps().then((recommendedCamps) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(recommendedCamps: recommendedCamps)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vos Destinations'),
        backgroundColor: Color(0xFF8AB4F8),
        actions: [],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(40.4637, -3.7492),
              zoom: 5,
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
                color: Color(0xFF8AB4F8),
                padding: const EdgeInsets.all(8.0),
                child: TypeAheadFormField(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: _typeAheadController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher une destination',
                      labelStyle: TextStyle(color: Color(0xFF8AB4F8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    cursorColor: Color(0xFF64C8C8),
                  ),
                  suggestionsCallback: _getDestinationSuggestions,
                  itemBuilder: (context, String suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                      tileColor: selectedDestinations.contains(suggestion) ? Color(0xFFF5F5F5) : null,
                    );
                  },
                  onSuggestionSelected: _onSuggestionSelected,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: _navigateToNextScreen,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF64C8C8),
                foregroundColor: Colors.white, // Utilisation correcte pour définir la couleur du texte
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Continuer'),
            ),
          ),
        ],
      ),
    );
  }
}
