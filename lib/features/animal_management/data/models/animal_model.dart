class Animal {
  final String id;
  final String tagId;
  final String name;
  final String species;
  final String? breed;
  final DateTime? dob;
  final String sex;
  final double? weight;
  final String healthStatus;
  final String productionStatus;
  final double? milkCapacity;
  final DateTime? lastVaccinationDate;
  final List<String> photos;
  final String farmerId;
  final String? notes;

  Animal({
    required this.id,
    required this.tagId,
    required this.name,
    required this.species,
    this.breed,
    this.dob,
    required this.sex,
    this.weight,
    required this.healthStatus,
    required this.productionStatus,
    this.milkCapacity,
    this.lastVaccinationDate,
    required this.photos,
    required this.farmerId,
    this.notes,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['_id'],
      tagId: json['tagId'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      sex: json['sex'],
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      healthStatus: json['healthStatus'] ?? 'Healthy',
      productionStatus: json['productionStatus'] ?? 'None',
      milkCapacity: json['milkCapacity'] != null ? (json['milkCapacity'] as num).toDouble() : null,
      lastVaccinationDate: json['lastVaccinationDate'] != null ? DateTime.parse(json['lastVaccinationDate']) : null,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
      farmerId: json['farmer'] ?? '', // Extract farmer if object or string
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'name': name,
      'species': species,
      'breed': breed,
      'dob': dob?.toIso8601String(),
      'sex': sex,
      'weight': weight,
      'healthStatus': healthStatus,
      'productionStatus': productionStatus,
      'milkCapacity': milkCapacity,
      'lastVaccinationDate': lastVaccinationDate?.toIso8601String(),
      'photos': photos,
      'notes': notes,
    };
  }
}
