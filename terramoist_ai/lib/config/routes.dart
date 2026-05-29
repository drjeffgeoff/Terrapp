import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/farm_selection_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/ai_insights_screen.dart';
import '../screens/irrigation_control_screen.dart';
import '../screens/sensor_monitoring_screen.dart';
import '../screens/crop_management_screen.dart';
import '../screens/alerts_screen.dart';
import '../screens/reports_history_screen.dart';
import '../screens/settings_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String farmSelection = '/farm-selection';
  static const String dashboard = '/dashboard';
  static const String aiInsights = '/ai-insights';
  static const String irrigationControl = '/irrigation-control';
  static const String sensorMonitoring = '/sensor-monitoring';
  static const String cropManagement = '/crop-management';
  static const String alerts = '/alerts';
  static const String reports = '/reports';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    farmSelection: (context) => const FarmSelectionScreen(),
    dashboard: (context) => const DashboardScreen(),
    aiInsights: (context) => const AIInsightsScreen(),
    irrigationControl: (context) => const IrrigationControlScreen(),
    sensorMonitoring: (context) => const SensorMonitoringScreen(),
    cropManagement: (context) => const CropManagementScreen(),
    alerts: (context) => const AlertsScreen(),
    reports: (context) => const ReportsHistoryScreen(),
    settings: (context) => const SettingsScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (routes.containsKey(settings.name)) {
      return MaterialPageRoute(
        builder: (context) => routes[settings.name]!(context),
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder: (context) =>
          const Scaffold(body: Center(child: Text('Route not found'))),
    );
  }
}
