class Scheme {
  final String id;
  final String name;
  final String description;
  final String eligibility;
  final String benefits;
  final String applicationLink;
  final String type; // Central, State

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.eligibility,
    required this.benefits,
    required this.applicationLink,
    required this.type,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      eligibility: json['eligibility'],
      benefits: json['benefits'],
      applicationLink: json['applicationLink'],
      type: json['type'] ?? 'Central',
    );
  }
}
