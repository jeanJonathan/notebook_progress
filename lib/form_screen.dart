import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'kitesurf.dart';
import 'main.dart';

class FormScreen extends StatefulWidget {
  final String etapeRef; // pour stocker l'identifiant de l'étape
  final String sportRef;
  FormScreen({required this.etapeRef,required this.sportRef});
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

    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _dateController.text = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  //Pour selectionner les videos niveau apple sans avoir besoin d'ajouter la permission car depuis ios14 apple a integrer ce  framework PhotosUI qui permet aussi un acces direct a la galerie
  Future<void> _pickVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadData() async {
    try {
      final User? user = _auth.currentUser;
      final String uid = user?.uid ?? '';
      final String fileName = DateTime.now().toString() + '.mp4';

      if (_videoFile != null) {
        final Reference ref = _storage.ref().child('videos/$uid/$fileName');
        final UploadTask uploadTask = ref.putFile(_videoFile!);

        // Attente du téléchargement de la vidéo soit terminé
        await uploadTask.whenComplete(() async {
          final String downloadUrl = await ref.getDownloadURL();

          // Enregistrement des données du formulaire, y compris le lien de la vidéo, dans Firestore
          await _firestore.collection('progression').add({
            'date': _dateController.text,
            'location': _locationController.text,
            'weather': _weatherController.text,
            'comment': _commentController.text,
            'videoUrl': downloadUrl,
            'userId': uid,
            'etapeRef': widget.etapeRef, //
            'sportRef': widget.sportRef,
          });

          // Affichage un message de succès à l'utilisateur
          _showSuccessMessage();

          //await Future.delayed(Duration(seconds: 5));
          //Navigator.pop(context);
        });
      } else {
        // Si aucune vidéo n'a été sélectionnée, on enregistre simplement les données du formulaire dans Firestore sans le lien de la vidéo
        await _firestore.collection('progression').add({
          'date': _dateController.text,
          'location': _locationController.text,
          'weather': _weatherController.text,
          'comment': _commentController.text,
          'userId': uid,
          'etapeRef': widget.etapeRef,
          'sportRef': widget.sportRef,
        });

        // Affichage du message de succès à l'utilisateur
        _showSuccessMessage();
        // Attente de 1 secondes avant de revenir à l'écran précédent
        await Future.delayed(Duration(seconds: 1));

        // Redirection vers l'écran précédent
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => Kitesurf()), //Pour renvoyer l'utilisateur sur l'ecran par defaut
        );
      }

      // Le formulaire a été enregistré avec succès, on effectue les actions souhaitées ici
    } catch (e) {
      // Une erreur s'est produite lors de l'enregistrement du formulaire, on affiche un message d'erreur à l'utilisateur
      _showErrorMessage('Erreur lors de l\'enregistrement du formulaire : $e');
    }
  }

// Fonction pour afficher un message de succès à l'utilisateur
  void _showSuccessMessage() {
    final snackBar = SnackBar(
      content: Text('Enregistrement effectué avec succès.'),
      backgroundColor: Colors.green, // Couleur de fond du SnackBar pour indiquer le succès
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// Fonction pour afficher un message d'erreur à l'utilisateur
  void _showErrorMessage(String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red, // Couleur de fond du SnackBar pour indiquer l'erreur
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📝 Formulaire de progression'),
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
              color: Colors.white.withOpacity(0.2), // Ajoute un filtre sombre
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
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.lightBlueAccent, // Couleur de l'ombre
                            blurRadius: 2,
                            offset: Offset(3, 4),
                          ),
                        ],
                        fontFamily: 'Comic Sans MS', // Police amusante
                      ),
                    ),
                    SizedBox(height: 60), // Espace entre le texte et les champs du formulaire
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
                          style: TextStyle(color: Colors.black), // Couleur du texte
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 400,
                      height: 50,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _locationController,
                          decoration: InputDecoration(
                            labelText: 'Lieu',
                            labelStyle: TextStyle(color: Colors.black), //label
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.white), // bordure
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blueAccent), // bordure en sélection
                            ),
                          ),
                          style: TextStyle(color: Colors.white), //texte
                        ),
                        suggestionsCallback: (pattern) {
                          List<String> lieux = [
                            'Ahangama',
                            'Açores',
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
                          ];
                          //Pour ce faire on remplace contains par starsWith
                          return lieux.where((lieu) => lieu.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, lieu) {
                          return ListTile(
                            title: Text(
                              lieu,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.lightBlue,
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (lieu) {
                          setState(() {
                            _locationController.text = lieu;
                          });
                        },
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 400,
                      height: 50,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _weatherController,
                          decoration: InputDecoration(
                            labelText: 'Météo',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        suggestionsCallback: (pattern) {
                          List<String> meteos = [
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
                            'mer agitée avec des vagues de plus de 2m'
                          ];
                          return meteos.where((meteo) => meteo.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, meteo) {
                        return ListTile(
                          title: Text(
                            meteo,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.lightBlue,
                            ),
                          ),
                        );
                      },
                        onSuggestionSelected: (meteo) {
                          setState(() {
                            _weatherController.text = meteo;
                          });
                        },
                        suggestionsBoxDecoration: SuggestionsBoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sélectionner une vidéo ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '🎬', // Ajout d'un emoji pour la sélection de vidéo
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: Size(400, 40),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _uploadData,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Enregistrer ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '📁', // Ajout d'un emoji pour l'enregistrement
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        primary: Color(0xFF64C8C8),
                        minimumSize: Size(200, 50),
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
}