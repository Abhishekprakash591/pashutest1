import 'package:pashucare_app/core/services/api_client.dart';
import '../models/certification_model.dart';

class CertificationService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Certification>> getMyCertifications() async {
    try {
      final response = await _apiClient.get('/certifications');
      final List data = response['data'];
      return data.map((json) => Certification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch certifications: $e');
    }
  }

  Future<Certification> applyForCertification(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post('/certifications', data);
      return Certification.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to apply for certification: $e');
    }
  }
}
