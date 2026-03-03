class InsurancePlan {
  final String id;
  final String providerName;
  final String planName;
  final String description;
  final double premiumRate; // Percentage
  final int coverageDurationMonths;
  final double maxCoverageAmount;
  final List<String> tags;

  InsurancePlan({
    required this.id,
    required this.providerName,
    required this.planName,
    required this.description,
    required this.premiumRate,
    required this.coverageDurationMonths,
    required this.maxCoverageAmount,
    required this.tags,
  });

  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      id: json['_id'],
      providerName: json['providerName'],
      planName: json['planName'],
      description: json['description'],
      premiumRate: (json['premiumRate'] as num).toDouble(),
      coverageDurationMonths: json['coverageDurationMonths'],
      maxCoverageAmount: (json['maxCoverageAmount'] as num).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
