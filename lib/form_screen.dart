import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormScreen extends StatefulWidget {
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

  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }
  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadVideo() async {
    if (_videoFile != null) {
      try {
        final User? user = _auth.currentUser;
        final String uid = user?.uid ?? '';
        final String fileName = DateTime.now().toString() + '.mp4';
        final Reference ref = _storage.ref().child('videos/$uid/$fileName');
        final TaskSnapshot uploadTask = await ref.putFile(_videoFile!);
        final String downloadUrl = await uploadTask.ref.getDownloadURL();

        await _firestore.collection('progress').add({
          'date': _dateController.text,
          'location': _locationController.text,
          'weather': _weatherController.text,
          'comment': _commentController.text,
          'videoUrl': downloadUrl,
          'userId': uid,
        });
        // Le formulaire a été enregistré avec succès, effectuez les actions souhaitées ici
      } catch (e) {
        // Une erreur s'est produite lors de l'enregistrement du formulaire, affichez un message d'erreur ou effectuez des actions supplémentaires ici
        print('Erreur lors de l\'enregistrement du formulaire : $e');
      }
    } else {
      // Aucune vidéo sélectionnée, affichez un message ou effectuez des actions supplémentaires ici
      print('Aucune vidéo sélectionnée');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enregistrer votre progression'),
      ),
      body: SingleChildScrollView( // Utilisation de SingleChildScrollView pour faire défiler le contenu lorsque le clavier est affiché pour que tous les champs restent visibles pendant la saisie
        // et eviter les probleme de bordure
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Lieu',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _weatherController,
                decoration: InputDecoration(
                  labelText: 'Météo',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Commentaire',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _pickVideo,
                child: Text('Sélectionner une vidéo'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadVideo,
                child: Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}