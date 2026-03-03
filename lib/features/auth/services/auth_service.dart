import 'package:pashucare_app/core/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> login(String phone, String password) async {
    try {
      final response = await _apiClient.post('/farmers/login', {
        'phone': phone,
        'password': password,
      });

      if (response != null && response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token']);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> register(String name, String phone, String password, String location) async {
    try {
      final response = await _apiClient.post('/farmers', {
        'name': name,
        'phone': phone,
        'password': password,
        'location': location,
      });

      if (response != null && response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token']);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
