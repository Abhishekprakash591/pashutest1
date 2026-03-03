import 'package:flutter/material.dart';
import '../../data/models/inventory_item_model.dart';
import '../../data/services/inventory_service.dart';

class InventoryProvider with ChangeNotifier {
  List<InventoryItem> _items = [];
  bool _isLoading = false;
  List<InventoryItem> _lowStockItems = [];
  List<InventoryItem> _expiringSoonItems = [];
  List<InventoryItem> _expiredItems = [];
  final InventoryService _inventoryService = InventoryService();

  List<InventoryItem> get items => _items;
  bool get isLoading => _isLoading;
  List<InventoryItem> get lowStockItems => _lowStockItems;
  List<InventoryItem> get expiringSoonItems => _expiringSoonItems;
  List<InventoryItem> get expiredItems => _expiredItems;
  int get totalAlerts => _lowStockItems.length + _expiringSoonItems.length + _expiredItems.length;

  Future<void> fetchItems({String? search}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await _inventoryService.getItems(search: search);
    } catch (e) {
      print('Error fetching inventory: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(InventoryItem item) async {
    try {
      final newItem = await _inventoryService.addItem(item.toJson());
      _items.insert(0, newItem); // Add to top of list
      notifyListeners();
    } catch (e) {
      print('Error adding item: $e');
      rethrow;
    }
  }

  Future<void> updateItem(String id, InventoryItem item) async {
    try {
      final updatedItem = await _inventoryService.updateItem(id, item.toJson());
      final index = _items.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _items[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating item: $e');
      rethrow;
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _inventoryService.deleteItem(id);
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting item: $e');
      rethrow;
    }
  }

  Future<void> fetchAlerts() async {
    try {
      final alerts = await _inventoryService.getAlerts();
      _lowStockItems = alerts['lowStock'] ?? [];
      _expiringSoonItems = alerts['expiringSoon'] ?? [];
      _expiredItems = alerts['expired'] ?? [];
      notifyListeners();
    } catch (e) {
      print('Error fetching alerts: $e');
    }
  }
}
