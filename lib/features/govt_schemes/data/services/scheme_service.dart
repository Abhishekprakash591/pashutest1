import 'package:pashucare_app/core/services/api_client.dart';
import '../models/scheme_model.dart';

class SchemeService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Scheme>> fetchSchemes({String? type}) async {
    try {
      final endpoint = type != null ? '/schemes?type=$type' : '/schemes';
      final response = await _apiClient.get(endpoint);
      
      final data = response['data'] as List;
      return data.map((json) => Scheme.fromJson(json)).toList();
    } catch (e) {
      // Temporary: If offline or initial, return empty list or mock data could be here
      throw Exception('Failed to load schemes: $e');
    }
  }

  // Helper to trigger seed if empty (for demo purposes)
  Future<void> seedSchemes() async {
    try {
      await _apiClient.post('/schemes/seed', {});
    } catch (e) {
      // Ignore if already seeded
    }
  }
}
