import 'package:flutter/material.dart';
import '../../data/models/vet_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/services/health_service.dart';
import '../../data/models/disease_model.dart';
import '../../data/services/diagnosis_service.dart';
import '../../data/models/review_model.dart';
import '../../data/models/outbreak_model.dart';
import '../../data/services/outbreak_service.dart';

class HealthProvider with ChangeNotifier {
  List<Vet> _vets = [];
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  List<String> _availableSymptoms = [];
  List<DiagnosisResult> _diagnosisResults = [];
  List<Review> _vetReviews = [];
  List<OutbreakReport> _outbreakReports = [];
  
  final HealthService _healthService = HealthService();
  final DiagnosisService _diagnosisService = DiagnosisService();
  final OutbreakService _outbreakService = OutbreakService();

  List<Vet> get vets => _vets;
  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  List<String> get availableSymptoms => _availableSymptoms;
  List<DiagnosisResult> get diagnosisResults => _diagnosisResults;
  List<Review> get vetReviews => _vetReviews;
  List<OutbreakReport> get outbreakReports => _outbreakReports;

  Future<void> fetchVets({String? specialization, String? location}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _vets = await _healthService.getVets(
        specialization: specialization,
        location: location,
      );
    } catch (e) {
      print('Error fetching vets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAppointments() async {
    _isLoading = true;
    notifyListeners();

    try {
      _appointments = await _healthService.getMyAppointments();
    } catch (e) {
      print('Error fetching appointments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bookAppointment(Appointment appointment) async {
    try {
      final newAppointment = await _healthService.bookAppointment(appointment.toJson());
      _appointments.insert(0, newAppointment);
      notifyListeners();
    } catch (e) {
      print('Error booking appointment: $e');
      rethrow;
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await _healthService.cancelAppointment(id);
      final index = _appointments.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _appointments[index] = Appointment(
          id: _appointments[index].id,
          vet: _appointments[index].vet,
          animal: _appointments[index].animal,
          appointmentDate: _appointments[index].appointmentDate,
          status: 'Cancelled',
          reason: _appointments[index].reason,
          notes: _appointments[index].notes,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error cancelling appointment: $e');
      rethrow;
    }
  }

  Future<void> fetchAvailableSymptoms() async {
    _isLoading = true;
    notifyListeners();

    try {
      _availableSymptoms = await _diagnosisService.fetchAllSymptoms();
    } catch (e) {
      print('Error fetching symptoms: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> performDiagnosis({required String species, required List<String> symptoms}) async {
    _isLoading = true;
    _diagnosisResults = [];
    notifyListeners();

    try {
      _diagnosisResults = await _diagnosisService.diagnose(
        species: species,
        symptoms: symptoms,
      );
    } catch (e) {
      print('Error performing diagnosis: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVetReviews(String vetId) async {
    _isLoading = true;
    _vetReviews = [];
    notifyListeners();

    try {
      final response = await _healthService.getApiClient().get('/reviews/vet/$vetId');
      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'];
        _vetReviews = data.map((item) => Review.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addReview(Review review) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _healthService.getApiClient().post('/reviews', review.toJson());
      // Refresh vets to get updated average rating
      await fetchVets();
    } catch (e) {
      print('Error adding review: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOutbreaks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _outbreakReports = await _outbreakService.getHeatmapData();
    } catch (e) {
      print('Error fetching outbreaks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reportOutbreak({
    required String diseaseId,
    required double longitude,
    required double latitude,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _outbreakService.reportOutbreak(
        diseaseId: diseaseId,
        longitude: longitude,
        latitude: latitude,
      );
      if (success) {
        await fetchOutbreaks();
      }
    } catch (e) {
      print('Error reporting outbreak: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
