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

    // Récupération les camps depuis Firestore
    QuerySnapshot campSnapshot = await _firestore.collection('camps').where('type', isEqualTo: preferredStayType).where('level_required', isEqualTo: experienceLevel).get();

    // On filtre les camps en fonction des préférences utilisateur
    List<Map<String, dynamic>> recommendedCamps = [];
    for (var camp in campSnapshot.docs) {
      Map<String, dynamic> campData = camp.data() as Map<String, dynamic>;
      // maintenant l'image est une liste
      if (campData['image_urls'] is List) {
        recommendedCamps.add(campData);
      }
    }

    // Tri les camps recommandés par note et prix
    recommendedCamps.sort((a, b) {
      int ratingComparison = b['rating'].compareTo(a['rating']);
      if (ratingComparison != 0) return ratingComparison;
      return a['price'].compareTo(b['price']);
    });

    return recommendedCamps;
  }
}
