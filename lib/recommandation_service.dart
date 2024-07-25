import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecommendationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getRecommendedCamps() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    // Récupérer le profil de l'utilisateur
    DocumentSnapshot userProfile = await _firestore.collection('users').doc(user.uid).get();
    if (!userProfile.exists) return [];

    String preferredStayType = userProfile['preferredStayType'];
    String experienceLevel = userProfile['experienceLevel'];

    // Récupérer les camps depuis Firestore
    QuerySnapshot campSnapshot = await _firestore.collection('camps')
        .where('type', isEqualTo: preferredStayType)
        .where('level_required', isEqualTo: experienceLevel)
        .get();

    // Filtrer les camps en fonction des préférences utilisateur
    List<Map<String, dynamic>> recommendedCamps = [];
    for (var camp in campSnapshot.docs) {
      Map<String, dynamic> campData = camp.data() as Map<String, dynamic>;
      if (campData['image_urls'] is List) {
        recommendedCamps.add(campData);
      }
    }

    // Trier les camps recommandés par note et prix
    recommendedCamps.sort((a, b) {
      int ratingComparison = b['rating'].compareTo(a['rating']);
      if (ratingComparison != 0) return ratingComparison;
      return a['price'].compareTo(b['price']);
    });

    return recommendedCamps;
  }

  Future<List<Map<String, dynamic>>> getDefaultCamps() async {
    // Logique pour récupérer une liste de camps par défaut
    QuerySnapshot campSnapshot = await _firestore.collection('camps').limit(10).get();

    List<Map<String, dynamic>> defaultCamps = [];
    for (var camp in campSnapshot.docs) {
      Map<String, dynamic> campData = camp.data() as Map<String, dynamic>;
      if (campData['image_urls'] is List) {
        defaultCamps.add(campData);
      }
    }

    return defaultCamps;
  }
}
