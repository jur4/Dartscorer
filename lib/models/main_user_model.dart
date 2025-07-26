class MainUserModel {
  final String id;
  final String name;
  final String email;

  MainUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory MainUserModel.fromJson(Map<String, dynamic> json) {
    return MainUserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}