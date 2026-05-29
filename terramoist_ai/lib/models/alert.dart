enum AlertType {
  lowMoisture,
  pumpMalfunction,
  highTemperature,
  sensorOffline,
  lowWater,
  highPH,
  lowNutrient,
  pestDetected,
  diseaseRisk,
}

class Alert {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final AlertType type;
  final bool isRead;
  final String? farmId;
  final String? zoneId;
  final String? sensorId;

  Alert({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
    this.farmId,
    this.zoneId,
    this.sensorId,
  });

  Color get color {
    switch (type) {
      case AlertType.lowMoisture:
        return const Color(0xFFFF9800);
      case AlertType.pumpMalfunction:
        return const Color(0xFFF44336);
      case AlertType.highTemperature:
        return const Color(0xFFFFC107);
      case AlertType.sensorOffline:
        return const Color(0xFF9E9E9E);
      case AlertType.lowWater:
        return const Color(0xFF2196F3);
      case AlertType.highPH:
        return const Color(0xFFE91E63);
      case AlertType.lowNutrient:
        return const Color(0xFF4CAF50);
      case AlertType.pestDetected:
        return const Color(0xFF795548);
      case AlertType.diseaseRisk:
        return const Color(0xFF9C27B0);
    }
  }

  IconData get icon {
    switch (type) {
      case AlertType.lowMoisture:
        return Icons.water_drop_outlined;
      case AlertType.pumpMalfunction:
        return Icons.build_outlined;
      case AlertType.highTemperature:
        return Icons.thermostat;
      case AlertType.sensorOffline:
        return Icons.sensors_off_outlined;
      case AlertType.lowWater:
        return Icons.opacity;
      case AlertType.highPH:
        return Icons.science_outlined;
      case AlertType.lowNutrient:
        return Icons.grass;
      case AlertType.pestDetected:
        return Icons.bug_report_outlined;
      case AlertType.diseaseRisk:
        return Icons.health_and_safety_outlined;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Alert copyWith({bool? isRead}) {
    return Alert(
      id: id,
      title: title,
      message: message,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
      farmId: farmId,
      zoneId: zoneId,
      sensorId: sensorId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'time': time.toIso8601String(),
    'type': type.index,
    'isRead': isRead,
    'farmId': farmId,
    'zoneId': zoneId,
    'sensorId': sensorId,
  };

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    id: json['id'],
    title: json['title'],
    message: json['message'],
    time: DateTime.parse(json['time']),
    type: AlertType.values[json['type']],
    isRead: json['isRead'] ?? false,
    farmId: json['farmId'],
    zoneId: json['zoneId'],
    sensorId: json['sensorId'],
  );
}
