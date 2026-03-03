import 'package:pashucare_app/core/services/api_client.dart';
import '../models/outbreak_model.dart';

class OutbreakService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> reportOutbreak({
    required String diseaseId,
    required double longitude,
    required double latitude,
  }) async {
    final response = await _apiClient.post('/outbreaks/report', {
      'diseaseId': diseaseId,
      'longitude': longitude,
      'latitude': latitude,
    });
    return response != null && response['success'] == true;
  }

  Future<List<OutbreakReport>> getHeatmapData() async {
    final response = await _apiClient.get('/outbreaks/heatmap');
    if (response != null && response['success'] == true) {
      final List<dynamic> data = response['data'];
      return data.map((item) => OutbreakReport.fromJson(item)).toList();
    }
    return [];
  }
}
