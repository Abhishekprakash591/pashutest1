class MarketplaceListing {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerPhone;
  final String title;
  final String description;
  final String category;
  final double price;
  final List<String> images;
  final String location;
  final String status;
  final String? animalRef;
  final DateTime createdAt;

  MarketplaceListing({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhone,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.images,
    required this.location,
    required this.status,
    this.animalRef,
    required this.createdAt,
  });

  factory MarketplaceListing.fromJson(Map<String, dynamic> json) {
    final seller = json['seller'] as Map<String, dynamic>?;
    
    return MarketplaceListing(
      id: json['_id'] ?? '',
      sellerId: seller?['_id'] ?? '',
      sellerName: seller?['name'] ?? 'Unknown Seller',
      sellerPhone: seller?['phone'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      location: json['location'] ?? '',
      status: json['status'] ?? 'Available',
      animalRef: json['animalRef'] is Map ? json['animalRef']['_id'] : json['animalRef'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'images': images,
      'location': location,
      'status': status,
      'animalRef': animalRef,
    };
  }
}
