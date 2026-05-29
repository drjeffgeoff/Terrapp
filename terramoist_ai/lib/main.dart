import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_theme.dart';
import 'config/routes.dart';
import 'providers/farm_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/alert_provider.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await NotificationService.initialize();
  await StorageService.init();

  // Get initial route based on login status
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final initialRoute = isLoggedIn ? Routes.dashboard : Routes.splash;

  runApp(TerraMoistApp(initialRoute: initialRoute));
}

class TerraMoistApp extends StatelessWidget {
  final String initialRoute;

  const TerraMoistApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FarmProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
      ],
      child: MaterialApp(
        title: 'TerraMoist AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: initialRoute,
        routes: Routes.routes,
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
