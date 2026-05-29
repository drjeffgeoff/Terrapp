import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';

class ReportsHistoryScreen extends StatefulWidget {
  const ReportsHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ReportsHistoryScreen> createState() => _ReportsHistoryScreenState();
}

class _ReportsHistoryScreenState extends State<ReportsHistoryScreen> {
  String _selectedFilter = 'All Reports';
  final List<String> _filters = [
    'All Reports',
    'Monthly',
    'Analytics',
    'Efficiency',
    'Weather',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reports & History',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadReport,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: _getFilteredReports().length,
              itemBuilder: (context, index) {
                return _buildReportCard(_getFilteredReports()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                backgroundColor: AppTheme.backgroundColor,
                selectedColor: AppTheme.primaryBlue,
                labelStyle: TextStyle(
                  color: _selectedFilter == filter
                      ? Colors.white
                      : AppTheme.textPrimary,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: () => _openReport(report),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: report['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(report['icon'], color: report['color'], size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(report['date'], style: AppTheme.captionStyle),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            report['type'],
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(report['size'], style: AppTheme.captionStyle),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredReports() {
    List<Map<String, dynamic>> allReports = _getMockReports();

    if (_selectedFilter == 'All Reports') {
      return allReports;
    }

    return allReports
        .where((report) => report['type'] == _selectedFilter)
        .toList();
  }

  List<Map<String, dynamic>> _getMockReports() {
    return [
      {
        'title': 'Monthly Summary - January 2025',
        'date': 'Generated: Feb 01, 2025',
        'type': 'Monthly',
        'size': '2.4 MB',
        'icon': Icons.assessment,
        'color': AppTheme.primaryBlue,
      },
      {
        'title': 'Crop Health Analysis',
        'date': 'Generated: Jan 25, 2025',
        'type': 'Analytics',
        'size': '1.8 MB',
        'icon': Icons.eco,
        'color': AppTheme.successColor,
      },
      // Add more reports
    ];
  }

  void _downloadReport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Download started...')));
  }

  void _openReport(Map<String, dynamic> report) {
    // Navigate to report viewer
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report['title']),
        content: const Text('Report viewer would open here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
