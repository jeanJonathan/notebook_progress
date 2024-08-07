/*
 ******************************************************************************
 * ProfileScreen.dart
 *
 * Ce fichier implémente l'écran de profil de l'utilisateur.
 * Il permet la visualisation et la modification des informations de profil,
 * y compris la photo de profil, l'email, l'âge, le niveau d'expérience, 
 * le type de séjour préféré, et la bio de l'utilisateur.
 *
 * Fonctionnalités :
 * - Affichage des informations de profil utilisateur.
 * - Modification des informations de profil avec des dialogues interactifs.
 * - Téléchargement et mise à jour de la photo de profil.
 * - Navigation vers la wishlist et la mise à jour des recommandations.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : firebase_auth, cloud_firestore, firebase_storage, image_picker
 ******************************************************************************
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook_progress/wishlist_screen.dart';
import 'package:notebook_progress/recommandation_service.dart';
import 'package:notebook_progress/home.dart';

void main() {
  runApp(MyApp());
}

// Application principale
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primaryColor: Color(0xFF64C8C8),
        hintColor: Color(0xFF074868),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFF074868)),
          headline6: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Color(0xFF074868)),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF074868)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFF64C8C8),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: ProfileScreen(),
    );
  }
}

// Écran de profil utilisateur
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Map<String, dynamic>? userData;

  static const List<String> experienceLevels = ['Débutant', 'Intermédiaire', 'Avancé'];
  static const List<String> stayTypes = ['Adventure', 'Relax', 'Culture', 'Family', 'View'];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Récupère les données de l'utilisateur à partir de Firestore
  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: Theme.of(context).textTheme.headline6),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _navigateToWelcomeScreen(context),
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade800,
                backgroundImage: _imageFile != null
                    ? FileImage(File(_imageFile!.path))
                    : (userData!['photoUrl'] != null
                    ? NetworkImage(userData!['photoUrl']) as ImageProvider
                    : null),
                child: _imageFile == null && userData!['photoUrl'] == null
                    ? Icon(Icons.camera_alt, size: 60, color: Colors.white70)
                    : null,
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "${userData!['firstName'] ?? 'Prénom'}",
            style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 24,
                color: Color(0xFF64C8C8),
                fontFamily: 'Open Sans'),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          _buildProfileItem(
            icon: Icons.email,
            title: "Email",
            value: userData!['email'] ?? FirebaseAuth.instance.currentUser?.email ?? 'Non spécifié',
            isEditable: false,
          ),
          _buildProfileItem(
            icon: Icons.cake,
            title: "Âge",
            value: userData!['birthdate'] != null
                ? "${calculateAge((userData!['birthdate'] as Timestamp).toDate())} ans"
                : 'Non spécifié',
            isEditable: false,
          ),
          _buildProfileItem(
            icon: Icons.star,
            title: "Niveau d'expérience",
            value: userData!['experienceLevel'] ?? 'Non spécifié',
            options: experienceLevels,
            field: 'experienceLevel',
          ),
          _buildProfileItem(
            icon: Icons.favorite,
            title: "Type de séjour préféré",
            value: userData!['preferredStayType'] ?? 'Non spécifié',
            options: stayTypes,
            field: 'preferredStayType',
          ),
          _buildProfileItem(
            icon: Icons.info,
            title: "À propos de moi",
            value: userData!['about'] ?? 'Bio courte ici',
            field: 'about',
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WishlistScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Color(0xFF64C8C8),
            ),
            child: Text('Ma Wishlist'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    List<String>? options,
    String? field,
    bool isEditable = true,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF64C8C8)),
      title: Text(title, style: Theme.of(context).textTheme.headline6),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyText2),
      trailing: isEditable ? Icon(Icons.edit, color: Color(0xFF64C8C8)) : null,
      onTap: isEditable
          ? () {
        if (options != null && field != null) {
          showEditDialog(context, title, value, options, field);
        } else if (field != null) {
          showEditTextDialog(context, title, value, field);
        }
      }
          : null,
    );
  }

  Future<void> showEditDialog(BuildContext context, String title, String currentValue, List<String> options, String field) async {
    String selectedValue = currentValue;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier $title"),
          content: DropdownButtonFormField<String>(
            value: (selectedValue != null && options.contains(selectedValue)) ? selectedValue : null,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Enregistrer'),
              onPressed: () async {
                Navigator.of(context).pop();
                await updateUserData(field, selectedValue);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditTextDialog(BuildContext context, String title, String currentValue, String field) async {
    TextEditingController _textFieldController = TextEditingController(text: currentValue);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier $title"),
          content: TextField(
            controller: _textFieldController,
            maxLines: 3,
            decoration: InputDecoration(hintText: "Entrez $title"),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Enregistrer'),
              onPressed: () async {
                Navigator.of(context).pop();
                await updateUserData(field, _textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  // Calcule l'âge de l'utilisateur à partir de sa date de naissance
  int calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  // Met à jour les données de l'utilisateur dans Firestore
  Future<void> updateUserData(String field, String newValue) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          field: newValue,
        });
        setState(() {
          userData![field] = newValue;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mise à jour réussie!')),
        );
        _fetchUpdatedRecommendations(context);
      } catch (e) {
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour. Veuillez réessayer.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Utilisateur non connecté.')),
      );
    }
  }

  // Permet de choisir une image depuis la galerie
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
        await _uploadImageToFirebase();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Télécharge l'image sélectionnée sur Firebase Storage et met à jour l'URL de la photo de profil dans Firestore
  Future<void> _uploadImageToFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _imageFile != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('user_profiles').child(user.uid);
        final uploadTask = storageRef.putFile(File(_imageFile!.path));
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'photoUrl': downloadUrl,
        });

        setState(() {
          userData!['photoUrl'] = downloadUrl;
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo de profil mise à jour!')),
        );
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour de la photo. Veuillez réessayer.')),
        );
      }
    }
  }

  // Récupère les recommandations mises à jour et navigue vers l'écran d'accueil
  Future<void> _fetchUpdatedRecommendations(BuildContext context) async {
    RecommendationService recommendationService = RecommendationService();
    List<Map<String, dynamic>> recommendedCamps = await recommendationService.getRecommendedCamps();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(recommendedCamps: recommendedCamps),
      ),
    );
  }

  // Navigue vers l'écran de bienvenue et récupère les recommandations mises à jour
  void _navigateToWelcomeScreen(BuildContext context) {
    Navigator.of(context).pop();
    _fetchUpdatedRecommendations(context);
  }
}
