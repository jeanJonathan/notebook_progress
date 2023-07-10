import 'package:cloud_firestore/cloud_firestore.dart';

class Etape {
  final String etapeId;
  final String name;
  final String description;
  final String niveauId;
  final String sportId;

  Etape({
    required this.etapeId,
    required this.name,
    required this.description,
    required this.niveauId,
    required this.sportId,
  });

  // Implementation d'une méthode pour convertir l'objet Etape en Map
  Map<String, dynamic> toMap() {
    return {
      'etapeId': etapeId,
      'name': name,
      'description': description,
      'niveauId': niveauId,
      'sportId': sportId,
    };
  }

  // Implementation d'une méthode pour créer un objet Etape à partir d'un document Firestore
  factory Etape.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Etape(
      etapeId: doc.id,
      name: data['name'],
      description: data['description'],
      niveauId: data['niveauId'],
      sportId: data['sportId'],
    );
  }
}
