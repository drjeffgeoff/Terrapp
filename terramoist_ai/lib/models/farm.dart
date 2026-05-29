enum FarmStatus { healthy, warning, critical }

class Farm {
  final String id;
  final String name;
  final String type;
  final FarmStatus status;
  final double area;
  final String location;
  final DateTime createdAt;
  final Map<String, dynamic> settings;
  final String? imageUrl;

  Farm({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.area,
    required this.location,
    required this.createdAt,
    this.settings = const {},
    this.imageUrl,
  });

  Color get statusColor {
    switch (status) {
      case FarmStatus.healthy:
        return const Color(0xFF2E7D32);
      case FarmStatus.warning:
        return const Color(0xFFEF6C00);
      case FarmStatus.critical:
        return const Color(0xFFC62828);
    }
  }

  String get statusText {
    switch (status) {
      case FarmStatus.healthy:
        return 'Healthy';
      case FarmStatus.warning:
        return 'Warning';
      case FarmStatus.critical:
        return 'Critical';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'status': status.index,
    'area': area,
    'location': location,
    'createdAt': createdAt.toIso8601String(),
    'settings': settings,
    'imageUrl': imageUrl,
  };

  factory Farm.fromJson(Map<String, dynamic> json) => Farm(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    status: FarmStatus.values[json['status']],
    area: json['area'],
    location: json['location'],
    createdAt: DateTime.parse(json['createdAt']),
    settings: json['settings'] ?? {},
    imageUrl: json['imageUrl'],
  );
}
