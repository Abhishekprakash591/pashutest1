import 'package:pashucare_app/core/services/api_client.dart';
import '../models/feed_log_model.dart';

class FeedService {
  final ApiClient _apiClient = ApiClient();

  Future<void> logFeedUsage({
    required String inventoryItemId,
    required double quantity,
    String? animalId,
    String activityType = 'Morning Feeding',
    String? notes,
  }) async {
    try {
      await _apiClient.post('/feed/log', {
        'inventoryItemId': inventoryItemId,
        'quantity': quantity,
        'animalId': animalId,
        'activityType': activityType,
        'notes': notes,
        'feedingDate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to log feed usage: $e');
    }
  }

  Future<List<FeedLog>> getFeedHistory() async {
    try {
      final response = await _apiClient.get('/feed/history');
      final data = response['data'] as List;
      return data.map((item) => FeedLog.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch feed history: $e');
    }
  }

  // Helper to fetch only Feed items from inventory (reuse inventory endpoint with client-side filtering or add query param if backend supports)
  // Since we don't have category filter on inventory endpoint yet, we might need to filter client side or update InventoryService.
  // Actually, we can just use InventoryProvider.
}
