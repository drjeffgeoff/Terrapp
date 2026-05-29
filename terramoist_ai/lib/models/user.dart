enum UserRole { farmer, technician, admin }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phoneNumber;
  final String? profileImageUrl;
  final List<String> farmIds;
  final DateTime createdAt;
  final bool isEmailVerified;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
    this.farmIds = const [],
    required this.createdAt,
    this.isEmailVerified = false,
  });

  String get roleText {
    switch (role) {
      case UserRole.farmer:
        return 'Farmer';
      case UserRole.technician:
        return 'Technician';
      case UserRole.admin:
        return 'Admin';
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role.index,
    'phoneNumber': phoneNumber,
    'profileImageUrl': profileImageUrl,
    'farmIds': farmIds,
    'createdAt': createdAt.toIso8601String(),
    'isEmailVerified': isEmailVerified,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    email: json['email'],
    name: json['name'],
    role: UserRole.values[json['role']],
    phoneNumber: json['phoneNumber'],
    profileImageUrl: json['profileImageUrl'],
    farmIds: List<String>.from(json['farmIds'] ?? []),
    createdAt: DateTime.parse(json['createdAt']),
    isEmailVerified: json['isEmailVerified'] ?? false,
  );
}
