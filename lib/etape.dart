import 'package:cloud_firestore/cloud_firestore.dart';

class Etape {
  final String etapeId;
  final String name;
  final String description;
  final String niveauRef;
  final String sportRef;

  Etape({
    required this.etapeId,
    required this.name,
    required this.description,
    required this.niveauRef,
    required this.sportRef,
  });

  // Méthode statique pour créer une instance d'Etape à partir d'un document Firestore
  static Etape fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Etape(
      etapeId: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      niveauRef: data['niveauRef'] ?? '',
      sportRef: data['sportRef'] ?? '',
    );
  }
}
