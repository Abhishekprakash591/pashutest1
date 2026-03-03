import 'package:pashucare_app/core/services/api_client.dart';
import '../models/disease_model.dart';

class DiagnosisService {
  final ApiClient _apiClient = ApiClient();

  Future<List<String>> fetchAllSymptoms() async {
    final response = await _apiClient.get('/diseases/symptoms');
    if (response != null && response['success'] == true) {
      return List<String>.from(response['data']);
    }
    return [];
  }

  Future<List<DiagnosisResult>> diagnose({
    required String species,
    required List<String> symptoms,
  }) async {
    final response = await _apiClient.post('/diseases/diagnose', {
      'species': species,
      'symptoms': symptoms,
    });

    if (response != null && response['success'] == true) {
      final List<dynamic> data = response['data'];
      return data.map((item) => DiagnosisResult.fromJson(item)).toList();
    }
    return [];
  }

  Future<Disease?> fetchDiseaseById(String id) async {
    final response = await _apiClient.get('/diseases/$id');
    if (response != null && response['success'] == true) {
      return Disease.fromJson(response['data']);
    }
    return null;
  }
}
