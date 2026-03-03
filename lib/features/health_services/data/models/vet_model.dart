class Vet {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final String location;
  final String phone;
  final String clinicAddress;
  final double rating;
  final int numReviews;
  final bool isVerified;
  final List<String> availability;
  final String profileImage;

  Vet({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.location,
    required this.phone,
    required this.clinicAddress,
    this.rating = 0.0,
    this.numReviews = 0,
    this.isVerified = false,
    this.availability = const [],
    this.profileImage = '',
  });

  factory Vet.fromJson(Map<String, dynamic> json) {
    return Vet(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? 0,
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      clinicAddress: json['clinicAddress'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      numReviews: json['numReviews'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      availability: List<String>.from(json['availability'] ?? []),
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'location': location,
      'phone': phone,
      'clinicAddress': clinicAddress,
      'rating': rating,
      'numReviews': numReviews,
      'isVerified': isVerified,
      'availability': availability,
      'profileImage': profileImage,
    };
  }
}
