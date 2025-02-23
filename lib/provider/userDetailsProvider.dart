import 'package:flutter/material.dart';

class UserDetailsProvider with ChangeNotifier {
  static String userName = '';
  static String userEmail = '';
  static String userId = '';
  static String userRole = '';
  static String userMobile = '';
  static String userToken = '';
  void updateName(String name) {
    userName = name;
    notifyListeners();
  }

  void updateEmail(String email) {
    userEmail = email;
    notifyListeners();
  }

  void updateId(String id) {
    userId = id;
    notifyListeners();
  }

  void updateMobile(String mobile) {
    userMobile = mobile;
    notifyListeners();
  }

  void updateRole(String role) {
    userRole = role;
    notifyListeners();
  }

  String getName() {
    return userName;
  }

  String getEmail() {
    return userEmail;
  }

  String getMobile() {
    return userMobile;
  }

  String getId() {
    return userId;
  }

  String getRole() {
    return userRole;
  }

  void updateToken(String token) {
    userToken = token;
    notifyListeners();
  }

  String getToken() {
    return userToken;
  }
}
