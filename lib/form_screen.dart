import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
        title: Text(''),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/form2.jpg'), // Remplacez 'assets/form2.jpg' par le chemin de votre image de fond
                fit: BoxFit.cover,
              ),
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
                      'VALIDER VOTRE PROGRESSION',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF64C8C8),
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                        fontFamily: 'Concert One',
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
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 400, // largeur du champs
                      height: 50,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
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
                            title: Text(lieu),
                          );
                        },
                        onSuggestionSelected: (lieu) {
                          setState(() {
                            _locationController.text = lieu;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: 400, //
                      height: 50,
                      child: TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _weatherController,
                          decoration: InputDecoration(
                            labelText: 'Meteo',
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
                        suggestionsCallback: (pattern) {
                          List<String> meteos = [
                            'vent de terre off shore léger', 'ciel bleu', '1m de houle, personne à l\'eau',    'vent de nord est 15 noeuds', 'ciel brumeux', 'peu de monde sur la plage',    'vent de sud-est 10 noeuds', 'ciel couvert avec risque d\'averse', 'houle de 2m, conditions difficiles',    'vent d\'ouest 20 noeuds', 'ciel variable avec éclaircies', 'vagues de 1m à 1m50, conditions moyennes',    'vent de nord 5 noeuds', 'ciel dégagé', 'plage calme et tranquille',    'vent de sud-ouest 25 noeuds', 'ciel orageux', 'mer agitée avec des vagues de plus de 2m'
                          ];
                          return meteos.where((meteo) => meteo.toLowerCase().startsWith(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, meteo) {
                          return ListTile(
                            title: Text(meteo),
                          );
                        },
                        onSuggestionSelected: (meteo) {
                          setState(() {
                            _weatherController.text = meteo;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 5, // Augmentation le nombre de lignes pour permettre plus de texte
                      decoration: InputDecoration(
                        labelText: 'Commentaire',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.white),
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
                        minimumSize: Size(400, 40), // Taille souhaitée pour le bouton "Ajouter une vidéo"
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
                        primary: Color(0xFF64C8C8),
                        minimumSize: Size(200, 50), // Taille souhaitée pour le bouton "Enregistrer"
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
