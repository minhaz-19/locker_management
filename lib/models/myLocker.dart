import 'dart:convert';

class LockerRequest {
  final int id;
  final int userId;
  final int startDate;
  final int endDate;
  final int lockerID;
  final String status;

  LockerRequest({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.lockerID,
    required this.status,
  });

  factory LockerRequest.fromJson(Map<String, dynamic> json) {
    return LockerRequest(
      id: json['id'],
      userId: json['userId'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      lockerID: json['lockerID'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
      'lockerID': lockerID,
      'status': status,
    };
  }

  static List<LockerRequest> fromJsonList(String jsonString) {
    final List<dynamic> decoded = json.decode(jsonString);
    return decoded.map((item) => LockerRequest.fromJson(item)).toList();
  }
}
