import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
        title: Text("Profil"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
          Text("${userData!['firstName'] ?? 'Prénom'} ${userData!['lastName'] ?? 'Nom'}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10),
          ListTile(
            title: Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(userData!['email'] ?? FirebaseAuth.instance.currentUser?.email ?? 'Non spécifié'),
          ),
          profileDetail("Niveau d'expérience", userData!['experienceLevel'] ?? 'Non spécifié', experienceLevels, 'experienceLevel'),
          profileDetail("Type de séjour préféré", userData!['preferredStayType'] ?? 'Non spécifié', stayTypes, 'preferredStayType'),
          profileDetail("About Me", userData!['about'] ?? 'Short bio here', []),
        ],
      ),
    );
  }

  Widget profileDetail(String title, String value, List<String> options, [String? field]) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: options.isNotEmpty ? Icon(Icons.edit, color: Colors.blue) : null,
      onTap: options.isNotEmpty ? () => showEditDialog(context, title, value, options, field!) : null,
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
            value: selectedValue,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              selectedValue = newValue!;
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
            SnackBar(content: Text('Mise à jour réussie!'))
        );
      } catch (e) {
        print('Error updating user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la mise à jour. Veuillez réessayer.'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur non connecté.'))
      );
    }
  }

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

  Future<void> _uploadImageToFirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _imageFile != null) {
      try {
        // Reference to Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('user_profiles').child(user.uid);
        final uploadTask = storageRef.putFile(File(_imageFile!.path));
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore with the image URL
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'photoUrl': downloadUrl,
        });

        // Update local state
        setState(() {
          userData!['photoUrl'] = downloadUrl;
          _imageFile = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Photo de profil mise à jour!'))
        );
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de la mise à jour de la photo. Veuillez réessayer.'))
        );
      }
    }
  }
}
