class Batch {
  final String title;
  final String instructor;
  final String timing;
  final String date;
  final String category;
  final String price;
  final String duration;

  Batch({
    required this.title,
    required this.instructor,
    required this.timing,
    required this.date,
    required this.category,
    required this.price,
    required this.duration,
  });

  // Convert JSON to Batch object
  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      title: json['title'] ?? '',
      instructor: json['instructor'] ?? '',
      timing: json['timing'] ?? '',
      date: json['date'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? '0',
      duration: json['duration'] ?? '',
    );
  }
}
