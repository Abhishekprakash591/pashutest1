import 'package:pashucare_app/core/services/api_client.dart';
import '../models/inventory_item_model.dart';

class InventoryService {
  final ApiClient _apiClient = ApiClient();

  Future<List<InventoryItem>> getItems({String? search}) async {
    try {
      String endpoint = '/inventory';
      if (search != null && search.isNotEmpty) {
        endpoint += '?search=$search';
      }
      final response = await _apiClient.get(endpoint);
      // Handle paginated response structure
      List<dynamic> body = response['data'];
      return body.map((dynamic item) => InventoryItem.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load inventory items: $e');
    }
  }

  Future<InventoryItem> addItem(Map<String, dynamic> itemData) async {
    try {
      final response = await _apiClient.post('/inventory', itemData);
      return InventoryItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add item: $e');
    }
  }

  Future<InventoryItem> updateItem(String id, Map<String, dynamic> itemData) async {
    try {
      final response = await _apiClient.put('/inventory/$id', itemData);
      return InventoryItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _apiClient.delete('/inventory/$id');
    } catch (e) {
      throw Exception('Failed to delete item: $e');
    }
  }

  Future<Map<String, List<InventoryItem>>> getAlerts() async {
    try {
      final response = await _apiClient.get('/inventory/alerts');
      return {
        'lowStock': (response['lowStock'] as List).map((e) => InventoryItem.fromJson(e)).toList(),
        'expiringSoon': (response['expiringSoon'] as List).map((e) => InventoryItem.fromJson(e)).toList(),
        'expired': (response['expired'] as List).map((e) => InventoryItem.fromJson(e)).toList(),
      };
    } catch (e) {
      throw Exception('Failed to fetch alerts: $e');
    }
  }
}
