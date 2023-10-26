import 'package:cloud_firestore/cloud_firestore.dart';

class Progression {
  final String id;
  final String date;
  final String location;
  final String weather;
  final String comment;
  final String videoUrl;
  final String userId;
  final DocumentReference etapeRef;

  Progression({
    required this.id,
    required this.date,
    required this.location,
    required this.weather,
    required this.comment,
    required this.videoUrl,
    required this.userId,
    required this.etapeRef,
  });

  // Factory method pour créer une instance de Progression à partir d'un document Firestore
  factory Progression.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Progression(
      id: doc.id,
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      weather: data['weather'] ?? '',
      comment: data['comment'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      userId: data['userId'] ?? '',
      etapeRef: data['etapeRef'] as DocumentReference,
    );
  }
}