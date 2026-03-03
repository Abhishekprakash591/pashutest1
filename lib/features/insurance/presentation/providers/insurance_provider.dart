import 'package:flutter/material.dart';
import '../../data/models/insurance_model.dart';
import '../../data/services/insurance_service.dart';

class InsuranceProvider with ChangeNotifier {
  List<InsurancePlan> _plans = [];
  bool _isLoading = false;

  final InsuranceService _service = InsuranceService();

  List<InsurancePlan> get plans => _plans;
  bool get isLoading => _isLoading;

  Future<void> fetchPlans() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.seedPlans();
      _plans = await _service.getPlans();
    } catch (e) {
      debugPrint('Error fetching insurance plans: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
