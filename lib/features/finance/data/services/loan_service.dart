import 'package:pashucare_app/core/services/api_client.dart';
import '../models/loan_model.dart';

class LoanService {
  final ApiClient _apiClient = ApiClient();

  Future<List<LoanProduct>> getLoans({String type = 'All'}) async {
    try {
      final endpoint = type == 'All' ? '/loans' : '/loans?type=$type';
      final response = await _apiClient.get(endpoint);
      final data = response['data'] as List;
      return data.map((json) => LoanProduct.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load loans: $e');
    }
  }

  Future<void> seedLoans() async {
    try {
      await _apiClient.post('/loans/seed', {});
    } catch (e) {
      // Ignore
    }
  }
}
