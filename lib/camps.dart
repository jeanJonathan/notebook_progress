import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Map<String, dynamic>> simulateDataCamps() {
  return [
    {
      "name": "Surf Camp - Villa Beach Party",
      "type": "Festif",
      "country": "Portugal",
      "region": "Lisbonne",
      "city": "Lisbonne",
      "location": "Surf Camp - Villa Beach Party",
      "level_required": "Débutant",
      "description": "Détendez-vous et surfez sous le soleil de Lisbonne dans une ambiance festive.",
      "price": 450,
      "activities": ["Surf", "Fêtes", "Visites culturelles"],
      "amenities": ["Piscine", "Bar", "Accès direct à la plage"],
      "rating": 4.3,
      "image_urls": [
        "https://example.com/images/surf-villa1.jpg",
        "https://example.com/images/surf-villa2.jpg"
      ],
      "booking_link": "https://example.com/book/lisbonne-surf-villa"
    },
    {
      "name": "Ocean Adventure, Natural Park Resort",
      "type": "Aventure",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Natural Park Resort",
      "level_required": "Intermédiaire",
      "description": "Explorez les merveilles naturelles de Dakhla avec des activités nautiques.",
      "price": 520,
      "activities": ["Kitesurf", "Exploration", "Yoga"],
      "amenities": ["Équipement sportif", "Spa", "Restaurant gastronomique"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/dakhla1.jpg",
        "https://example.com/images/dakhla2.jpg"
      ],
      "booking_link": "https://example.com/book/dakhla-adventure"
    },

    {
      "name": "Beach Party: Kitecamp Economique et festif",
      "type": "Festif",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Beach Party",
      "level_required": "Débutant",
      "description": "Un camp économique pour les amateurs de kitesurf avec des soirées festives.",
      "price": 300,
      "activities": ["Kitesurf", "Parties", "Musique"],
      "amenities": ["Bar", "Equipement de surf"],
      "rating": 4.2,
      "image_urls": [
        "https://example.com/images/beach-party1.jpg",
        "https://example.com/images/beach-party2.jpg"
      ],
      "booking_link": "https://example.com/book/beach-party-dakhla"
    },
    {
      "name": "Ocean Adventure, Le Cercle Dakhla",
      "type": "Aventure",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Le Cercle",
      "level_required": "Intermédiaire",
      "description": "Explorez les eaux cristallines de Dakhla et profitez d'une aventure inoubliable.",
      "price": 500,
      "activities": ["Kitesurf", "Exploration marine", "Yoga"],
      "amenities": ["Restaurant", "Spa", "WiFi"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/le-cercle1.jpg",
        "https://example.com/images/le-cercle2.jpg"
      ],
      "booking_link": "https://example.com/book/ocean-adventure-cercle"
    },
    {
      "name": "Ocean Adventure Le Lagon, Kite camp Dakhla",
      "type": "Aventure",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Le Lagon",
      "level_required": "Avancé",
      "description": "Un camp avancé pour les passionnés de kitesurf cherchant à améliorer leurs compétences.",
      "price": 550,
      "activities": ["Kitesurf avancé", "Competitions"],
      "amenities": ["Pro-shop", "Coaching personnalisé"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/le-lagon1.jpg",
        "https://example.com/images/le-lagon2.jpg"
      ],
      "booking_link": "https://example.com/book/le-lagon-dakhla"
    },
    {
      "name": "Ocean Adventure Lassarga : Lagune et Océan",
      "type": "Aventure",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Lassarga",
      "level_required": "Débutant",
      "description": "Profitez de la beauté naturelle de Lassarga pour une expérience complète de kitesurf.",
      "price": 450,
      "activities": ["Kitesurf", "Yoga", "Balades nature"],
      "amenities": ["Eco-lodges", "Restauration bio"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/lassarga1.jpg",
        "https://example.com/images/lassarga2.jpg"
      ],
      "booking_link": "https://example.com/book/lassarga"
    },
    {
      "name": "Kitecamp - Fuerteventura, Corralejo",
      "type": "Aventure",
      "country": "Canaries",
      "region": "Fuerteventura",
      "city": "Corralejo",
      "location": "Kitecamp Corralejo",
      "level_required": "Intermédiaire",
      "description": "Découvrez le frisson du kitesurf dans les magnifiques plages de Corralejo.",
      "price": 400,
      "activities": ["Kitesurf", "Snorkeling"],
      "amenities": ["Magasin de surf", "Cours personnalisés"],
      "rating": 4.5,
      "image_urls": [
        "https://example.com/images/corralejo1.jpg",
        "https://example.com/images/corralejo2.jpg"
      ],
      "booking_link": "https://example.com/book/corralejo-kitecamp"
    },
    {
      "name": "Surf camp Surf House, Imsouane - Maroc",
      "type": "Relax",
      "country": "Maroc",
      "region": "Imsouane",
      "city": "Imsouane",
      "location": "Surf House",
      "level_required": "Débutant",
      "description": "Apprenez à surfer dans les vagues parfaites d'Imsouane, idéal pour débutants et familles.",
      "price": 320,
      "activities": ["Surf", "Yoga", "Ateliers de surf"],
      "amenities": ["École de surf", "Restaurant", "Vue sur mer"],
      "rating": 4.6,
      "image_urls": [
        "https://example.com/images/imsouane-surfhouse1.jpg",
        "https://example.com/images/imsouane-surfhouse2.jpg"
      ],
      "booking_link": "https://example.com/book/surfhouse-imsouane"
    },
    {
      "name": "Surfcamp Surf house Bilbao",
      "type": "Aventure",
      "country": "Espagne",
      "region": "Pays Basque",
      "city": "Bilbao",
      "location": "Surf House",
      "level_required": "Intermédiaire",
      "description": "Plongez dans la culture du surf basque avec ce camp situé au cœur de Bilbao.",
      "price": 340,
      "activities": ["Surf", "Visites culturelles", "Gastronomie"],
      "amenities": ["Ateliers de surf", "Tours guidés", "Hébergement urbain"],
      "rating": 4.4,
      "image_urls": [
        "https://example.com/images/bilbao-surfhouse1.jpg",
        "https://example.com/images/bilbao-surfhouse2.jpg"
      ],
      "booking_link": "https://example.com/book/surfhouse-bilbao"
    },
    {
      "name": "Le meilleur Surf Camp d'Imsouane",
      "type": "Adventure",
      "country": "Maroc",
      "region": "Imsouane",
      "city": "Imsouane",
      "location": "Meilleur Surf Camp",
      "level_required": "Tous niveaux",
      "description": "Vivez une expérience de surf inoubliable avec des instructeurs de renommée mondiale.",
      "price": 500,
      "activities": ["Surf avancé", "Photographie de surf", "Relaxation"],
      "amenities": ["Suites de luxe", "Piscine à débordement", "Spa"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/imsouane-best1.jpg",
        "https://example.com/images/imsouane-best2.jpg"
      ],
      "booking_link": "https://example.com/book/best-surf-imsouane"
    },
    {
      "name": "Surf Lodge Premium",
      "type": "Premium",
      "country": "Maroc",
      "region": "Taghazout",
      "city": "Taghazout",
      "location": "Surf Lodge Premium",
      "level_required": "Avancé",
      "description": "Expérience de surf de luxe avec des vues imprenables sur l'océan et des cours personnalisés.",
      "price": 650,
      "activities": ["Surf", "Yoga", "Relaxation"],
      "amenities": ["Spa", "Restaurant gourmet", "Piscine chauffée"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/taghazout-premium1.jpg",
        "https://example.com/images/taghazout-premium2.jpg"
      ],
      "booking_link": "https://example.com/book/surf-lodge-premium"
    },
    {
      "name": "Surf camp Taghazout - Maroc Authentique",
      "type": "Culture",
      "country": "Maroc",
      "region": "Taghazout",
      "city": "Taghazout",
      "location": "Maroc Authentique",
      "level_required": "Tous niveaux",
      "description": "Immergez-vous dans la culture marocaine tout en profitant des meilleures vagues.",
      "price": 420,
      "activities": ["Surf", "Cours de cuisine marocaine", "Visites culturelles"],
      "amenities": ["Hébergement traditionnel", "Marché local"],
      "rating": 4.6,
      "image_urls": [
        "https://example.com/images/taghazout-authentique1.jpg",
        "https://example.com/images/taghazout-authentique2.jpg"
      ],
      "booking_link": "https://example.com/book/taghazout-authentique"
    },
    {
      "name": "Séjour ados et Colonies",
      "type": "Family",
      "country": "France",
      "region": "Pays Basque",
      "city": "Biarritz",
      "location": "Colonies Biarritz",
      "level_required": "Débutant",
      "description": "Camp d'été pour adolescents axé sur l'apprentissage du surf et des activités de groupe.",
      "price": 300,
      "activities": ["Surf", "Jeux de plage", "Excursions"],
      "amenities": ["Encadrement", "Activités de groupe"],
      "rating": 4.4,
      "image_urls": [
        "https://example.com/images/biarritz-colonies1.jpg",
        "https://example.com/images/biarritz-colonies2.jpg"
      ],
      "booking_link": "https://example.com/book/colonies-biarritz"
    },
    {
      "name": "Surfcamp - Fuerteventura, Corralejo",
      "type": "Aventure",
      "country": "Canaries",
      "region": "Fuerteventura",
      "city": "Corralejo",
      "location": "Fuerteventura Surfcamp",
      "level_required": "Intermédiaire",
      "description": "Surfcamp dynamique à Fuerteventura avec des instructeurs expérimentés et un équipement de pointe.",
      "price": 400,
      "activities": ["Surf", "Kitesurf", "Volleyball de plage"],
      "amenities": ["Bar de plage", "Location de matériel"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/fuerteventura-corralejo1.jpg",
        "https://example.com/images/fuerteventura-corralejo2.jpg"
      ],
      "booking_link": "https://example.com/book/fuerteventura-corralejo"
    },
    {
      "name": "Surf Camp Sidi Kaouki - Villa Beach House",
      "type": "Adventure",
      "country": "Maroc",
      "region": "Sidi Kaouki",
      "city": "Sidi Kaouki",
      "location": "Villa Beach House",
      "level_required": "Tous niveaux",
      "description": "Profitez d'un séjour Adventure dans notre villa sur la plage avec des sessions de surf guidées.",
      "price": 600,
      "activities": ["Surf", "Yoga au coucher du soleil", "Balades à cheval"],
      "amenities": ["Villa privée", "Chef personnel", "Piscine"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/sidi-kaouki-villa1.jpg",
        "https://example.com/images/sidi-kaouki-villa2.jpg"
      ],
      "booking_link": "https://example.com/book/sidi-kaouki-villa"
    },
    {
      "name": "Boutique Hôtel Surf And Yoga House",
      "type": "Relax",
      "country": "Maroc",
      "region": "Taghazout",
      "city": "Taghazout",
      "location": "Boutique Hôtel",
      "level_required": "Tous niveaux",
      "description": "Combinez surf et yoga dans notre boutique hôtel pour une relaxation ultime et un entraînement complet.",
      "price": 700,
      "activities": ["Surf", "Yoga", "Méditation"],
      "amenities": ["Spa", "Cours de yoga", "Équipement de surf de haute qualité"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/taghazout-yoga1.jpg",
        "https://example.com/images/taghazout-yoga2.jpg"
      ],
      "booking_link": "https://example.com/book/taghazout-yoga"
    },
    {
      "name": "Ecole de kite ION Club",
      "type": "Aventure",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "ION Club",
      "level_required": "Intermédiaire à Avancé",
      "description": "Rejoignez l'élite du kitesurf à notre école renommée pour des cours professionnels et compétitifs.",
      "price": 620,
      "activities": ["Kitesurf", "Compétitions"],
      "amenities": ["Équipement de pointe", "Coaching pro"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/ion-club1.jpg",
        "https://example.com/images/ion-club2.jpg"
      ],
      "booking_link": "https://example.com/book/ion-club"
    },
    {
      "name": "Ocean Adventure, Nature & Spa",
      "type": "Relax",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Nature & Spa",
      "level_required": "Tous niveaux",
      "description": "Détendez-vous dans notre spa après une journée d'aventure océanique dans les eaux de Dakhla.",
      "price": 800,
      "activities": ["Kitesurf", "Spa", "Yoga"],
      "amenities": ["Spa de luxe", "Piscine", "Restaurant gastronomique"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/dakhla-spa1.jpg",
        "https://example.com/images/dakhla-spa2.jpg"
      ],
      "booking_link": "https://example.com/book/nature-spa-dakhla"
    },
    {
      "name": "Ocean Vagabond Le Lagon, Dakhla",
      "type": "Adventure",
      "country": "Maroc",
      "region": "Dakhla",
      "city": "Dakhla",
      "location": "Ocean Vagabond",
      "level_required": "Débutant à Intermédiaire",
      "description": "Profitez de notre camp Éco-responsable avec une vue imprenable sur le lagon de Dakhla.",
      "price": 550,
      "activities": ["Kitesurf", "Eco-tours", "Yoga"],
      "amenities": ["Hébergement écologique", "Restaurant bio", "Ateliers sur l'environnement"],
      "rating": 4.6,
      "image_urls": [
        "https://example.com/images/vagabond-lagon1.jpg",
        "https://example.com/images/vagabond-lagon2.jpg"
      ],
      "booking_link": "https://example.com/book/ocean-vagabond"
    },
    {
      "name": "Surfcamp - La Centrale",
      "type": "Jeunesse",
      "country": "France",
      "region": "Landes",
      "city": "Hossegor",
      "location": "La Centrale",
      "level_required": "Débutant à Avancé",
      "description": "Idéal pour jeunes surfeurs souhaitant améliorer leurs compétences dans les vagues landaises.",
      "price": 450,
      "activities": ["Surf", "Compétitions junior", "Activités de groupe"],
      "amenities": ["Coaching", "Hébergement proche de la plage", "Activités nocturnes"],
      "rating": 4.5,
      "image_urls": [
        "https://example.com/images/la-centrale1.jpg",
        "https://example.com/images/la-centrale2.jpg"
      ],
      "booking_link": "https://example.com/book/la-centrale"
    },
    {
      "name": "Surf Camp Nazaré, Portugal",
      "type": "Extrême",
      "country": "Portugal",
      "region": "Nazaré",
      "city": "Nazaré",
      "location": "Surf Camp Nazaré",
      "level_required": "Avancé",
      "description": "Défiez les plus grandes vagues du monde à Nazaré avec notre équipe de surfeurs professionnels.",
      "price": 750,
      "activities": ["Surf de gros", "Coaching avancé", "Analyse vidéo"],
      "amenities": ["Accès direct aux spots de gros", "Équipement de sécurité", "Analyse vidéo"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/nazare1.jpg",
        "https://example.com/images/nazare2.jpg"
      ],
      "booking_link": "https://example.com/book/nazare"
    },
    {
      "name": "Surf Lodge Péniche, Portugal",
      "type": "Family",
      "country": "Portugal",
      "region": "Peniche",
      "city": "Peniche",
      "location": "Surf Lodge",
      "level_required": "Tous niveaux",
      "description": "Un camp familial offrant une expérience de surf complète pour tous les âges à Peniche.",
      "price": 500,
      "activities": ["Surf", "Ateliers pour enfants", "Excursions locales"],
      "amenities": ["Hébergement familial", "Cours de surf pour tous les âges", "Piscine"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/peniche-lodge1.jpg",
        "https://example.com/images/peniche-lodge2.jpg"
      ],
      "booking_link": "https://example.com/book/peniche-lodge"
    },
    {
      "name": "Auberge Bilbao",
      "type": "Culturel",
      "country": "Espagne",
      "region": "Pays Basque",
      "city": "Bilbao",
      "location": "Auberge Bilbao",
      "level_required": "Débutant",
      "description": "Explorez la culture basque tout en apprenant à surfer dans les vagues de Bilbao.",
      "price": 320,
      "activities": ["Surf", "Visites culturelles", "Gastronomie locale"],
      "amenities": ["Guides locaux", "Cours de surf débutant", "Hébergement en auberge"],
      "rating": 4.3,
      "image_urls": [
        "https://example.com/images/bilbao-auberge1.jpg",
        "https://example.com/images/bilbao-auberge2.jpg"
      ],
      "booking_link": "https://example.com/book/auberge-bilbao"
    },
    {
      "name": "Surf camp Surf & Chill Capbreton – Hossegor",
      "type": "Relax",
      "country": "France",
      "region": "Landes",
      "city": "Hossegor",
      "location": "Capbreton",
      "level_required": "Débutant",
      "description": "Détendez-vous et surfez dans les vagues douces de Hossegor, parfait pour débutants et amateurs de chill.",
      "price": 460,
      "activities": ["Surf", "Yoga", "Relaxation"],
      "amenities": ["Spa", "Yoga studio", "Bar lounge"],
      "rating": 4.6,
      "image_urls": [
        "https://example.com/images/hossegor-chill1.jpg",
        "https://example.com/images/hossegor-chill2.jpg"
      ],
      "booking_link": "https://example.com/book/hossegor-chill"
    },
    {
      "name": "Surfcamp - Surf House Adventure",
      "type": "Adventure",
      "country": "France",
      "region": "Landes",
      "city": "Capbreton",
      "location": "Surf House",
      "level_required": "Avancé",
      "description": "Améliorez votre technique de surf avec des coachs professionnels dans un environnement dédié à la Performance.",
      "price": 500,
      "activities": ["Surf avancé", "Coaching personnalisé", "Analyse vidéo"],
      "amenities": ["Gym", "Analyse vidéo", "Équipement pro"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/capbreton-Adventure1.jpg",
        "https://example.com/images/capbreton-Adventure2.jpg"
      ],
      "booking_link": "https://example.com/book/capbreton-Adventure"
    },
    {
      "name": "Surf Camp Villa - Beach House Corralejo",
      "type": "Luxueux",
      "country": "Canaries",
      "region": "Fuerteventura",
      "city": "Corralejo",
      "location": "Villa Beach House",
      "level_required": "Tous niveaux",
      "description": "Profitez du luxe et du confort de notre villa en bord de mer avec accès direct aux meilleures vagues.",
      "price": 750,
      "activities": ["Surf", "Relaxation", "Snorkeling"],
      "amenities": ["Villa privée", "Piscine", "Accès plage privée"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/corralejo-villa1.jpg",
        "https://example.com/images/corralejo-villa2.jpg"
      ],
      "booking_link": "https://example.com/book/corralejo-villa"
    },
    {
      "name": "Winf Foil camp - Fuerteventura, Corralejo",
      "type": "Adventure",
      "country": "Canaries",
      "region": "Fuerteventura",
      "city": "Corralejo",
      "location": "Winf Foil Camp",
      "level_required": "Intermédiaire",
      "description": "Découvrez la nouvelle sensation de glisse avec notre camp de Wind Foil, idéal pour ceux cherchant à repousser les limites.",
      "price": 680,
      "activities": ["Wind Foil", "Kitesurf", "Fitness marin"],
      "amenities": ["Équipement moderne", "Coaching", "Ateliers"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/corralejo-windfoil1.jpg",
        "https://example.com/images/corralejo-windfoil2.jpg"
      ],
      "booking_link": "https://example.com/book/corralejo-windfoil"
    },
    {
      "name": "Village Vacances Surf à Corralejo",
      "type": "Family",
      "country": "Canaries",
      "region": "Fuerteventura",
      "city": "Corralejo",
      "location": "Village Vacances",
      "level_required": "Débutant",
      "description": "Parfait pour les familles, notre village de vacances offre des activités surf adaptées à tous les âges.",
      "price": 520,
      "activities": ["Surf", "Activités enfants", "Excursions"],
      "amenities": ["Club enfants", "Animations", "Restauration familiale"],
      "rating": 4.5,
      "image_urls": [
        "https://example.com/images/corralejo-village1.jpg",
        "https://example.com/images/corralejo-village2.jpg"
      ],
      "booking_link": "https://example.com/book/corralejo-village"
    },
    {
      "name": "Surf Camp Vue Mer Peniche, Portugal",
      "type": "View",
      "country": "Portugal",
      "region": "Peniche",
      "city": "Peniche",
      "location": "Vue Mer",
      "level_required": "Débutant à Intermédiaire",
      "description": "Découvrez le surf avec une vue imprenable sur l'océan Atlantique dans l'un des meilleurs spots de surf de Portugal.",
      "price": 530,
      "activities": ["Surf", "Stand Up Paddle", "Beach Volley"],
      "amenities": ["Terrasse avec vue", "Accès direct à la plage", "Bar"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/peniche-vue-mer1.jpg",
        "https://example.com/images/peniche-vue-mer2.jpg"
      ],
      "booking_link": "https://example.com/book/peniche-vue-mer"
    },
    {
      "name": "Surf Camp Yoga & Chill – Peniche, Portugal",
      "type": "Relax",
      "country": "Portugal",
      "region": "Peniche",
      "city": "Peniche",
      "location": "Yoga & Chill",
      "level_required": "Tous niveaux",
      "description": "Combinez yoga et surf pour une relaxation profonde et une amélioration de votre technique de surf.",
      "price": 600,
      "activities": ["Yoga", "Surf", "Méditation"],
      "amenities": ["Studio de yoga", "Spa", "Instructeurs certifiés"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/peniche-yoga-chill1.jpg",
        "https://example.com/images/peniche-yoga-chill2.jpg"
      ],
      "booking_link": "https://example.com/book/peniche-yoga-chill"
    },
    {
      "name": "Kitecamp Obidos",
      "type": "Aventure",
      "country": "Portugal",
      "region": "Obidos",
      "city": "Obidos",
      "location": "Kitecamp",
      "level_required": "Intermédiaire à Avancé",
      "description": "Relevez de nouveaux défis et améliorez vos compétences en kitesurf dans les magnifiques eaux d'Obidos.",
      "price": 650,
      "activities": ["Kitesurf", "Wakeboard", "Compétitions"],
      "amenities": ["École de kite", "Location d'équipement", "Hébergement confortable"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/obidos-kite1.jpg",
        "https://example.com/images/obidos-kite2.jpg"
      ],
      "booking_link": "https://example.com/book/obidos-kite"
    },
    {
      "name": "Surf House - Açores",
      "type": "Adventure",
      "country": "Portugal",
      "region": "Açores",
      "city": "Ponta Delgada",
      "location": "Surf House",
      "level_required": "Débutant",
      "description": "Profitez d'une ambiance Adventure pour apprendre le surf dans le cadre spectaculaire des Açores.",
      "price": 570,
      "activities": ["Surf", "Écotourisme", "Randonnée"],
      "amenities": ["Éco-lodges", "Guides locaux", "Cuisine locale"],
      "rating": 4.6,
      "image_urls": [
        "https://example.com/images/acores-surfhouse1.jpg",
        "https://example.com/images/acores-surfhouse2.jpg"
      ],
      "booking_link": "https://example.com/book/acores-surfhouse"
    },
    {
      "name": "Resort Sicile",
      "type": "Culturel",
      "country": "Italie",
      "region": "Sicile",
      "city": "Stagone",
      "location": "Resort",
      "level_required": "Débutant à Intermédiaire",
      "description": "Découvrez le charme unique de la Sicile tout en profitant de sessions de surf exceptionnelles.",
      "price": 690,
      "activities": ["Surf", "Découverte culturelle", "Gastronomie"],
      "amenities": ["Spa", "Excursions", "Gastronomie locale"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/sicile-resort1.jpg",
        "https://example.com/images/sicile-resort2.jpg"
      ],
      "booking_link": "https://example.com/book/sicile-resort"
    },
    {
      "name": "Wingfoil, Surf & Yoga Camp Essaouira, Maroc",
      "type": "Relax",
      "country": "Maroc",
      "region": "Essaouira",
      "city": "Essaouira",
      "location": "Wingfoil and Surf",
      "level_required": "Intermédiaire",
      "description": "Combinez surf, yoga et wingfoil pour une expérience sportive et relaxante à Essaouira.",
      "price": 620,
      "activities": ["Surf", "Wingfoil", "Yoga"],
      "amenities": ["Ateliers de yoga", "Équipement wingfoil", "Spa"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/essaouira-wingfoil1.jpg",
        "https://example.com/images/essaouira-wingfoil2.jpg"
      ],
      "booking_link": "https://example.com/book/essaouira-wingfoil"
    },
    {
      "name": "Surfcamp Banana Village, Taghazout Bay",
      "type": "Family",
      "country": "Maroc",
      "region": "Taghazout",
      "city": "Taghazout",
      "location": "Banana Village",
      "level_required": "Débutant",
      "description": "Idéal pour les familles, découvrez le surf dans l'atmosphère détendue de Banana Village.",
      "price": 480,
      "activities": ["Surf", "Ateliers pour enfants", "Yoga"],
      "amenities": ["Club enfants", "Piscine", "Restaurant"],
      "rating": 4.5,
      "image_urls": [
        "https://example.com/images/taghazout-banana1.jpg",
        "https://example.com/images/taghazout-banana2.jpg"
      ],
      "booking_link": "https://example.com/book/banana-village"
    },
    {
      "name": "Le meilleur Surf Camp de Taghazout, Maroc",
      "type": "Premium",
      "country": "Maroc",
      "region": "Taghazout",
      "city": "Taghazout",
      "location": "Meilleur Surf Camp",
      "level_required": "Avancé",
      "description": "Vivez une expérience de surf inégalée dans le meilleur camp de Taghazout, avec des coaches de renommée internationale.",
      "price": 750,
      "activities": ["Surf avancé", "Coaching personnalisé", "Yoga"],
      "amenities": ["Accès VIP aux spots", "Hébergement de luxe", "Restauration bio"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/taghazout-best1.jpg",
        "https://example.com/images/taghazout-best2.jpg"
      ],
      "booking_link": "https://example.com/book/taghazout-best"
    },
    {
      "name": "Surf Camp - Jungle view, Santa Teresa",
      "type": "Aventure",
      "country": "Costa Rica",
      "region": "Santa Teresa",
      "city": "Santa Teresa",
      "location": "Jungle view",
      "level_required": "Tous niveaux",
      "description": "Immergez-vous dans la nature luxuriante de Santa Teresa tout en profitant de sessions de surf exceptionnelles.",
      "price": 680,
      "activities": ["Surf", "Trekking", "Yoga"],
      "amenities": ["Vue jungle", "Espaces de détente", "Cours de surf"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/santa-teresa-jungle1.jpg",
        "https://example.com/images/santa-teresa-jungle2.jpg"
      ],
      "booking_link": "https://example.com/book/jungle-view"
    },
    {
      "name": "Surfcamp Canggu, Bali, Indonésie",
      "type": "Tendance",
      "country": "Indonésie",
      "region": "Bali",
      "city": "Canggu",
      "location": "Surfcamp Canggu",
      "level_required": "Intermédiaire",
      "description": "Explorez les vagues paradisiaques de Canggu avec notre surfcamp trendy et ses instructeurs passionnés.",
      "price": 700,
      "activities": ["Surf", "Yoga", "Visites culturelles"],
      "amenities": ["Cours de surf personnalisés", "Piscine à débordement", "Bar de plage"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/canggu1.jpg",
        "https://example.com/images/canggu2.jpg"
      ],
      "booking_link": "https://example.com/book/canggu"
    },
    {
      "name": "Surfcamp Ado de Luxe",
      "type": "Relax",
      "country": "France",
      "region": "Pays Basque",
      "city": "Biarritz",
      "location": "Ado de Luxe",
      "level_required": "Débutant à Intermédiaire",
      "description": "Un camp de surf Adventure pour adolescents, offrant une formation de haute qualité et des activités de luxe dans la magnifique région de Biarritz.",
      "price": 800,
      "activities": ["Surf", "Ateliers de cuisine", "Sorties culturelles"],
      "amenities": ["Hébergement de luxe", "Piscine", "Service complet"],
      "rating": 4.8,
      "image_urls": [
        "https://example.com/images/biarritz-ado-luxe1.jpg",
        "https://example.com/images/biarritz-ado-luxe2.jpg"
      ],
      "booking_link": "https://example.com/book/biarritz-ado-luxe"
    },
    {
      "name": "Surf Camp - Beach House",
      "type": "Family",
      "country": "France",
      "region": "Gironde",
      "city": "Lacanau",
      "location": "Beach House",
      "level_required": "Tous niveaux",
      "description": "Situé directement sur la plage, notre camp propose une immersion totale dans le surf avec une vue imprenable sur l'océan à Lacanau.",
      "price": 650,
      "activities": ["Surf", "Paddleboard", "Beach games"],
      "amenities": ["Accès direct à la plage", "Hébergement en bord de mer", "Cours de surf"],
      "rating": 4.7,
      "image_urls": [
        "https://example.com/images/lacanau-beachhouse1.jpg",
        "https://example.com/images/lacanau-beachhouse2.jpg"
      ],
      "booking_link": "https://example.com/book/lacanau-beach-house"
    },
    {
      "name": "Surfcamp Ados",
      "type": "Jeunesse",
      "country": "France",
      "region": "Pays-de-la-Loire",
      "city": "Sables d'olonnes",
      "location": "Surfcamp Ados",
      "level_required": "Débutant",
      "description": "Ce camp pour jeunes propose des cours de surf et une multitude d'activités pour garantir un été inoubliable aux Sables d'Olonne.",
      "price": 450,
      "activities": ["Surf", "Kayak", "Jeux de plage"],
      "amenities": ["Moniteurs jeunesse", "Activités de groupe", "Camping"],
      "rating": 4.5,
      "image_urls": [
        "https://example.com/images/sables-ados1.jpg",
        "https://example.com/images/sables-ados2.jpg"
      ],
      "booking_link": "https://example.com/book/sables-ados"
    },
    {
      "name": "Surf Camp - Villa Beach Party",
      "type": "Festif",
      "country": "Sri Lanka",
      "region": "Ahangama",
      "city": "Ahangama",
      "location": "Villa Beach",
      "level_required": "Tous niveaux",
      "description": "Vivez la fête ultime sur la plage dans notre villa exclusivement située à Ahangama, avec des cours de surf quotidiens et des soirées inoubliables.",
      "price": 700,
      "activities": ["Surf", "Fêtes sur la plage", "BBQ"],
      "amenities": ["Villa privée", "Piscine", "Accès plage direct"],
      "rating": 4.9,
      "image_urls": [
        "https://example.com/images/ahangama-party1.jpg",
        "https://example.com/images/ahangama-party2.jpg"
      ],
      "booking_link": "https://example.com/book/ahangama-beach-party"
    }
  ];
}

