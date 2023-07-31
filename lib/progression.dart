class Progression {
  final String id;
  final String date;
  final String location;
  final String weather;
  final String comment;
  final String videoUrl;
  final String userId;

  Progression({
    required this.id,
    required this.date,
    required this.location,
    required this.weather,
    required this.comment,
    required this.videoUrl,
    required this.userId,
  });

  factory Progression.fromMap(Map<String, dynamic> map, String id) {
    return Progression(
      id: id,
      date: map['date'] ?? '',
      location: map['location'] ?? '',
      weather: map['weather'] ?? '',
      comment: map['comment'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'location': location,
      'weather': weather,
      'comment': comment,
      'videoUrl': videoUrl,
      'userId': userId,
    };
  }
}
