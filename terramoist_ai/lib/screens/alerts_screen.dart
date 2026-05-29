import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../models/alert.dart';
import '../services/notification_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Alert> _alerts = [];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  void _loadAlerts() {
    _alerts = _getMockAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Alerts',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _alerts.length,
        itemBuilder: (context, index) {
          return _buildAlertCard(_alerts[index]);
        },
      ),
    );
  }

  Widget _buildAlertCard(Alert alert) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
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
                    color: alert.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(alert.icon, color: alert.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(alert.time, style: AppTheme.captionStyle),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getSeverityColor(alert.severity).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    alert.severity,
                    style: TextStyle(
                      color: _getSeverityColor(alert.severity),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(alert.message, style: AppTheme.bodyStyle),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _viewAlertDetails(alert),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _dismissAlert(alert),
                  child: const Text('Dismiss'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppTheme.errorColor;
      case 'high':
        return AppTheme.warningColor;
      case 'medium':
        return AppTheme.primaryOrange;
      case 'low':
        return AppTheme.textSecondary;
      case 'info':
        return AppTheme.primaryBlue;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var alert in _alerts) {
        alert.isRead = true;
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All alerts marked as read')));
  }

  void _viewAlertDetails(Alert alert) {
    // Navigate to alert details
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert.title),
        content: Text(alert.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _dismissAlert(Alert alert) {
    setState(() {
      _alerts.remove(alert);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${alert.title} dismissed')));
  }

  List<Alert> _getMockAlerts() {
    return [
      Alert(
        id: '1',
        title: '⚠️ High Temperature Alert',
        message:
            'Temperature in North Field has exceeded 38°C. Immediate action required to prevent crop stress.',
        time: '10 minutes ago',
        severity: 'Critical',
        icon: Icons.thermostat,
        color: AppTheme.errorColor,
        isRead: false,
      ),
      Alert(
        id: '2',
        title: '💧 Low Soil Moisture',
        message:
            'South Field soil moisture dropped below 30%. Irrigation recommended within 24 hours.',
        time: '1 hour ago',
        severity: 'High',
        icon: Icons.water_drop,
        color: AppTheme.warningColor,
        isRead: false,
      ),
      // Add more alerts
    ];
  }
}
