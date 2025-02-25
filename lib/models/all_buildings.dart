import 'dart:convert';

class Buildings {
  final int id;
  final String location;
  final String name;
  final int totalLocker;

  Buildings({
    required this.id,
    required this.location,
    required this.name,
    required this.totalLocker,
  });

  // Convert JSON to Dart Object
  factory Buildings.fromJson(Map<String, dynamic> json) {
    return Buildings(
      id: json['id'],
      location: json['location'],
      name: json['name'],
      totalLocker: json['totalLocker'],
    );
  }

  // Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'name': name,
      'totalLocker': totalLocker,
    };
  }

  // Convert List of JSON to List of Dart Objects
  static List<Buildings> listFromJson(String str) {
    return List<Buildings>.from(json.decode(str).map((x) => Buildings.fromJson(x)));
  }

  // Convert List of Dart Objects to JSON
  static String listToJson(List<Buildings> data) {
    return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  }
}
