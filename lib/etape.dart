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
}
