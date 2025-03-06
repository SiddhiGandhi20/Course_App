class Test {
  final String id;
  final String title;
  final String description;
  final double price;
  bool isUnlocked;
  final String category; // ✅ Added category field
  final List<String> images;
  final List<String> documents;

  Test({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.isUnlocked = false,
    required this.category, // ✅ Ensure category is required
    List<String>? images, 
    List<String>? documents,
  })  : images = images ?? [], 
        documents = documents ?? [];

  // ✅ Copy method to update properties
  Test copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    bool? isUnlocked,
    String? category, // ✅ Added category
    List<String>? images,
    List<String>? documents,
  }) {
    return Test(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      category: category ?? this.category, // ✅ Ensure category updates
      images: images ?? List.from(this.images),
      documents: documents ?? List.from(this.documents),
    );
  }

  // ✅ Convert JSON to Test object
  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['_id'] ?? '', 
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      isUnlocked: json['isUnlocked'] ?? false,
      category: json['category'] ?? '', // ✅ Handle category
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      documents: (json['documents'] as List?)?.map((e) => e.toString()).toList() ?? [],
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
      'category': category, // ✅ Include category in JSON
      'images': images,
      'documents': documents,
    };
  }
}
