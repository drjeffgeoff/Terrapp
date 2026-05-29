import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../models/crop.dart';
import '../utils/date_formatter.dart';

class CropManagementScreen extends StatefulWidget {
  const CropManagementScreen({Key? key}) : super(key: key);

  @override
  State<CropManagementScreen> createState() => _CropManagementScreenState();
}

class _CropManagementScreenState extends State<CropManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Crop Management',
        showBackButton: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.eco), text: 'Active Crops'),
            Tab(icon: Icon(Icons.history), text: 'History'),
            Tab(icon: Icon(Icons.add_circle), text: 'Planning'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildActiveCrops(), _buildHistory(), _buildPlanning()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new crop
        },
        backgroundColor: AppTheme.primaryOrange,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveCrops() {
    final crops = _getMockActiveCrops();
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: crops.map((crop) => _buildCropCard(crop)).toList(),
    );
  }

  Widget _buildCropCard(Crop crop) {
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
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: crop.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.eco, size: 30, color: crop.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(crop.name, style: AppTheme.subheadingStyle),
                      Text(
                        'Variety: ${crop.variety}',
                        style: AppTheme.captionStyle,
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
                    color: _getStatusColor(crop.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    crop.status,
                    style: TextStyle(
                      color: _getStatusColor(crop.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildInfoRow(
              Icons.calendar_today,
              'Planted: ${DateFormatter.formatDate(crop.plantedDate)}',
            ),
            _buildInfoRow(
              Icons.event,
              'Harvest: ${DateFormatter.formatDate(crop.expectedHarvestDate)}',
            ),
            _buildInfoRow(Icons.crop, 'Area: ${crop.area}'),
            const SizedBox(height: 8),
            const Text(
              'Growth Progress',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: crop.progress,
              backgroundColor: AppTheme.disabledColor,
              color: AppTheme.primaryOrange,
            ),
            const SizedBox(height: 8),
            Text(
              '${(crop.progress * 100).toInt()}% complete',
              style: AppTheme.captionStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 8),
          Text(text, style: AppTheme.bodyStyle),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    final history = _getMockHistory();
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: history.map((item) => _buildHistoryItem(item)).toList(),
    );
  }

  Widget _buildHistoryItem(Map<String, String> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.history, color: AppTheme.primaryOrange),
        title: Text('${item['crop']} - ${item['season']}'),
        subtitle: Text(
          'Yield: ${item['yield']} | Harvested: ${item['harvested']}',
        ),
        trailing: Text(
          item['profit']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.successColor,
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildPlanning() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Planting Season',
                  style: AppTheme.subheadingStyle,
                ),
                const SizedBox(height: 12),
                _buildPlanningItem(
                  'June 2025',
                  'Kharif Season',
                  'Rice, Cotton, Sugarcane',
                ),
                _buildPlanningItem(
                  'October 2025',
                  'Rabi Season',
                  'Wheat, Barley, Mustard',
                ),
                _buildPlanningItem(
                  'February 2026',
                  'Summer Season',
                  'Melons, Cucumber',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.note_add),
          label: const Text('Create Planting Plan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryOrange,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanningItem(String time, String season, String crops) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(season, style: const TextStyle(color: AppTheme.primaryOrange)),
          Text(crops, style: AppTheme.captionStyle),
          const Divider(),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
      case 'good':
        return AppTheme.successColor;
      case 'needs attention':
        return AppTheme.errorColor;
      default:
        return AppTheme.warningColor;
    }
  }

  List<Crop> _getMockActiveCrops() {
    return [
      Crop(
        id: '1',
        name: 'Wheat',
        variety: 'HD-2967',
        plantedDate: DateTime(2024, 11, 15),
        expectedHarvestDate: DateTime(2025, 4, 10),
        area: '5 acres',
        progress: 0.65,
        status: 'Healthy',
        color: AppTheme.successColor,
      ),
      Crop(
        id: '2',
        name: 'Rice',
        variety: 'Basmati',
        plantedDate: DateTime(2024, 12, 1),
        expectedHarvestDate: DateTime(2025, 5, 15),
        area: '3 acres',
        progress: 0.5,
        status: 'Good',
        color: AppTheme.primaryGreen,
      ),
    ];
  }

  List<Map<String, String>> _getMockHistory() {
    return [
      {
        'crop': 'Wheat',
        'season': 'Rabi 2024',
        'yield': '4.5 tons/acre',
        'harvested': 'Apr 05, 2024',
        'profit': '₹75,000',
      },
      {
        'crop': 'Rice',
        'season': 'Kharif 2024',
        'yield': '3.8 tons/acre',
        'harvested': 'Oct 20, 2024',
        'profit': '₹92,000',
      },
    ];
  }
}
