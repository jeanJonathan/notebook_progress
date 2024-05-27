import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, dynamic>> simulateDataCamps() {
  return [
    {
      "name": "Camp de Surf Avancé",
      "type": "Festif",
      "location": "Hawaii",
      "level_required": "Avancé",
      "description": "Un camp de surf pour les experts.",
      "price": 489,
      "activities": ["Surf", "Yoga", "Spa"],
      "amenities": ["Piscine", "Bar sur la Terrasse"],
      "rating": 4.5,
      "reviews": [
        {"user": "John", "comment": "Excellent camp pour les surfeurs expérimentés!", "rating": 5},
        {"user": "Jane", "comment": "Bonne ambiance mais un peu cher.", "rating": 4}
      ]
    },
    {
      "name": "Retraite de Yoga",
      "type": "Tranquille",
      "location": "Bali",
      "level_required": "Débutant",
      "description": "Un séjour paisible pour les amateurs de yoga.",
      "price": 350,
      "activities": ["Yoga", "Méditation"],
      "amenities": ["Spa", "Jardin"],
      "rating": 4.7,
      "reviews": [
        {"user": "Alice", "comment": "Parfait pour se détendre et se ressourcer.", "rating": 5},
        {"user": "Bob", "comment": "Très relaxant, j'y retournerai!", "rating": 4.5}
      ]
    }
  ];
}