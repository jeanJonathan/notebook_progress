/*
 ******************************************************************************
 * WishlistScreen.dart
 *
 * Ce fichier implémente l'écran de la wishlist de l'application,
 * permettant aux utilisateurs de voir et de gérer leurs camps favoris.
 *
 * Fonctionnalités :
 * - Affichage des camps ajoutés à la wishlist de l'utilisateur.
 * - Suppression de camps de la wishlist.
 * - Navigation vers les pages de réservation des camps.
 *
 * Auteur : Jean Jonathan Koffi
 * Dernière mise à jour : 31/07/2024
 * Dépendances externes : cloud_firestore, firebase_auth, url_launcher
 ******************************************************************************
 */

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class WishlistScreen extends StatefulWidget {
  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> wishlist = [];

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  // Récupère la wishlist de l'utilisateur depuis Firestore
  void _fetchWishlist() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> camps = userData['camps'] ?? [];
        setState(() {
          wishlist = List<Map<String, dynamic>>.from(camps);
        });
      }
    }
  }

  // Supprime un camp de la wishlist
  void _removeFromWishlist(String campLink) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> camps = userData['camps'] ?? [];
        camps.removeWhere((item) => item['camp_link'] == campLink);
        await userDoc.update({'camps': camps});
        setState(() {
          wishlist.removeWhere((item) => item['camp_link'] == campLink);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Camp retiré de votre wishlist')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist', style: TextStyle(color: Color(0xFF64C8C8))),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF64C8C8)),
      ),
      body: wishlist.isEmpty
          ? Center(child: Text('Votre wishlist est vide', style: TextStyle(color: Color(0xFF64C8C8))))
          : ListView.builder(
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> camp = wishlist[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: camp['image_url'] != ''
                  ? Image.network(camp['image_url'], width: 100, fit: BoxFit.cover)
                  : Icon(Icons.image_not_supported, size: 100),
              title: Text(camp['name'], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF074868))),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromWishlist(camp['camp_link']),
              ),
              onTap: () => _launchURL(camp['camp_link']),
            ),
          );
        },
      ),
    );
  }

  // Lance une URL dans le navigateur par défaut
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
