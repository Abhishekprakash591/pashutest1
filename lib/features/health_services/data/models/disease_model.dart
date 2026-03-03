class Disease {
  final String id;
  final String name;
  final List<String> species;
  final List<String> symptoms;
  final String severity;
  final String prevention;
  final String treatment;
  final bool isContagious;

  Disease({
    required this.id,
    required this.name,
    required this.species,
    required this.symptoms,
    required this.severity,
    required this.prevention,
    required this.treatment,
    required this.isContagious,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      species: List<String>.from(json['species'] ?? []),
      symptoms: List<String>.from(json['symptoms'] ?? []),
      severity: json['severity'] ?? 'Medium',
      prevention: json['prevention'] ?? '',
      treatment: json['treatment'] ?? '',
      isContagious: json['isContagious'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'species': species,
      'symptoms': symptoms,
      'severity': severity,
      'prevention': prevention,
      'treatment': treatment,
      'isContagious': isContagious,
    };
  }
}

class DiagnosisResult {
  final Disease disease;
  final int matchCount;
  final double matchPercentage;
  final List<String> commonSymptoms;

  DiagnosisResult({
    required this.disease,
    required this.matchCount,
    required this.matchPercentage,
    required this.commonSymptoms,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    return DiagnosisResult(
      disease: Disease.fromJson(json['disease']),
      matchCount: json['matchCount'] ?? 0,
      matchPercentage: (json['matchPercentage'] ?? 0).toDouble(),
      commonSymptoms: List<String>.from(json['commonSymptoms'] ?? []),
    );
  }
}
