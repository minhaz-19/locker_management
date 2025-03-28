import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/models/allUsers.dart';
import 'package:locker_management/models/all_buildings.dart';
import 'package:locker_management/models/getLockers.dart';
import 'package:locker_management/models/lockerStatus.dart';
import 'package:locker_management/models/myLocker.dart';
import 'package:locker_management/models/notificationModel.dart';
import 'package:locker_management/models/user.dart';
import 'package:locker_management/provider/userDetailsProvider.dart';

final dio = Dio();

class ApiResponse {
  final String baseUrl = "http://192.168.68.187:8080";

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
      print('working#######################');
      return response;
    } catch (e) {
      if (e is DioException) {
        // Show error message
        print('Here###################################');
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  // get user details
  Future<UserModel> getUserDetails() async {
    try {
      final token = UserDetailsProvider().getToken();

      final response = await dio.get(
        '$baseUrl/user',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data); // Parse JSON into UserModel
      } else {
        throw Exception("Failed to fetch user details");
      }
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

  Future<dynamic> editBuildings(
    String buildingName,
    String buildingLocation,
    int totalLocker,
    int id,
  ) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updateBuilding',
        data: {
          "name": buildingName,
          "location": buildingLocation,
          "totalLocker": totalLocker,
          "id": id,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to edit buildings ");
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

  Future<dynamic> deleteBuildings(int id) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.delete(
        '$baseUrl/buildings/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
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

  Future<dynamic> addLocker(
    int buildingId,
    String lockerStatus,
    String lockerType,
    String location,
  ) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/addLocker',
        data: {
          "buildingId": buildingId,
          "status": lockerStatus,
          "type": lockerType,
          "location": location,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
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

  Future<dynamic> deleteLocker(int id) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.delete(
        '$baseUrl/deleteLocker/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
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

  // get all lockers
  Future<List<GetAllLockers>> fetchLockers() async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.get(
        '$baseUrl/lockers',
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
        return data.map((item) => GetAllLockers.fromJson(item)).toList();
      } else {
        throw Exception("Failed to load lockers");
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

  // update locker status
  Future<dynamic> updateLockerStatus(int id, String status) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updateLocker',
        data: {"id": id, "status": status},
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
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

  // update reservation status
  Future<dynamic> updateReservationStatus(int id, String status) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updateReservation',
        data: {"id": id, "status": status},
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print('here ' + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        print('not here ' + e.toString());
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  // reserve locker
  Future<dynamic> reserveLocker(
    int startDate,
    int endDate,
    int lockerId,
  ) async {
    try {
      final token = UserDetailsProvider().getToken();
      Response response = await dio.post(
        '$baseUrl/reserveLocker',
        data: {
          "id": 1,
          "userId": 1,
          "startDate": startDate,
          "endDate": endDate,
          "lockerID": lockerId,
          "status": "REQUESTED",
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
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

  // my locker
  Future<dynamic> myLocker() async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.get(
        '$baseUrl/myReservations',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<LockerRequest> lockerRequests =
            (response.data as List)
                .map((item) => LockerRequest.fromJson(item))
                .toList();
        return lockerRequests;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print("here " + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        print("not here you " + e.toString());
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  // update name
  Future<dynamic> updateName(String name) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updateName',
        data: {"name": name},
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
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

  // update phone
  Future<dynamic> updatePhone(String phone) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updatePhone',
        data: {"phone": phone},
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
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

  // update token
  Future<dynamic> updateToken(String firebaseToken) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updateFirebaseToken',
        data: {"firebaseToken": token},
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print('are you here ' + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  // all users
  Future<dynamic> allUsers() async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.get(
        '$baseUrl/allUsers',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<User> users =
            (response.data as List).map((item) => User.fromJson(item)).toList();
        return users;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print("here " + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        print("not here you " + e.toString());
        Fluttertoast.showToast(msg: "Error: $e");
        throw Exception(e);
      }
    }
  }

  // update user status
  Future<dynamic> updateUserStatus(int id, String status) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/updateUserStatus',
        data: {"id": id, "status": status},
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
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

  // locker status
  Future<dynamic> lockerStatus() async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.get(
        '$baseUrl/reservations',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<LockerStatusModel> lockerStatuses = LockerStatusModel.fromJsonList(
          response.data,
        );
        return lockerStatuses;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print("here " + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error go: $e");
        throw Exception(e);
      }
    }
  }

  // release locker
  Future<dynamic> releaseLocker(int id) async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.post(
        '$baseUrl/releaseLocker/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print("here " + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error go: $e");
        throw Exception(e);
      }
    }
  }

  // notofication
  Future<dynamic> notification() async {
    try {
      final token = UserDetailsProvider().getToken();

      Response response = await dio.get(
        '$baseUrl/notification',
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Send JWT Token
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        print('here ' + response.data.toString());
        List<NotificationModel> notifications = NotificationModel.fromJsonList(
          response.data,
        );

        for (var notification in notifications) {
          print("Notification ID: ${notification.id}");
          print("Message: ${notification.message}");
          print(
            "Timestamp: ${notification.dateTime}",
          ); // This will print the timestamp as a readable date
        }
        return notifications;
      } else {
        throw Exception("Failed to load lockers");
      }
    } catch (e) {
      if (e is DioException) {
        print("here " + e.toString());
        Fluttertoast.showToast(msg: "Error: ${e.response?.data ?? e.message}");

        throw Exception("API Error: ${e.response?.data}");
      } else {
        Fluttertoast.showToast(msg: "Error go: $e");
        throw Exception(e);
      }
    }
  }
}
