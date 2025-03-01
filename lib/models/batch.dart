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

  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      title: map['title'],
      instructor: map['instructor'],
      timing: map['timing'] ?? "",
      date: map['date'],
      category: map['category'],
      price: map['price'],
      duration: map['duration'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instructor': instructor,
      'timing': timing,
      'date': date,
      'category': category,
      'price': price,
      'duration': duration,
    };
  }
}
