import 'package:flutter/material.dart';
import '../models/farm.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class FarmProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Farm> _farms = [];
  Farm? _selectedFarm;
  bool _isLoading = false;
  String? _error;

  List<Farm> get farms => _farms;
  Farm? get selectedFarm => _selectedFarm;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFarms() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _farms = await _apiService.getFarms();

      // Load selected farm from storage if available
      final savedFarm = StorageService.getSelectedFarm();
      if (savedFarm != null && _farms.any((f) => f.id == savedFarm.id)) {
        _selectedFarm = savedFarm;
      } else if (_farms.isNotEmpty) {
        _selectedFarm = _farms.first;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectFarm(Farm farm) async {
    _selectedFarm = farm;
    await StorageService.setSelectedFarm(farm);
    notifyListeners();
  }

  Future<void> addFarm(Farm farm) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newFarm = await _apiService.createFarm(farm.toJson());
      _farms.add(newFarm);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateFarm(Farm farm) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedFarm = await _apiService.updateFarm(farm.id, farm.toJson());
      final index = _farms.indexWhere((f) => f.id == farm.id);
      if (index != -1) {
        _farms[index] = updatedFarm;
      }
      if (_selectedFarm?.id == farm.id) {
        _selectedFarm = updatedFarm;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFarm(String farmId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteFarm(farmId);
      _farms.removeWhere((f) => f.id == farmId);
      if (_selectedFarm?.id == farmId) {
        _selectedFarm = _farms.isNotEmpty ? _farms.first : null;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
