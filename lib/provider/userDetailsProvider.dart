import 'package:flutter/material.dart';

class UserDetailsProvider with ChangeNotifier {
  static String userName = '';
  static String userEmail = '';
  static int userId = 0;
  static String userRole = '';
  static String userMobile = '';
  static String userToken = '';
  static String userStatus = '';
  static String firebaseToken = '';
  void updateName(String name) {
    userName = name;
    notifyListeners();
  }

  void updateFirebaseToken(String token) {
    firebaseToken = token;
    notifyListeners();
  }

  void updateStatus(String status) {
    userStatus = status;
    notifyListeners();
  }

  void updateEmail(String email) {
    userEmail = email;
    notifyListeners();
  }

  void updateId(int id) {
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

  String getStatus() {
    return userStatus;
  }

  String getMobile() {
    return userMobile;
  }

  int getId() {
    return userId;
  }

  String getRole() {
    return userRole;
  }

  String getFirebaseToken() {
    return firebaseToken;
  }

  void updateToken(String token) {
    userToken = token;
    notifyListeners();
  }

  String getToken() {
    return userToken;
  }
}
