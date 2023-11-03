import 'package:cloud_firestore/cloud_firestore.dart';

class Progression {
  final String id;
  final String date;
  final String location;
  final String weather;
  final String comment;
  final String videoUrl;
  final String userId;
  final String etapeRef;
  final String sportRef;

  Progression({
    required this.id,
    required this.date,
    required this.location,
    required this.weather,
    required this.comment,
    required this.videoUrl,
    required this.userId,
    required this.etapeRef,
    required this.sportRef,
  });

  // Factory method pour créer une instance de Progression à partir d'un document Firestore
  factory Progression.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Progression(
      id: doc.id,
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      weather: data['weather'] ?? '',
      comment: data['comment'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      userId: data['userId'] ?? '',
      etapeRef: data['etapeRef'] ?? '', // On ne creer pas de document donc il faudrait supprement la reference appliquee
      sportRef: data['sportRef'] ?? '',
    );
  }
}