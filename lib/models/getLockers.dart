import 'dart:convert';

class GetAllLockers {
  final int id;
  final int buildingId;
  final String status;
  final String type;
  final String location;

  GetAllLockers({
    required this.id,
    required this.buildingId,
    required this.status,
    required this.type,
    required this.location,
  });

  factory GetAllLockers.fromJson(Map<String, dynamic> json) {
    return GetAllLockers(
      id: json['id'],
      buildingId: json['buildingId'],
      status: json['status'],
      type: json['type'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buildingId': buildingId,
      'status': status,
      'type': type,
      'location': location,
    };
  }

  static List<GetAllLockers> fromJsonList(String jsonString) {
    final List<dynamic> data = json.decode(jsonString);
    return data.map((item) => GetAllLockers.fromJson(item)).toList();
  }

  static String toJsonList(List<GetAllLockers> lockers) {
    final List<Map<String, dynamic>> data = lockers.map((b) => b.toJson()).toList();
    return json.encode(data);
  }
}