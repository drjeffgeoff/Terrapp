import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farm_provider.dart';
import '../providers/sensor_provider.dart';
import '../providers/alert_provider.dart';
import '../widgets/metric_card.dart';
import '../widgets/loading_indicator.dart';
import '../config/app_theme.dart';
import '../config/routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final farmProvider = context.read<FarmProvider>();
    final sensorProvider = context.read<SensorProvider>();

    if (farmProvider.selectedFarm != null) {
      await sensorProvider.loadCurrentData(farmProvider.selectedFarm!.id);
      await sensorProvider.loadHistoricalData(farmProvider.selectedFarm!.id);
      await context.read<AlertProvider>().loadAlerts(
        farmId: farmProvider.selectedFarm!.id,
      );
    }
  }

  Future<void> _refreshData() async {
    final farmProvider = context.read<FarmProvider>();
    if (farmProvider.selectedFarm != null) {
      await context.read<SensorProvider>().refreshData(
        farmProvider.selectedFarm!.id,
      );
      await context.read<AlertProvider>().refreshAlerts(
        farmId: farmProvider.selectedFarm!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<FarmProvider>(
          builder: (context, farmProvider, _) {
            return Text(
              farmProvider.selectedFarm?.name ?? 'Dashboard',
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Badge(
              label: Consumer<AlertProvider>(
                builder: (context, alertProvider, _) {
                  if (alertProvider.unreadCount == 0) return const SizedBox();
                  return Text('${alertProvider.unreadCount}');
                },
              ),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => Navigator.pushNamed(context, Routes.alerts),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Consumer<SensorProvider>(
          builder: (context, sensorProvider, _) {
            if (sensorProvider.isLoading) {
              return const LoadingIndicator();
            }

            if (sensorProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(sensorProvider.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAIRecommendationCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Live Overview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildMetricsGrid(sensorProvider),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAIRecommendationCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.aiInsights),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.lightGreen, AppTheme.lightGreen.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'AI Recommendation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'All conditions are optimal. Next irrigation recommended in 2h 30m.',
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.auto_awesome, size: 40, color: AppTheme.primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(SensorProvider sensorProvider) {
    final currentData = sensorProvider.currentData;
    if (currentData == null) return const SizedBox();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        MetricCard(
          title: 'Soil Moisture',
          value: '${currentData.soilMoisture.toStringAsFixed(1)}%',
          status: currentData.soilMoistureStatus,
          icon: Icons.water_drop_outlined,
          color: currentData.soilMoistureColor,
        ),
        MetricCard(
          title: 'Temperature',
          value: '${currentData.temperature.toStringAsFixed(1)}°C',
          status: currentData.isTemperatureOptimal ? 'Optimal' : 'Adjust',
          icon: Icons.thermostat,
          color: currentData.isTemperatureOptimal
              ? Colors.green
              : Colors.orange,
        ),
        MetricCard(
          title: 'Humidity',
          value: '${currentData.humidity.toStringAsFixed(1)}%',
          status: currentData.isHumidityOptimal ? 'Optimal' : 'Adjust',
          icon: Icons.cloud_queue,
          color: currentData.isHumidityOptimal ? Colors.green : Colors.orange,
        ),
        MetricCard(
          title: 'pH Level',
          value: currentData.pHLevel.toStringAsFixed(1),
          status: currentData.ispHOptimal ? 'Optimal' : 'Adjust',
          icon: Icons.science_outlined,
          color: currentData.ispHOptimal ? Colors.green : Colors.orange,
        ),
        MetricCard(
          title: 'Water Tank',
          value: '${currentData.waterTankLevel.toStringAsFixed(0)}%',
          status: currentData.isWaterLevelOk ? 'Good' : 'Low',
          icon: Icons.opacity,
          color: currentData.isWaterLevelOk ? Colors.green : Colors.red,
        ),
        MetricCard(
          title: 'EC Level',
          value: '${currentData.ecLevel.toStringAsFixed(1)} mS/cm',
          status: currentData.isEcOptimal ? 'Good' : 'Adjust',
          icon: Icons.electric_bolt,
          color: currentData.isEcOptimal ? Colors.green : Colors.orange,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () =>
                Navigator.pushNamed(context, Routes.irrigationControl),
            icon: const Icon(Icons.water_drop),
            label: const Text('Start Irrigation'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Irrigation stopped')),
              );
            },
            icon: const Icon(Icons.stop),
            label: const Text('Stop Irrigation'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.errorRed),
              foregroundColor: AppTheme.errorRed,
            ),
          ),
        ),
      ],
    );
  }
}
