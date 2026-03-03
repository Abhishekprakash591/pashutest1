import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/finance_service.dart';

class FinanceProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  Map<String, dynamic> _summary = {};

  final FinanceService _service = FinanceService();

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get summary => _summary;

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _transactions = await _service.getTransactions();
      _summary = await _service.getSummary();
    } catch (e) {
      debugPrint('Error fetching finance data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.addTransaction(data);
      await fetchData(); // Refresh list and summary
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
