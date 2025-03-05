class Test {
  final String id;
  final String title;
  final String description;
  final double price;
  bool isUnlocked;

  Test({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isUnlocked = false,
  });

  // ✅ Add a copyWith method to update properties
  Test copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    bool? isUnlocked,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  // ✅ Convert JSON to Test object
  factory Test.fromJson(Map<String, dynamic> json) {
  return Test(
    id: json['_id'],
    title: json['title'],
    description: json['description'],
    price: double.tryParse(json['price'].toString()) ?? 0.0, // 🔥 Convert price safely
    isUnlocked: json['isUnlocked'] ?? false,
  );
}


  // ✅ Convert Test object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'isUnlocked': isUnlocked,
    };
  }
}
