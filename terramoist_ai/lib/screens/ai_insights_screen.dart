import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/loading_indicator.dart';

class AIInsightsScreen extends StatelessWidget {
  const AIInsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'AI Insights', showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildInsightCard(
            title: 'Crop Health Prediction',
            insight:
                'Your wheat crops show signs of nitrogen deficiency in the northern section. Recommended action: Apply nitrogen fertilizer within 3 days.',
            accuracy: '92% confidence',
            icon: Icons.agriculture,
            color: AppTheme.primaryOrange,
          ),
          _buildInsightCard(
            title: 'Weather Forecast Impact',
            insight:
                'Heavy rainfall predicted in 48 hours. Delay irrigation to prevent waterlogging and reduce fungal disease risk.',
            accuracy: '87% confidence',
            icon: Icons.cloud_queue,
            color: AppTheme.primaryBlue,
          ),
          _buildInsightCard(
            title: 'Pest Risk Alert',
            insight:
                'High probability of aphid infestation in the next 5-7 days based on temperature and humidity patterns.',
            accuracy: '89% confidence',
            icon: Icons.bug_report,
            color: AppTheme.errorColor,
          ),
          _buildInsightCard(
            title: 'Yield Prediction',
            insight:
                'Expected yield: 4.2 tons/acre, 15% above regional average. Optimal harvest window: June 15-20.',
            accuracy: '94% confidence',
            icon: Icons.trending_up,
            color: AppTheme.successColor,
          ),
          _buildInsightCard(
            title: 'Irrigation Optimization',
            insight:
                'Smart irrigation schedule adjusted: Reduce watering by 30% for the next week due to soil moisture levels and forecast.',
            accuracy: '96% confidence',
            icon: Icons.water_drop,
            color: AppTheme.primaryTeal,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String insight,
    required String accuracy,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTheme.subheadingStyle),
                      Text(accuracy, style: AppTheme.captionStyle),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(insight, style: AppTheme.bodyStyle),
          ],
        ),
      ),
    );
  }
}
