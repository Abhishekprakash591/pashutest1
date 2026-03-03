import 'package:flutter/material.dart';
import '../../data/models/certification_model.dart';
import '../../data/services/certification_service.dart';

class CertificationProvider with ChangeNotifier {
  final CertificationService _service = CertificationService();
  List<Certification> _certifications = [];
  bool _isLoading = false;

  List<Certification> get certifications => _certifications;
  bool get isLoading => _isLoading;

  Future<void> fetchCertifications() async {
    _isLoading = true;
    notifyListeners();
    try {
      _certifications = await _service.getMyCertifications();
    } catch (e) {
      debugPrint('Error fetching certifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> applyForCertification(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final newCert = await _service.applyForCertification(data);
      _certifications.add(newCert);
      notifyListeners();
    } catch (e) {
      debugPrint('Error applying for certification: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
