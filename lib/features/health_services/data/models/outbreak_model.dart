class OutbreakReport {
  final String id;
  final String diseaseName;
  final String severity;
  final double latitude;
  final double longitude;
  final DateTime reportedAt;

  OutbreakReport({
    required this.id,
    required this.diseaseName,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.reportedAt,
  });

  factory OutbreakReport.fromJson(Map<String, dynamic> json) {
    return OutbreakReport(
      id: json['id'] ?? '',
      diseaseName: json['diseaseName'] ?? '',
      severity: json['severity'] ?? 'Medium',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      reportedAt: DateTime.parse(json['reportedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
