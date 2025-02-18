class Course {
  String title;
  String instructor;
  String description;
  String category;
  String language;
  String duration;
  double price;
  bool isPrivate;
  bool hasCertificate;
  bool isOnline;
  double rating;
  List<String> tags;
  String? imagePath;
  List<String> videoPaths;
  List<String> notesPaths;
  List<String> learningPoints;
  
  

  // Getter for privacy status
  String get privacy => isPrivate ? 'Private' : 'Public';

  Course({
    required this.title,
    required this.instructor,
    required this.description,
    required this.category,
    required this.language,
    required this.duration,
    required this.price,
    required this.isPrivate,
    required this.hasCertificate,
    required this.isOnline,
    required this.rating,
    required this.tags,
    this.imagePath,
    this.videoPaths = const [],
    this.notesPaths = const [],
    required this.learningPoints, required timing, required date,
  });
}
