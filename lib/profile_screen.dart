import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Map<String, dynamic>? userData;

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
        title: Text("Profil Utilisateur"),
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
                backgroundImage: _imageFile != null ? FileImage(File(_imageFile!.path)) : null,
                child: _imageFile == null ? Icon(Icons.camera_alt, size: 60, color: Colors.white70) : null,
              ),
            ),
          ),
          SizedBox(height: 30),
          Text("${userData!['firstName'] ?? 'Prénom'} ${userData!['lastName'] ?? 'Nom'}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10),
          profileDetail("Email", userData!['email'] ?? FirebaseAuth.instance.currentUser?.email ?? 'Non spécifié'),
          profileDetail("Niveau d'expérience", userData!['experienceLevel'] ?? 'Non spécifié'),
          profileDetail("Type de séjour préféré", userData!['preferredStayType'] ?? 'Non spécifié'),
          profileDetail("About Me", userData!['about'] ?? 'Short bio here'),
        ],
      ),
    );
  }

  Widget profileDetail(String title, String value) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      trailing: Icon(Icons.edit, color: Colors.blue),
      onTap: () => showEditDialog(context, title, value),
    );
  }

  Future<void> showEditDialog(BuildContext context, String field, String currentValue) async {
    TextEditingController _controller = TextEditingController(text: currentValue);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Modifier $field"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(),
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
                await updateUserData(field, _controller.text);
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
          userData![field] = newValue;  // Update local state only if Firestore update is successful
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
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}
