import 'dart:convert';

class Course {
  final String id; // ✅ Store MongoDB _id as a String
  final String title;
  final String instructor;
  final String description;
  final String category;
  final String language;
  final String duration;
  final double price;
  final bool isPrivate;
  final bool hasCertificate;
  final bool isOnline;
  final double rating;
  final List<String> tags;
  final String? imagePath;
  final List<String> videoPaths;
  final List<String> notesPaths;
  final List<String> learningPoints;
  final String timing;
  final String date;

  Course({
    required this.id,
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
    required this.learningPoints,
    required this.timing,
    required this.date,
  });

  /// ✅ Convert JSON from MongoDB (_id to id)
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json["_id"]?.toString() ?? "", // ✅ Ensure _id is stored as a String
      title: json["title"] ?? "Untitled",
      instructor: json["instructor"] ?? "Unknown",
      description: json["description"] ?? "",
      category: json["category"] ?? "Uncategorized",
      language: json["language"] ?? "Unknown",
      duration: json["duration"]?.toString() ?? "0",
      price: (json["price"] ?? 0).toDouble(),
      isPrivate: json["is_private"] ?? false,
      hasCertificate: json["has_certificate"] ?? false,
      isOnline: json["is_online"] ?? false,
      rating: (json["rating"] ?? 0).toDouble(),
      tags: (json["tags"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      imagePath: json["image_path"],
      videoPaths: (json["video_paths"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      notesPaths: (json["notes_paths"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      learningPoints: (json["learning_points"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      timing: json["timing"] ?? "",
      date: json["date"] ?? "",
    );
  }

  /// ✅ Convert Course to JSON for API
  Map<String, dynamic> toJson() {
    return {
      "_id": id, // ✅ Send ID as _id in API requests
      "title": title,
      "instructor": instructor,
      "description": description,
      "category": category,
      "language": language,
      "duration": duration,
      "price": price,
      "is_private": isPrivate,
      "has_certificate": hasCertificate,
      "is_online": isOnline,
      "rating": rating,
      "tags": tags,
      "image_path": imagePath,
      "video_paths": videoPaths,
      "notes_paths": notesPaths,
      "learning_points": learningPoints,
      "timing": timing,
      "date": date,
    };
  }

  /// ✅ Empty Course for error handling
  factory Course.empty() {
    return Course(
      id: "",
      title: "Course Not Found",
      instructor: "",
      description: "",
      category: "",
      language: "",
      duration: "0",
      price: 0.0,
      isPrivate: false,
      hasCertificate: false,
      isOnline: false,
      rating: 0.0,
      tags: [],
      learningPoints: [],
      timing: "",
      date: "",
    );
  }
}
