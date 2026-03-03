import 'package:pashucare_app/core/services/api_client.dart';
import '../models/vet_model.dart';
import '../models/appointment_model.dart';

class HealthService {
  final ApiClient _apiClient = ApiClient();

  ApiClient getApiClient() => _apiClient;

  Future<List<Vet>> getVets({String? specialization, String? location}) async {
    try {
      String endpoint = '/vets';
      List<String> queryParams = [];
      if (specialization != null) queryParams.add('specialization=$specialization');
      if (location != null) queryParams.add('location=$location');
      
      if (queryParams.isNotEmpty) {
        endpoint += '?' + queryParams.join('&');
      }

      final response = await _apiClient.get(endpoint);
      List<dynamic> body = response['data'];
      return body.map((dynamic item) => Vet.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load doctors: $e');
    }
  }

  Future<List<Appointment>> getMyAppointments() async {
    try {
      final response = await _apiClient.get('/bookings');
      List<dynamic> body = response['data'];
      return body.map((dynamic item) => Appointment.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load appointments: $e');
    }
  }

  Future<Appointment> bookAppointment(Map<String, dynamic> bookingData) async {
    try {
      final response = await _apiClient.post('/bookings', bookingData);
      return Appointment.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to book appointment: $e');
    }
  }

  Future<void> cancelAppointment(String id) async {
    try {
      await _apiClient.put('/bookings/$id/cancel', {});
    } catch (e) {
      throw Exception('Failed to cancel appointment: $e');
    }
  }
}
