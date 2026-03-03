import 'package:flutter/material.dart';
import '../../data/models/listing_model.dart';
import '../../data/services/marketplace_service.dart';

class MarketplaceProvider with ChangeNotifier {
  List<MarketplaceListing> _listings = [];
  bool _isLoading = false;
  String? _selectedCategory;

  final MarketplaceService _marketplaceService = MarketplaceService();

  List<MarketplaceListing> get listings => _listings;
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchListings({String? category}) async {
    _isLoading = true;
    _selectedCategory = category;
    notifyListeners();

    try {
      _listings = await _marketplaceService.getListings(category: category);
    } catch (e) {
      debugPrint('Error fetching listings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createListing(MarketplaceListing listing) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _marketplaceService.createListing(listing.toJson());
      await fetchListings(category: _selectedCategory);
    } catch (e) {
      debugPrint('Error creating listing: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateListingStatus(String id, String status) async {
    try {
      await _marketplaceService.updateStatus(id, status);
      await fetchListings(category: _selectedCategory);
    } catch (e) {
      debugPrint('Error updating listing status: $e');
      rethrow;
    }
  }
}
