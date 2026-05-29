class AppConstants {
  static const String appName = 'TerraMoist AI';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String baseUrl = 'https://api.terramoist.ai/v1';
  static const String loginEndpoint = '/auth/login';
  static const String farmsEndpoint = '/farms';
  static const String sensorsEndpoint = '/sensors';
  static const String alertsEndpoint = '/alerts';
  static const String irrigationEndpoint = '/irrigation';

  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keySelectedFarm = 'selected_farm';

  // Sensor Thresholds
  static const double optimalSoilMoistureMin = 50.0;
  static const double optimalSoilMoistureMax = 70.0;
  static const double criticalSoilMoistureMin = 30.0;

  static const double optimalTempMin = 18.0;
  static const double optimalTempMax = 28.0;

  static const double optimalHumidityMin = 50.0;
  static const double optimalHumidityMax = 70.0;

  static const double optimalPhMin = 5.5;
  static const double optimalPhMax = 6.5;

  static const double optimalEcMin = 1.0;
  static const double optimalEcMax = 2.5;

  // Refresh Intervals
  static const Duration sensorRefreshInterval = Duration(seconds: 30);
  static const Duration alertRefreshInterval = Duration(minutes: 5);
}
