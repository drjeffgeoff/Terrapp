import 'package:flutter/material.dart';
import '../config/app_theme.dart';

class IrrigationControlScreen extends StatefulWidget {
  const IrrigationControlScreen({super.key});

  @override
  State<IrrigationControlScreen> createState() =>
      _IrrigationControlScreenState();
}

class _IrrigationControlScreenState extends State<IrrigationControlScreen> {
  String _selectedZone = 'Bed 1';
  bool _manualControl = true;
  double _waterFlow = 50.0;
  String _duration = '30 min';
  bool _scheduleIrrigation = true;
  TimeOfDay _startTime = const TimeOfDay(hour: 6, minute: 0);
  bool _isSaving = false;

  final List<String> _zones = ['Bed 1', 'Bed 2', 'Tower A', 'Tower B'];
  final List<String> _durations = [
    '15 min',
    '30 min',
    '45 min',
    '60 min',
    '90 min',
    '120 min',
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _saveSchedule() async {
    setState(() => _isSaving = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _manualControl
                ? 'Manual irrigation started'
                : 'Schedule saved successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation Control'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/reports'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildZoneSelector(),
            const SizedBox(height: 24),
            _buildControlModeToggle(),
            if (_manualControl) ...[
              const SizedBox(height: 20),
              _buildWaterFlowSlider(),
              const SizedBox(height: 20),
              _buildDurationSelector(),
            ] else ...[
              const SizedBox(height: 16),
              _buildScheduleTimePicker(),
            ],
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Zone',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _zones.map((zone) {
            final isSelected = _selectedZone == zone;
            return FilterChip(
              label: Text(zone),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedZone = zone;
                });
              },
              selectedColor: AppTheme.primaryGreen,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildControlModeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Control Mode',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: true,
              label: Text('Manual'),
              icon: Icon(Icons.touch_app),
            ),
            ButtonSegment(
              value: false,
              label: Text('Auto'),
              icon: Icon(Icons.schedule),
            ),
          ],
          selected: {_manualControl},
          onSelectionChanged: (Set<bool> selection) {
            setState(() {
              _manualControl = selection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildWaterFlowSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Water Flow', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _waterFlow,
                min: 0,
                max: 100,
                divisions: 20,
                activeColor: AppTheme.primaryGreen,
                label: '${_waterFlow.toInt()}%',
                onChanged: (value) {
                  setState(() {
                    _waterFlow = value;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_waterFlow.toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Irrigation Duration',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _duration,
              isExpanded: true,
              items: _durations.map((duration) {
                return DropdownMenuItem(value: duration, child: Text(duration));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _duration = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleTimePicker() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.access_time, color: AppTheme.primaryGreen),
        title: const Text('Start Time'),
        subtitle: Text(_startTime.format(context)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _selectTime(context),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _saveSchedule,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
      ),
      child: _isSaving
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Apply Settings', style: TextStyle(fontSize: 16)),
    );
  }
}
