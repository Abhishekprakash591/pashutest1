import 'package:pashucare_app/core/services/api_client.dart';
import '../models/insurance_model.dart';

class InsuranceService {
  final ApiClient _apiClient = ApiClient();

  Future<List<InsurancePlan>> getPlans() async {
    try {
      final response = await _apiClient.get('/insurance');
      final data = response['data'] as List;
      return data.map((json) => InsurancePlan.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load insurance plans: $e');
    }
  }

  Future<void> seedPlans() async {
    try {
      await _apiClient.post('/insurance/seed', {});
    } catch (e) {
      // Ignore if already seeded
    }
  }
}
