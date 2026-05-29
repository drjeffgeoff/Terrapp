enum CropStage { seedling, growing, flowering, harvesting }

enum CropHealth { excellent, good, fair, poor }

class Crop {
  final String id;
  final String name;
  final String variety;
  final String zone;
  final CropStage stage;
  final CropHealth health;
  final DateTime plantingDate;
  final DateTime expectedHarvestDate;
  final double area;
  final int plantCount;
  final List<String> images;
  final Map<String, dynamic> notes;

  Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.zone,
    required this.stage,
    required this.health,
    required this.plantingDate,
    required this.expectedHarvestDate,
    required this.area,
    required this.plantCount,
    this.images = const [],
    this.notes = const {},
  });

  String get stageText {
    switch (stage) {
      case CropStage.seedling:
        return 'Seedling';
      case CropStage.growing:
        return 'Growing';
      case CropStage.flowering:
        return 'Flowering';
      case CropStage.harvesting:
        return 'Harvesting';
    }
  }

  String get healthText {
    switch (health) {
      case CropHealth.excellent:
        return 'Excellent';
      case CropHealth.good:
        return 'Good';
      case CropHealth.fair:
        return 'Fair';
      case CropHealth.poor:
        return 'Poor';
    }
  }

  Color get healthColor {
    switch (health) {
      case CropHealth.excellent:
        return const Color(0xFF4CAF50);
      case CropHealth.good:
        return const Color(0xFF8BC34A);
      case CropHealth.fair:
        return const Color(0xFFFFC107);
      case CropHealth.poor:
        return const Color(0xFFF44336);
    }
  }

  int get daysToHarvest {
    return expectedHarvestDate.difference(DateTime.now()).inDays;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'variety': variety,
    'zone': zone,
    'stage': stage.index,
    'health': health.index,
    'plantingDate': plantingDate.toIso8601String(),
    'expectedHarvestDate': expectedHarvestDate.toIso8601String(),
    'area': area,
    'plantCount': plantCount,
    'images': images,
    'notes': notes,
  };

  factory Crop.fromJson(Map<String, dynamic> json) => Crop(
    id: json['id'],
    name: json['name'],
    variety: json['variety'],
    zone: json['zone'],
    stage: CropStage.values[json['stage']],
    health: CropHealth.values[json['health']],
    plantingDate: DateTime.parse(json['plantingDate']),
    expectedHarvestDate: DateTime.parse(json['expectedHarvestDate']),
    area: json['area'],
    plantCount: json['plantCount'],
    images: List<String>.from(json['images'] ?? []),
    notes: json['notes'] ?? {},
  );
}
