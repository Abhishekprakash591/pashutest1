import 'package:flutter/material.dart';
import '../../data/models/feed_log_model.dart';
import '../../data/services/feed_service.dart';

class FeedProvider with ChangeNotifier {
  List<FeedLog> _logs = [];
  bool _isLoading = false;

  final FeedService _feedService = FeedService();

  List<FeedLog> get logs => _logs;
  bool get isLoading => _isLoading;

  Future<void> fetchFeedHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _logs = await _feedService.getFeedHistory();
    } catch (e) {
      debugPrint('Error fetching feed history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logFeedUsage({
    required String inventoryItemId,
    required double quantity,
    String? animalId,
    String activityType = 'Morning Feeding',
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _feedService.logFeedUsage(
        inventoryItemId: inventoryItemId,
        quantity: quantity,
        animalId: animalId,
        activityType: activityType,
        notes: notes,
      );
      await fetchFeedHistory(); // Refresh logs
    } catch (e) {
      debugPrint('Error logging feed usage: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
