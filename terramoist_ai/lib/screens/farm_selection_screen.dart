import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/farm_provider.dart';
import '../models/farm.dart';
import '../config/app_theme.dart';
import '../config/routes.dart';
import '../widgets/loading_indicator.dart';

class FarmSelectionScreen extends StatelessWidget {
  const FarmSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Farm',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<FarmProvider>(
        builder: (context, farmProvider, child) {
          if (farmProvider.isLoading) {
            return const LoadingIndicator();
          }

          if (farmProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(farmProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => farmProvider.loadFarms(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (farmProvider.farms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.agriculture, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No farms found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add farm logic
                    },
                    child: const Text('Add New Farm'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose a farm to continue',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: farmProvider.farms.length,
                    itemBuilder: (context, index) {
                      final farm = farmProvider.farms[index];
                      final isSelected =
                          farmProvider.selectedFarm?.id == farm.id;
                      return _buildFarmCard(context, farm, isSelected, () {
                        farmProvider.selectFarm(farm);
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.dashboard,
                        );
                      });
                    },
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Add new farm logic
                  },
                  icon: const Icon(Icons.add, color: AppTheme.primaryGreen),
                  label: const Text(
                    'Add New Farm',
                    style: TextStyle(color: AppTheme.primaryGreen),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFarmCard(
    BuildContext context,
    Farm farm,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: AppTheme.primaryGreen, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppTheme.lightGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.agriculture, color: farm.statusColor, size: 32),
        ),
        title: Text(
          farm.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(farm.type),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: farm.statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                farm.statusText,
                style: TextStyle(
                  color: farm.statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppTheme.primaryGreen)
            : null,
        onTap: onTap,
      ),
    );
  }
}
