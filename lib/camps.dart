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
      "image_url": "https://example.com/image-camp-surf.jpg",
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
      "image_url": "https://example.com/image-retraite-yoga.jpg",
      "reviews": [
        {"user": "Alice", "comment": "Parfait pour se détendre et se ressourcer.", "rating": 5},
        {"user": "Bob", "comment": "Très relaxant, j'y retournerai!", "rating": 4.5}
      ]
    },
    {
      "name": "Carnival Beach Party",
      "type": "Festif",
      "location": "Rio de Janeiro",
      "level_required": "Débutant",
      "description": "Vivez l'excitation du carnaval sur les plages de Rio.",
      "price": 530,
      "activities": ["Danse", "Fêtes sur la plage", "Cours de samba"],
      "amenities": ["Club de plage", "Buffet"],
      "rating": 4.7,
      "image_url": "https://example.com/image-carnival-party.jpg",
      "reviews": [
        {"user": "Carlos", "comment": "Une expérience festive mémorable!", "rating": 5},
        {"user": "Sophie", "comment": "Ambiance incroyable, mais très bruyant la nuit.", "rating": 4}
      ]
    },
    {
      "name": "Festival Lights & Sounds",
      "type": "Festif",
      "location": "Berlin",
      "level_required": "Intermédiaire",
      "description": "Découvrez la vie nocturne et la culture électronique de Berlin.",
      "price": 460,
      "activities": ["Visites de clubs", "Ateliers de DJ", "Performances en direct"],
      "amenities": ["Lounge VIP", "Transports nocturnes"],
      "rating": 4.4,
      "image_url": "https://example.com/image-festival-lights.jpg",
      "reviews": [
        {"user": "Max", "comment": "Super pour les amateurs de musique électronique.", "rating": 5},
        {"user": "Léa", "comment": "Un peu intense pour les non-initiés.", "rating": 3.5}
      ]
    },
    {
      "name": "Silent Retreat",
      "type": "Tranquille",
      "location": "Kyoto",
      "level_required": "Débutant",
      "description": "Un havre de paix dans un monastère traditionnel japonais.",
      "price": 720,
      "activities": ["Méditation", "Cérémonie du thé", "Jardinage zen"],
      "amenities": ["Jardins zen", "Salles de méditation"],
      "rating": 4.9,
      "image_url": "https://example.com/image-silent-retreat.jpg",
      "reviews": [
        {"user": "Sara", "comment": "Parfait pour une déconnexion totale.", "rating": 5},
        {"user": "Tom", "comment": "Très calme, mais on aurait aimé plus d'interactions.", "rating": 4}
      ]
    },
    {
      "name": "Nature & Wellness Retreat",
      "type": "Tranquille",
      "location": "Vermont",
      "level_required": "Débutant",
      "description": "Relaxation et bien-être au cœur des forêts.",
      "price": 400,
      "activities": ["Randonnées guidées", "Yoga au lever du soleil", "Bains de forêt"],
      "amenities": ["Spa en plein air", "Hébergement écologique"],
      "rating": 4.8,
      "image_url": "https://example.com/image-nature-wellness.jpg",
      "reviews": [
        {"user": "Anne", "comment": "La nature à son meilleur, très ressourçant.", "rating": 5},
        {"user": "Philippe", "comment": "Paisible, mais prévoyez vos propres activités en cas de pluie.", "rating": 4}
      ]
    }
  ];
}
