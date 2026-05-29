class SensorData {
  final DateTime timestamp;
  final double soilMoisture;
  final double temperature;
  final double humidity;
  final double pHLevel;
  final double ecLevel;
  final double waterTankLevel;
  final double? lightIntensity;
  final double? co2Level;

  SensorData({
    required this.timestamp,
    required this.soilMoisture,
    required this.temperature,
    required this.humidity,
    required this.pHLevel,
    required this.ecLevel,
    required this.waterTankLevel,
    this.lightIntensity,
    this.co2Level,
  });

  bool get isSoilMoistureOptimal => soilMoisture >= 50 && soilMoisture <= 70;
  bool get isTemperatureOptimal => temperature >= 18 && temperature <= 28;
  bool get isHumidityOptimal => humidity >= 50 && humidity <= 70;
  bool get ispHOptimal => pHLevel >= 5.5 && pHLevel <= 6.5;
  bool get isEcOptimal => ecLevel >= 1.0 && ecLevel <= 2.5;
  bool get isWaterLevelOk => waterTankLevel > 30;

  String get soilMoistureStatus {
    if (soilMoisture < 30) return 'Critical Low';
    if (soilMoisture < 50) return 'Low';
    if (soilMoisture <= 70) return 'Optimal';
    if (soilMoisture <= 85) return 'High';
    return 'Critical High';
  }

  Color get soilMoistureColor {
    if (soilMoisture < 30) return Colors.red;
    if (soilMoisture < 50) return Colors.orange;
    if (soilMoisture <= 70) return Colors.green;
    if (soilMoisture <= 85) return Colors.orange;
    return Colors.red;
  }

  double get overallHealthScore {
    double score = 0;
    if (isSoilMoistureOptimal) score += 25;
    if (isTemperatureOptimal) score += 25;
    if (isHumidityOptimal) score += 20;
    if (ispHOptimal) score += 15;
    if (isEcOptimal) score += 15;
    return score;
  }

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'soilMoisture': soilMoisture,
    'temperature': temperature,
    'humidity': humidity,
    'pHLevel': pHLevel,
    'ecLevel': ecLevel,
    'waterTankLevel': waterTankLevel,
    'lightIntensity': lightIntensity,
    'co2Level': co2Level,
  };

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
    timestamp: DateTime.parse(json['timestamp']),
    soilMoisture: json['soilMoisture'],
    temperature: json['temperature'],
    humidity: json['humidity'],
    pHLevel: json['pHLevel'],
    ecLevel: json['ecLevel'],
    waterTankLevel: json['waterTankLevel'],
    lightIntensity: json['lightIntensity'],
    co2Level: json['co2Level'],
  );
}
