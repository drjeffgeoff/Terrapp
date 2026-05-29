import 'package:flutter/material.dart';
import '../models/alert.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../config/app_constants.dart';

class AlertProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Alert> _alerts = [];
  bool _isLoading = false;
  String? _error;

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get unreadCount => _alerts.where((a) => !a.isRead).length;
  List<Alert> get unreadAlerts => _alerts.where((a) => !a.isRead).toList();
  List<Alert> get criticalAlerts => _alerts
      .where(
        (a) =>
            a.type == AlertType.pumpMalfunction ||
            a.type == AlertType.lowMoisture,
      )
      .toList();

  Future<void> loadAlerts({String? farmId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _alerts = await _apiService.getAlerts(farmId: farmId);
      notifyListeners();

      // Show notifications for new unread alerts
      for (final alert in _alerts.where((a) => !a.isRead)) {
        await NotificationService.showAlertNotification(
          alert.title,
          alert.message,
          alert.id,
        );
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAlertRead(String alertId) async {
    try {
      await _apiService.markAlertRead(alertId);
      final index = _alerts.indexWhere((a) => a.id == alertId);
      if (index != -1) {
        _alerts[index] = _alerts[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAlertsRead() async {
    try {
      await _apiService.markAllAlertsRead();
      _alerts = _alerts.map((a) => a.copyWith(isRead: true)).toList();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshAlerts({String? farmId}) async {
    await loadAlerts(farmId: farmId);
  }

  void startAutoRefresh({String? farmId}) {
    Future.delayed(AppConstants.alertRefreshInterval, () {
      refreshAlerts(farmId: farmId);
      startAutoRefresh(farmId: farmId);
    });
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
