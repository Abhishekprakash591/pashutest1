import 'package:pashucare_app/core/services/api_client.dart';
import '../models/animal_model.dart';

class AnimalService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Animal>> getAnimals() async {
    try {
      final response = await _apiClient.get('/animals');
      // Handle paginated response structure
      List<dynamic> body = response['data']; 
      return body.map((dynamic item) => Animal.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load animals: $e');
    }
  }

  Future<Animal> addAnimal(Map<String, dynamic> animalData) async {
    try {
      final response = await _apiClient.post('/animals', animalData);
      return Animal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add animal: $e');
    }
  }

  Future<Animal> updateAnimal(String id, Map<String, dynamic> animalData) async {
    try {
      final response = await _apiClient.put('/animals/$id', animalData);
      return Animal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update animal: $e');
    }
  }

  Future<void> deleteAnimal(String id) async {
    try {
      await _apiClient.delete('/animals/$id');
    } catch (e) {
      throw Exception('Failed to delete animal: $e');
    }
  }

  Future<Animal> getAnimalByTagId(String tagId) async {
    try {
      final response = await _apiClient.get('/animals/tag/$tagId');
      return Animal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find animal: $e');
    }
  }
}
