class UserProfile {
  final String name;
  final String district;
  final String occupation;
  final String language;
  final String tribe;
  final List<String> interests;
  final DateTime createdAt;

  UserProfile({
    required this.name,
    required this.district,
    required this.occupation,
    required this.language,
    required this.tribe,
    required this.interests,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] ?? '',
        district: json['district'] ?? '',
        occupation: json['occupation'] ?? '',
        language: json['language'] ?? 'eng',
        tribe: json['tribe'] ?? '',
        interests: List<String>.from(json['interests'] ?? []),
        createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'district': district,
        'occupation': occupation,
        'language': language,
        'tribe': tribe,
        'interests': interests,
        'createdAt': createdAt.toIso8601String(),
      };

  UserProfile copyWith({
    String? name,
    String? district,
    String? occupation,
    String? language,
    String? tribe,
    List<String>? interests,
  }) =>
      UserProfile(
        name: name ?? this.name,
        district: district ?? this.district,
        occupation: occupation ?? this.occupation,
        language: language ?? this.language,
        tribe: tribe ?? this.tribe,
        interests: interests ?? this.interests,
        createdAt: createdAt,
      );
}
