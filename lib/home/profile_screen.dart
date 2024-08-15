import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook_progress/auth/user_authentication_screen.dart';
import 'package:notebook_progress/home/wishlist_screen.dart';
import 'package:notebook_progress/services/recommandation_service.dart';
import 'package:notebook_progress/home/home.dart';
import '../tutoriels/kitesurf.dart';
import '../home/ocean_adventure_home.dart';

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
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Hauteur ajustée pour correspondre aux autres écrans
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Image.asset(
                  'assets/logoOcean.png',
                  width: 250,
                  height: 100,
                ),
                StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active && snapshot.data != null) {
                      User user = snapshot.data!;
                      String initials = '';
                      if (user.email != null) {
                        initials = user.email!.split('@').first[0].toUpperCase();
                        if (user.email!.split('@').first.length > 1) {
                          initials += user.email!.split('@').first[1].toUpperCase();
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: InkWell(
                          onTap: () {
                            _showLogoutDialog(context); // Affichage du dialogue de déconnexion
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(initials, style: TextStyle(fontSize: 16, color: Color(0xFF64C8C8), fontFamily: 'Open Sans')),
                              SizedBox(width: 4),
                              Icon(Icons.logout, color: Color(0xFF64C8C8)), // Icône de déconnexion
                            ],
                          ),
                        ),
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () {
                          _showLoginDialog(context); // Affichage du dialogue de connexion
                        },
                        color: Color(0xFF64C8C8),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          title: const Text(''),
        ),
      ),
      body: user == null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Vous devez vous connecter pour accéder à votre profil.",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
          : userData == null
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
                backgroundColor: Color(0xFF64C8C8),
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
            style: TextStyle(
                fontSize: 24, color: Color(0xFF64C8C8), fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF64C8C8),
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        currentIndex: 3, // Met l'onglet Wishlist en surbrillance
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Tutoriels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              RecommendationService recommendationService = RecommendationService();
              recommendationService.getRecommendedCamps().then((recommendedCamps) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => HomeScreen(recommendedCamps: recommendedCamps),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              });
              break;
            case 1:
            // Reste sur l'écran de profil, aucun besoin de faire quoi que ce soit
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => KitesurfScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
            case 3:
              break;
          }
        },
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
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF074868))),
      subtitle: Text(value, style: TextStyle(color: Colors.black)),
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
              child: Text('Annuler', style: TextStyle(color: Color(0xFF64C8C8))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Enregistrer', style: TextStyle(color: Color(0xFF64C8C8))),
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
              child: Text('Annuler', style: TextStyle(color: Color(0xFF64C8C8))),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Enregistrer', style: TextStyle(color: Color(0xFF64C8C8))),
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

  int calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
      age--;
    }
    return age;
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

  Future<void> _fetchUpdatedRecommendations(BuildContext context) async {
    RecommendationService recommendationService = RecommendationService();
    List<Map<String, dynamic>> recommendedCamps = await recommendationService.getRecommendedCamps();

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomeScreen(recommendedCamps: recommendedCamps),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Déconnexion'),
          content: Text('Voulez-vous vraiment vous déconnecter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => OceanAdventureHome(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Text('Déconnexion',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Connexion'),
          content: Text('Voulez-vous vous connecter?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => AuthScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Text('Connexion',
                style: TextStyle(
                  color: Color(0xFF64C8C8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
