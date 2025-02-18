class Batch {
  final String title;
  final String instructor;
  final String timing;
  final String date;
  final String category;
  final String price;

  Batch({
    required this.title,
    required this.instructor,
    required this.timing,
    required this.date,
    required this.category,
    required this.price,
  });

  // Convert a Map to a Batch object
  factory Batch.fromMap(Map<String, dynamic> map) {
    return Batch(
      title: map['title'],
      instructor: map['instructor'],
      timing: map['timing'],
      date: map['date'],
      category: map['category'],
      price: map['price'],
    );
  }

  // Optionally, you can add a toMap method to convert the Batch back to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'instructor': instructor,
      'timing': timing,
      'date': date,
      'category': category,
      'price': price,
    };
  }
}
