class Review {
  final String id;
  final String farmer;
  final String farmerName;
  final String vet;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.farmer,
    this.farmerName = '',
    required this.vet,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      farmer: json['farmer'] is Map ? json['farmer']['_id'] : (json['farmer'] ?? ''),
      farmerName: json['farmer'] is Map ? json['farmer']['name'] : '',
      vet: json['vet'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vetId': vet,
      'rating': rating,
      'comment': comment,
    };
  }
}
