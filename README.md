# Ocean Adventure

Ocean Adventure est une application mobile destinée aux passionnés de sports nautiques tels que le kitesurf, le wingfoil et le surf. L'application permet aux utilisateurs de suivre leur progression, de regarder des tutoriels vidéo, de prendre des notes sur leurs sessions et de gérer leur liste de camps favoris.

## Fonctionnalités

### Suivi de la progression

- **Formulaires de Progression** : Suivi des progrès avec des formulaires de saisie pour chaque session de sport, incluant des informations sur la date, le lieu, les conditions météorologiques et des commentaires.
- **Étapes de Progression** : Accès à des étapes spécifiques pour chaque sport avec des défis et des objectifs à atteindre.

### Tutoriels vidéo

- **Lecteur YouTube Intégré** : Visionnez des tutoriels et des vidéos de formation directement dans l'application en mode plein écran pour une expérience immersive.
- **Contenu Vidéo Adaptatif** : La vidéo se met en pause automatiquement lorsque vous quittez l'écran, pour une gestion optimale de votre temps.

### Gestion de la wishlist

- **Ajout et Suppression** : Ajoutez des camps à votre wishlist et gérez vos préférences en les retirant à tout moment.
- **Affichage de la Wishlist** : Visualisez vos camps favoris avec des images, des descriptions et des liens directs.

### Profil utilisateur

- **Informations de Profil** : Visualisez et modifiez vos informations personnelles, y compris votre photo de profil, votre niveau d'expérience, votre type de séjour préféré, et votre bio.
- **Mise à Jour en Temps Réel** : Les modifications apportées à votre profil sont enregistrées en temps réel dans Firestore.

### Recommandations personnalisées

- **Camps Recommandés** : Recevez des recommandations personnalisées de camps basées sur vos préférences et votre historique de progression.
- **Service de Recommandation** : Un service intégré qui analyse vos données pour vous proposer des expériences adaptées à vos besoins.

## Technologies Utilisées

### Front-End

- **Flutter** : Framework principal pour le développement multiplateforme (iOS, Android).
- **Dart** : Langage de programmation utilisé avec Flutter.

### Back-End

- **Firebase** :
    - **Authentification** : Gestion des connexions et des inscriptions des utilisateurs.
    - **Firestore** : Base de données NoSQL pour stocker les informations des utilisateurs et leurs progressions.
    - **Storage** : Stockage et récupération des vidéos et des images.
    - **Notifications Push** : Pour envoyer des mises à jour et des rappels aux utilisateurs.

### Autres Services

- **YouTube Player** : Intégration pour la lecture de vidéos YouTube directement dans l'application.
- **TypeAhead** : Pour fournir des suggestions automatiques lors de la saisie de texte.

## Documentation Complète

### Structure de l'Application

- **Écran de Progression** : Permet de soumettre des informations détaillées sur les sessions de sport nautique.
- **Lecteur Vidéo** : Affiche des tutoriels YouTube en plein écran pour une expérience immersive.
- **Gestion de la Wishlist** : Affiche et permet la gestion des camps favoris de l'utilisateur.
- **Profil Utilisateur** : Affiche et permet la modification des informations de profil.
- **Recommandations** : Offre des suggestions personnalisées basées sur l'activité de l'utilisateur.

### Fonctionnalités Techniques

- **Authentification Firebase** : Utilisé pour gérer les connexions et les inscriptions des utilisateurs.
- **Firestore** : Base de données NoSQL pour stocker les informations des utilisateurs et leurs progressions.
- **Firebase Storage** : Utilisé pour stocker et récupérer des vidéos et des images.
- **YouTube Player** : Intégré pour lire des vidéos YouTube directement dans l'application.
- **TypeAhead** : Utilisé pour fournir des suggestions automatiques lors de la saisie de texte.

## Conclusion

Ocean Adventure est une application complète et avancée pour les passionnés de sports nautiques, offrant un ensemble riche de fonctionnalités pour suivre les progrès, accéder à des tutoriels vidéo, gérer une liste de souhaits et recevoir des recommandations personnalisées. Grâce à l'utilisation de technologies modernes comme Flutter et Firebase, l'application assure une expérience utilisateur fluide et optimisée.
