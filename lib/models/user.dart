class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String roles;
  final String password;
  final String? status;
  final String? firebaseToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
    required this.password,
    this.status,
    this.firebaseToken,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      roles: json['roles'],
      password: json['password'],
      status: json['status'], // Can be null
      firebaseToken: json['firebaseToken'], // Can be null
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'roles': roles,
      'password': password,
      'status': status,
      'firebaseToken': firebaseToken,
    };
  }
}
