import 'package:flutter/material.dart';
import '../../data/models/milk_sale_model.dart';
import '../../data/services/milk_sale_service.dart';

class MilkSaleProvider with ChangeNotifier {
  List<MilkSale> _sales = [];
  bool _isLoading = false;
  Map<String, dynamic> _monthlyStats = {};

  final MilkSaleService _service = MilkSaleService();

  List<MilkSale> get sales => _sales;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get monthlyStats => _monthlyStats;

  Future<void> fetchSales() async {
    _isLoading = true;
    notifyListeners();
    try {
      _sales = await _service.getSalesHistory();
      _monthlyStats = await _service.getAnalytics();
    } catch (e) {
      debugPrint('Error fetching milk sales: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> recordSale(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.recordSale(data);
      await fetchSales(); // Refresh list and stats
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
