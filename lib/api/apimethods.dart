import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'package:fluttertoast/fluttertoast.dart';

final dio = Dio();

class ApiResponse {
  final String baseUrl = "http://10.29.176.5:8080";

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



    Future<Response> signIn(
    email,
    password,
  ) async {
    try {
      final response = await dio.post(
        '$baseUrl/signin',
        data: {
          "email": email,
          "password": password,
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

  // // Check for the new token
  // Future<Response<dynamic>> newToken() async {
  //   final response = await dio.post("$baseUrl/api/v1/auth/token");
  //   providerToken().updateToken(response.data['data']['token']);
  //   return response;
  // }

  // Future<dynamic> getToken() async {
  //   final Directory appDocDir = await getApplicationDocumentsDirectory();
  //   final String appDocPath = appDocDir.path;
  //   final jar = PersistCookieJar(
  //     ignoreExpires: true,
  //     storage: FileStorage(appDocPath + "/.cookies/"),
  //   );
  //   var response = await jar.loadForRequest(
  //     Uri.parse("https://api.englishmojabd.com/api/v1/auth/token"),
  //   );

  //   // final String token = response..then((value) {
  //   //       return value.data['data']['token'];
  //   //     });;
  //   return response;
  // }
}
