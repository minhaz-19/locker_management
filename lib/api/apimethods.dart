import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/models/all_buildings.dart';
import 'package:locker_management/provider/userDetailsProvider.dart';

final dio = Dio();

class ApiResponse {
  final String baseUrl = "http://10.29.175.162:8080";

  // Provide phone number and ruquest for otp
  Future<Response> signUp(
    name,
    email,
    phone,
    password,
    roles,
    status,
    firebaseToken,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/signup',
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "roles": roles,
          "status": status,
          "firebaseToken": firebaseToken,
        },
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        // Show error message
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  Future<Response> signIn(email, password) async {
    try {
      final response = await dio.post(
        '$baseUrl/signin',
        data: {"email": email, "password": password},
      );

      return response;
    } catch (e) {
      if (e is DioException) {
        // Show error message
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  Future<List<Buildings>> fetchBuildings() async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.get(
        '$baseUrl/buildings',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        // Ensure response is parsed as a list of Maps
        List<dynamic> data = response.data; // Directly access response data
        return data.map((item) => Buildings.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load buildings");
      }
    } catch (e) {
      if (e is DioException) {
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  Future<dynamic> addBuildings(
    String buildingName,
    String buildingLocation,
    int totalLocker,
  ) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/addBuilding',
        data: {
          "name": buildingName,
          "location": buildingLocation,
          "totalLocker": totalLocker,
          "id": 0,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print(
          'first here ' +
              response.data.toString() +
              'status code ' +
              response.statusCode.toString(),
        );
        throw Exception("Failed to load buildings");
      }
    } catch (e) {
      if (e is DioException) {
        print('first dio first ' + (e.response?.data).toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        print('first dio second ' + e.toString());
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }
}
