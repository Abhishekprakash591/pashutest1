import '../../../animal_management/data/models/animal_model.dart';
import 'vet_model.dart';

class Appointment {
  final String id;
  final dynamic vet; // Can be String ID or Vet object
  final dynamic animal; // Can be String ID or Animal object
  final DateTime appointmentDate;
  final String status;
  final String reason;
  final String notes;

  Appointment({
    required this.id,
    required this.vet,
    required this.animal,
    required this.appointmentDate,
    required this.status,
    required this.reason,
    required this.notes,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? '',
      vet: json['vet'] is Map<String, dynamic> 
          ? Vet.fromJson(json['vet']) 
          : (json['vet'] ?? ''),
      animal: json['animal'] is Map<String, dynamic> 
          ? Animal.fromJson(json['animal']) 
          : (json['animal'] ?? ''),
      appointmentDate: DateTime.parse(json['appointmentDate']),
      status: json['status'] ?? 'Pending',
      reason: json['reason'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vet': vet is Vet ? vet.id : vet,
      'animal': animal is Animal ? animal.id : animal,
      'appointmentDate': appointmentDate.toIso8601String(),
      'reason': reason,
      'notes': notes,
    };
  }
}
