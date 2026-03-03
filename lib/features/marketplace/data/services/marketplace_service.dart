import 'package:pashucare_app/core/services/api_client.dart';
import '../models/listing_model.dart';

class MarketplaceService {
  final ApiClient _apiClient = ApiClient();

  Future<List<MarketplaceListing>> getListings({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? status,
  }) async {
    try {
      String endpoint = '/listings';
      List<String> queryParams = [];
      
      if (category != null) queryParams.add('category=$category');
      if (status != null) queryParams.add('status=$status');
      if (minPrice != null) queryParams.add('minPrice=$minPrice');
      if (maxPrice != null) queryParams.add('maxPrice=$maxPrice');
      
      if (queryParams.isNotEmpty) {
        endpoint += '?' + queryParams.join('&');
      }

      final response = await _apiClient.get(endpoint);
      List<dynamic> body = response['data'];
      return body.map((item) => MarketplaceListing.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load listings: $e');
    }
  }

  Future<MarketplaceListing> createListing(Map<String, dynamic> listingData) async {
    try {
      final response = await _apiClient.post('/listings', listingData);
      return MarketplaceListing.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to create listing: $e');
    }
  }

  Future<MarketplaceListing> updateStatus(String id, String status) async {
    try {
      final response = await _apiClient.put('/listings/$id/status', {'status': status});
      return MarketplaceListing.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update listing status: $e');
    }
  }

  Future<MarketplaceListing> getListingById(String id) async {
    try {
      final response = await _apiClient.get('/listings/$id');
      return MarketplaceListing.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to load listing: $e');
    }
  }
}
