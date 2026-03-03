import 'package:pashucare_app/core/services/api_client.dart';
import '../models/milk_sale_model.dart';

class MilkSaleService {
  final ApiClient _apiClient = ApiClient();

  Future<void> recordSale(Map<String, dynamic> saleData) async {
    try {
      await _apiClient.post('/milk-sales', saleData);
    } catch (e) {
      throw Exception('Failed to record milk sale: $e');
    }
  }

  Future<List<MilkSale>> getSalesHistory() async {
    try {
      final response = await _apiClient.get('/milk-sales');
      final data = response['data'] as List;
      return data.map((json) => MilkSale.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch milk sales: $e');
    }
  }

  Future<Map<String, dynamic>> getAnalytics() async { // Monthly stats
    try {
      final response = await _apiClient.get('/milk-sales/analytics');
      return response['data'] ?? {};
    } catch (e) {
      // Return empty stats on error
      return {'totalLiters': 0, 'totalEarnings': 0, 'avgFat': 0};
    }
  }
}
