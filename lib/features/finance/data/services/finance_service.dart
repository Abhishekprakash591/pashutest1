import 'package:pashucare_app/core/services/api_client.dart';
import '../models/transaction_model.dart';

class FinanceService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _apiClient.get('/transactions');
      final data = response['data'] as List;
      return data.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  Future<Map<String, dynamic>> getSummary() async {
    try {
      final response = await _apiClient.get('/transactions/summary');
      return response;
    } catch (e) {
      throw Exception('Failed to load summary: $e');
    }
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    try {
      await _apiClient.post('/transactions', data);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }
}
