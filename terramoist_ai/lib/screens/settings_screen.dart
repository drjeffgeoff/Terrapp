import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../config/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  bool _autoSync = true;
  String _units = 'Metric';
  String _language = 'English';
  String _dataUsage = 'Wi-Fi Only';

  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Settings', showBackButton: true),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Preferences'),
          _buildSwitchTile(
            title: 'Notifications',
            subtitle: 'Receive alerts and updates',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _savePreference('notifications', value);
            },
            icon: Icons.notifications,
          ),
          _buildSwitchTile(
            title: 'Dark Mode',
            subtitle: 'Use dark theme',
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
              _savePreference('darkMode', value);
            },
            icon: Icons.dark_mode,
          ),
          _buildSwitchTile(
            title: 'Auto Sync',
            subtitle: 'Automatically sync data with cloud',
            value: _autoSync,
            onChanged: (value) {
              setState(() {
                _autoSync = value;
              });
              _savePreference('autoSync', value);
            },
            icon: Icons.sync,
          ),
          const Divider(),
          _buildSectionHeader('Units & Display'),
          _buildDropdownTile(
            title: 'Units',
            subtitle: 'Measurement system',
            value: _units,
            items: ['Metric', 'Imperial'],
            onChanged: (value) {
              setState(() {
                _units = value!;
              });
              _savePreference('units', _units);
            },
            icon: Icons.straighten,
          ),
          _buildDropdownTile(
            title: 'Language',
            subtitle: 'App language',
            value: _language,
            items: ['English', 'Hindi', 'Spanish'],
            onChanged: (value) {
              setState(() {
                _language = value!;
              });
              _savePreference('language', _language);
            },
            icon: Icons.language,
          ),
          const Divider(),
          _buildSectionHeader('Data & Storage'),
          _buildDropdownTile(
            title: 'Data Usage',
            subtitle: 'When to use mobile data',
            value: _dataUsage,
            items: ['Wi-Fi Only', 'Wi-Fi & Mobile', 'Always'],
            onChanged: (value) {
              setState(() {
                _dataUsage = value!;
              });
              _savePreference('dataUsage', _dataUsage);
            },
            icon: Icons.wifi,
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: AppTheme.errorColor),
            title: const Text('Clear Cache'),
            subtitle: const Text('Clear temporary data'),
            trailing: const Text(
              '128 MB',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            onTap: _showClearCacheDialog,
          ),
          const Divider(),
          _buildSectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Information'),
            subtitle: const Text('View and edit profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _navigateToProfile,
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy & Security'),
            subtitle: const Text('Manage privacy settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _navigateToPrivacy,
          ),
          const Divider(),
          _buildSectionHeader('Support'),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help Center'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _openHelpCenter,
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Send Feedback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _sendFeedback,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Version 2.0.0'),
            trailing: const Icon(Icons.chevron_right),
            onTap: _showAboutDialog,
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: _showSignOutDialog,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  void _savePreference(String key, dynamic value) async {
    await _storageService.saveSetting(key, value);
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Cache'),
          content: const Text(
            'This will clear all temporary data. Your account information and reports will not be affected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _storageService.clearCache();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _authService.signOut();
                Navigator.pop(context);
                // Navigate to login screen
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: AppTheme.errorColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: 'Smart Farm Assistant',
          applicationVersion: 'Version 2.0.0',
          applicationIcon: const Icon(Icons.agriculture, size: 48),
          children: const [
            SizedBox(height: 16),
            Text(
              'Smart Farm Assistant helps farmers monitor crops, control irrigation, and get AI-powered insights for better farming decisions.',
            ),
          ],
        );
      },
    );
  }

  void _navigateToProfile() {
    // Navigate to profile screen
  }

  void _navigateToPrivacy() {
    // Navigate to privacy screen
  }

  void _openHelpCenter() {
    // Open help center
  }

  void _sendFeedback() {
    // Send feedback
  }
}
