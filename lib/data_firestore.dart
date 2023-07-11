import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, dynamic>> simulateData() {
  return [
    {
      'id': 1,
      'description': 'Règles de sécurité de base',
      'name': 'BEGINNER - 1.1',
      'niveauRef': FirebaseFirestore.instance.doc('/niveaux/1'),
      'sportRef': FirebaseFirestore.instance.doc('/sports/1'),
      'video': 'https://youtu.be/-HTkf1UXjiE',
    },
    {
      'id': 2,
      'description': 'Mise en place de l\'aile',
      'name': 'BEGGINER - 1.2',
      'niveauRef': FirebaseFirestore.instance.doc('/niveaux/1'),
      'sportRef': FirebaseFirestore.instance.doc('/sports/1'),
      'video': 'https://youtu.be/y4RfRN9V4tY',
    },
  ];
}
