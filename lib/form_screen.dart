/*
 ******************************************************************************
 * FormScreen.dart
 *
 * Ce fichier implémente le formulaire de progression pour une étape spécifique
 * d'un sport. Il permet aux utilisateurs de soumettre des informations sur
 * leur progression, y compris la date, le lieu, les conditions météorologiques,
 * les commentaires et une vidéo.
 *
 * Fonctionnalités :
 * - Sélection de la date avec un date picker.
 * - Saisie de texte pour le lieu, la météo et les commentaires avec suggestions.
 * - Sélection et téléchargement de vidéos.
 * - Enregistrement des données de progression dans Firestore.
 * - Affichage de messages de succès ou d'erreur.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore, firebase_storage,
 * image_picker, flutter_typeahead
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'kitesurf.dart';

class FormScreen extends StatefulWidget {
  final String etapeRef; // Pour stocker l'identifiant de l'étape
  final String sportRef;

  FormScreen({required this.etapeRef, required this.sportRef});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _weatherController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _videoFile;

  // Sélection de la date
  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF64C8C8),
            hintColor: const Color(0xFF64C8C8),
            colorScheme: ColorScheme.light(primary: const Color(0xFF64C8C8)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  // Sélection de la vidéo
  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  // Téléchargement des données
  Future<void> _uploadData() async {
    try {
      final User? user = _auth.currentUser;
      final String uid = user?.uid ?? '';
      final String fileName = DateTime.now().toString() + '.mp4';

      if (_videoFile != null) {
        final Reference ref = _storage.ref().child('videos/$uid/$fileName');
        final UploadTask uploadTask = ref.putFile(_videoFile!);

        await uploadTask.whenComplete(() async {
          final String downloadUrl = await ref.getDownloadURL();

          await _firestore.collection('progression').add({
            'date': _dateController.text,
            'location': _locationController.text,
            'weather': _weatherController.text,
            'comment': _commentController.text,
            'videoUrl': downloadUrl,
            'userId': uid,
            'etapeRef': widget.etapeRef,
            'sportRef': widget.sportRef,
          });

          _showSuccessMessage();
        });
      } else {
        await _firestore.collection('progression').add({
          'date': _dateController.text,
          'location': _locationController.text,
          'weather': _weatherController.text,
          'comment': _commentController.text,
          'userId': uid,
          'etapeRef': widget.etapeRef,
          'sportRef': widget.sportRef,
        });

        _showSuccessMessage();
        await Future.delayed(Duration(seconds: 1));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KitesurfScreen()),
        );
      }
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'enregistrement du formulaire : $e');
    }
  }

  // Affichage d'un message de succès
  void _showSuccessMessage() {
    final snackBar = SnackBar(
      content: Text('Enregistrement effectué avec succès.'),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Affichage d'un message d'erreur
  void _showErrorMessage(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📝 Formulaire', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF64C8C8),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/form2.png'), // Insérez le chemin de votre image de fond
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.white.withOpacity(0.8), // Ajoute un filtre
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PROGRESSION',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64C8C8),
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                        fontFamily: 'Comic Sans MS',
                      ),
                    ),
                    SizedBox(height: 60),
                    InkWell(
                      onTap: _selectDate,
                      child: IgnorePointer(
                        child: TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildTypeAheadField(
                      controller: _locationController,
                      label: 'Lieu',
                      suggestions: [
                        'Ahangama',
                        'Arugam Bay',
                        'Bali',
                        'Biarritz',
                        'Bilbao',
                        'Boa Vista',
                        'Cabarete',
                        'Caparica',
                        'Capbreton',
                        'Conil',
                        'Dakhla',
                        'El Gouna',
                        'Ericeira',
                        'Essaouira',
                        'Fuerteventura',
                        'Galice',
                        'Hendaye',
                        'Herekitya',
                        'Hossegor',
                        'Imsouane',
                        'Jaco',
                        'Lacanau',
                        'Las Palmas',
                        'Lanzarote',
                        'Lisbonne',
                        'Madère',
                        'Madiha',
                        'Mentawai',
                        'Mirissa',
                        'Montezuma',
                        'Nazare',
                        'Nosara',
                        'Pavones',
                        'Peniche',
                        'Polhena',
                        'Porto',
                        'Quepos',
                        'Santa Teresa',
                        'Sicile',
                        'Sumbawa',
                        'Tamarindo',
                        'Taghazout',
                        'Tarifa',
                        'Toncones',
                        'Uvita',
                        'Vieux Boucau',
                        'Weligama',
                        'Zanzibar',
                        'Açores',
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildTypeAheadField(
                      controller: _weatherController,
                      label: 'Météo',
                      suggestions: [
                        'vent de terre off shore léger',
                        'ciel bleu',
                        '1m de houle, personne à l\'eau',
                        'vent de nord est 15 noeuds',
                        'ciel brumeux',
                        'peu de monde sur la plage',
                        'vent de sud-est 10 noeuds',
                        'ciel couvert avec risque d\'averse',
                        'houle de 2m, conditions difficiles',
                        'vent d\'ouest 20 noeuds',
                        'ciel variable avec éclaircies',
                        'vagues de 1m à 1m50, conditions moyennes',
                        'vent de nord 5 noeuds',
                        'ciel dégagé',
                        'plage calme et tranquille',
                        'vent de sud-ouest 25 noeuds',
                        'ciel orageux',
                        'mer agitée avec des vagues de plus de 2m',
                      ],
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Commentaire',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: _pickVideo,
                      icon: Icon(Icons.video_library, color: Colors.white),
                      label: Text(
                        'Sélectionner une vidéo',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), backgroundColor: Color(0xFF64C8C8),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: _uploadData,
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text(
                        'Enregistrer',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ), backgroundColor: Color(0xFF64C8C8),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeAheadField({
    required TextEditingController controller,
    required String label,
    required List<String> suggestions,
  }) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        style: TextStyle(color: Colors.black),
      ),
      suggestionsCallback: (pattern) {
        return suggestions.where((item) => item.toLowerCase().startsWith(pattern.toLowerCase())).toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(
            suggestion,
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        );
      },
      onSuggestionSelected: (suggestion) {
        setState(() {
          controller.text = suggestion;
        });
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}