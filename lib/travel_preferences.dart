import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    LatLng countryCoords = countryCoordinates[suggestion] ?? _initialCenter;
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
      body: SingleChildScrollView(
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
