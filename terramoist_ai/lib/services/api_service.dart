import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_constants.dart';
import '../models/farm.dart';
import '../models/sensor_data.dart';
import '../models/alert.dart';
import '../models/user.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<Map<String, dynamic>> _get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> _put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> _delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    } else {
      final error = jsonDecode(response.body);
      throw Exception(
        error['message'] ?? 'Server error: ${response.statusCode}',
      );
    }
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _post(AppConstants.loginEndpoint, {
      'email': email,
      'password': password,
    });
  }

  Future<User> getProfile() async {
    final data = await _get('/user/profile');
    return User.fromJson(data['user']);
  }

  // Farm endpoints
  Future<List<Farm>> getFarms() async {
    final data = await _get(AppConstants.farmsEndpoint);
    final List<dynamic> farmsJson = data['farms'];
    return farmsJson.map((json) => Farm.fromJson(json)).toList();
  }

  Future<Farm> getFarm(String farmId) async {
    final data = await _get('${AppConstants.farmsEndpoint}/$farmId');
    return Farm.fromJson(data['farm']);
  }

  Future<Farm> createFarm(Map<String, dynamic> farmData) async {
    final data = await _post(AppConstants.farmsEndpoint, farmData);
    return Farm.fromJson(data['farm']);
  }

  Future<Farm> updateFarm(String farmId, Map<String, dynamic> updates) async {
    final data = await _put('${AppConstants.farmsEndpoint}/$farmId', updates);
    return Farm.fromJson(data['farm']);
  }

  Future<void> deleteFarm(String farmId) async {
    await _delete('${AppConstants.farmsEndpoint}/$farmId');
  }

  // Sensor endpoints
  Future<SensorData> getCurrentSensorData(String farmId) async {
    final data = await _get('${AppConstants.sensorsEndpoint}/$farmId/current');
    return SensorData.fromJson(data['sensorData']);
  }

  Future<List<SensorData>> getHistoricalSensorData(
    String farmId, {
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final data = await _get(
      '${AppConstants.sensorsEndpoint}/$farmId/history?'
      'start=${startDate.toIso8601String()}&'
      'end=${endDate.toIso8601String()}',
    );
    final List<dynamic> historyJson = data['history'];
    return historyJson.map((json) => SensorData.fromJson(json)).toList();
  }

  // Alert endpoints
  Future<List<Alert>> getAlerts({String? farmId, bool? unreadOnly}) async {
    String url = AppConstants.alertsEndpoint;
    final params = [];
    if (farmId != null) params.add('farmId=$farmId');
    if (unreadOnly == true) params.add('unread=true');
    if (params.isNotEmpty) url += '?${params.join('&')}';

    final data = await _get(url);
    final List<dynamic> alertsJson = data['alerts'];
    return alertsJson.map((json) => Alert.fromJson(json)).toList();
  }

  Future<void> markAlertRead(String alertId) async {
    await _put('${AppConstants.alertsEndpoint}/$alertId/read', {});
  }

  Future<void> markAllAlertsRead() async {
    await _put('${AppConstants.alertsEndpoint}/mark-all-read', {});
  }

  // Irrigation endpoints
  Future<void> startIrrigation(
    String zoneId, {
    int durationMinutes = 30,
    int waterFlowPercent = 50,
  }) async {
    await _post('${AppConstants.irrigationEndpoint}/start', {
      'zoneId': zoneId,
      'durationMinutes': durationMinutes,
      'waterFlowPercent': waterFlowPercent,
    });
  }

  Future<void> stopIrrigation(String zoneId) async {
    await _post('${AppConstants.irrigationEndpoint}/stop', {'zoneId': zoneId});
  }

  Future<void> scheduleIrrigation(Map<String, dynamic> schedule) async {
    await _post('${AppConstants.irrigationEndpoint}/schedule', schedule);
  }
}
