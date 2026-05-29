import 'package:flutter/material.dart';
import '../models/sensor_data.dart';
import '../services/api_service.dart';
import '../config/app_constants.dart';

class SensorProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<SensorData> _historicalData = [];
  SensorData? _currentData;
  bool _isLoading = false;
  bool _isRefreshing = false;
  String? _error;

  List<SensorData> get historicalData => _historicalData;
  SensorData? get currentData => _currentData;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;

  Future<void> loadCurrentData(String farmId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentData = await _apiService.getCurrentSensorData(farmId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistoricalData(
    String farmId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final start =
          startDate ?? DateTime.now().subtract(const Duration(days: 7));
      final end = endDate ?? DateTime.now();

      _historicalData = await _apiService.getHistoricalSensorData(
        farmId,
        startDate: start,
        endDate: end,
      );
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData(String farmId) async {
    _isRefreshing = true;
    notifyListeners();

    await Future.wait([loadCurrentData(farmId), loadHistoricalData(farmId)]);

    _isRefreshing = false;
    notifyListeners();
  }

  void startAutoRefresh(String farmId) {
    Future.delayed(AppConstants.sensorRefreshInterval, () {
      if (_isRefreshing) return;
      refreshData(farmId);
      startAutoRefresh(farmId);
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
