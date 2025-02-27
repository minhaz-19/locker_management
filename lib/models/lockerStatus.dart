import 'dart:convert';

class LockerStatusModel {
  final int id;
  final int userId;
  final DateTime startDate;
  final DateTime endDate;
  final int lockerID;
  final String status;

  LockerStatusModel({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.lockerID,
    required this.status,
  });

  // Factory constructor to create an instance from JSON
  factory LockerStatusModel.fromJson(Map<String, dynamic> json) {
    return LockerStatusModel(
      id: json['id'],
      userId: json['userId'],
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
      lockerID: json['lockerID'],
      status: json['status'],
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'lockerID': lockerID,
      'status': status,
    };
  }

  // FIX: Accept a List instead of a String
  static List<LockerStatusModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => LockerStatusModel.fromJson(item)).toList();
  }

  // Convert List of LockerStatusModel objects to JSON string
  static String toJsonList(List<LockerStatusModel> requests) {
    return json.encode(List<dynamic>.from(requests.map((x) => x.toJson())));
  }
}
