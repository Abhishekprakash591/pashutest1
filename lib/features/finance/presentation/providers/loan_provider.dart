import 'package:flutter/material.dart';
import '../../data/models/loan_model.dart';
import '../../data/services/loan_service.dart';

class LoanProvider with ChangeNotifier {
  List<LoanProduct> _loans = [];
  bool _isLoading = false;
  String _filter = 'All'; // All, Dairy, Equipment, General

  final LoanService _service = LoanService();

  List<LoanProduct> get loans => _loans;
  bool get isLoading => _isLoading;
  String get filter => _filter;

  Future<void> fetchLoans() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.seedLoans();
      _loans = await _service.getLoans(type: _filter);
    } catch (e) {
      debugPrint('Error fetching loans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _filter = filter;
    fetchLoans(); // Refetch with filter query
  }
}
