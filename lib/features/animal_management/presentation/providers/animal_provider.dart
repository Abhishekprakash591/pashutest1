import 'package:flutter/material.dart';
import '../../data/models/animal_model.dart';
import '../../data/services/animal_service.dart';

class AnimalProvider with ChangeNotifier {
  List<Animal> _animals = [];
  bool _isLoading = false;
  final AnimalService _animalService = AnimalService();

  List<Animal> get animals => _animals;
  bool get isLoading => _isLoading;

  Future<void> fetchAnimals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _animals = await _animalService.getAnimals();
    } catch (e) {
      print('Error fetching animals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAnimal(Animal animal) async {
    try {
      final newAnimal = await _animalService.addAnimal(animal.toJson());
      _animals.add(newAnimal);
      notifyListeners();
    } catch (e) {
      print('Error adding animal: $e');
      rethrow;
    }
  }

  Future<void> updateAnimal(String id, Animal animal) async {
    try {
      final updatedAnimal = await _animalService.updateAnimal(id, animal.toJson());
      final index = _animals.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _animals[index] = updatedAnimal;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating animal: $e');
      rethrow;
    }
  }

  Future<void> deleteAnimal(String id) async {
    try {
      await _animalService.deleteAnimal(id);
      _animals.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting animal: $e');
      rethrow;
    }
  }
  Future<Animal> getAnimalByTagId(String tagId) async {
    try {
      return await _animalService.getAnimalByTagId(tagId);
    } catch (e) {
      print('Error finding animal by tag: $e');
      rethrow;
    }
  }
}
