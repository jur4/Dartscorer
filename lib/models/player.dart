class Player {
  final int id;
  final String name;
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Player({
    required this.id,
    required this.name,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  Player copyWith({
    int? id,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'Player{id: $id, name: $name, email: $email, isActive: $isActive}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Player &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          isActive == other.isActive;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ email.hashCode ^ isActive.hashCode;
}