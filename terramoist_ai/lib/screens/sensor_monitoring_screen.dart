import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/metric_card.dart';
import '../widgets/loading_indicator.dart';
import '../models/sensor_data.dart';
import '../providers/sensor_provider.dart';

class SensorMonitoringScreen extends StatefulWidget {
  const SensorMonitoringScreen({Key? key}) : super(key: key);

  @override
  State<SensorMonitoringScreen> createState() => _SensorMonitoringScreenState();
}

class _SensorMonitoringScreenState extends State<SensorMonitoringScreen> {
  bool _isLoading = false;
  List<SensorData> _sensorData = [];

  @override
  void initState() {
    super.initState();
    _loadSensorData();
  }

  Future<void> _loadSensorData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _sensorData = _getMockSensorData();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Sensor Monitoring', showBackButton: true),
      body: RefreshIndicator(
        onRefresh: _loadSensorData,
        child: _isLoading
            ? const LoadingIndicator()
            : ListView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                children: [
                  ..._sensorData.map((data) => _buildSensorCard(data)),
                  const SizedBox(height: 16),
                  _buildSensorMap(),
                ],
              ),
      ),
    );
  }

  Widget _buildSensorCard(SensorData data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: data.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(data.icon, color: data.color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.title, style: AppTheme.subheadingStyle),
                      Text(
                        'Current: ${data.value} ${data.unit}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: data.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(data.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: _getStatusColor(data.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value:
                  (data.currentValue - data.minValue) /
                  (data.maxValue - data.minValue),
              backgroundColor: AppTheme.disabledColor,
              color: data.color,
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data.minValue}${data.unit}',
                  style: AppTheme.captionStyle,
                ),
                Text(
                  'Optimal: ${data.optimalRange}',
                  style: AppTheme.captionStyle,
                ),
                Text(
                  '${data.maxValue}${data.unit}',
                  style: AppTheme.captionStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorMap() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          color: AppTheme.backgroundColor,
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map, size: 48, color: AppTheme.textSecondary),
              SizedBox(height: 8),
              Text(
                'Sensor Map View',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              Text(
                'Interactive map showing sensor locations',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'optimal':
      case 'ideal':
      case 'good':
        return AppTheme.successColor;
      case 'normal':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.warningColor;
    }
  }

  List<SensorData> _getMockSensorData() {
    return [
      SensorData(
        id: '1',
        title: 'Soil Moisture',
        value: '68',
        unit: '%',
        status: 'Optimal',
        icon: Icons.grass,
        color: AppTheme.successColor,
        minValue: 0,
        maxValue: 100,
        currentValue: 68,
        optimalRange: '60-80%',
      ),
      SensorData(
        id: '2',
        title: 'Temperature',
        value: '24',
        unit: '°C',
        status: 'Normal',
        icon: Icons.thermostat,
        color: AppTheme.warningColor,
        minValue: -10,
        maxValue: 50,
        currentValue: 24,
        optimalRange: '20-28°C',
      ),
      // Add more sensor data
    ];
  }
}
