class Certification {
  final String id;
  final String certificationName;
  final String authority;
  final String status;
  final DateTime applicationDate;
  final DateTime? expiryDate;
  final String? documentUrl;
  final String? notes;

  Certification({
    required this.id,
    required this.certificationName,
    required this.authority,
    required this.status,
    required this.applicationDate,
    this.expiryDate,
    this.documentUrl,
    this.notes,
  });

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['_id'],
      certificationName: json['certificationName'],
      authority: json['authority'],
      status: json['status'],
      applicationDate: DateTime.parse(json['applicationDate']),
      expiryDate: json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      documentUrl: json['documentUrl'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificationName': certificationName,
      'authority': authority,
      'status': status,
      'applicationDate': applicationDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'documentUrl': documentUrl,
      'notes': notes,
    };
  }
}
