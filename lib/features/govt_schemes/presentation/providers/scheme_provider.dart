import 'package:flutter/material.dart';
import '../../data/models/scheme_model.dart';
import '../../data/services/scheme_service.dart';

class SchemeProvider with ChangeNotifier {
  List<Scheme> _schemes = [];
  bool _isLoading = false;
  String _filter = 'All'; // All, Central, State

  final SchemeService _service = SchemeService();

  List<Scheme> get schemes => _schemes;
  bool get isLoading => _isLoading;
  String get filter => _filter;

  List<Scheme> get filteredSchemes {
    if (_filter == 'All') return _schemes;
    return _schemes.where((s) => s.type == _filter).toList();
  }

  Future<void> fetchSchemes() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Attempt to seed first just in case (for demo)
      await _service.seedSchemes();
      
      _schemes = await _service.fetchSchemes();
    } catch (e) {
      debugPrint('Error fetching schemes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }
}
