import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String roles;
  final String password;
  final String status;
  final String firebaseToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
    required this.password,
    required this.status,
    required this.firebaseToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      roles: json['roles'],
      password: json['password'],
      status: json['status'],
      firebaseToken: json['firebaseToken'],
    );
  }

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

  static List<User> fromJsonList(String jsonString) {
    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.map((item) => User.fromJson(item)).toList();
  }
}