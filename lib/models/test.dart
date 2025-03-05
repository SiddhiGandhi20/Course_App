class Test {
  final String id;
  final String title;
  final String description;
  final double price;
  bool isUnlocked;
  final List<String> images; // ✅ Added images list
  final List<String> documents; // ✅ Added documents list

  Test({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isUnlocked = false,
    this.images = const [], // Default empty list
    this.documents = const [], // Default empty list
  });

  // ✅ Copy with method to update properties
  Test copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    bool? isUnlocked,
    List<String>? images,
    List<String>? documents,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      images: images ?? this.images,
      documents: documents ?? this.documents,
    );
  }

  // ✅ Convert JSON to Test object
  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0, // 🔥 Safe conversion
      isUnlocked: json['isUnlocked'] ?? false,
      images: List<String>.from(json['images'] ?? []), // 🔥 Handle images list
      documents: List<String>.from(json['documents'] ?? []), // 🔥 Handle documents list
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
      'images': images, // 🔥 Include images in JSON
      'documents': documents, // 🔥 Include documents in JSON
    };
  }
}
