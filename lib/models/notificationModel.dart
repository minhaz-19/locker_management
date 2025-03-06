class NotificationModel {
  final int id;
  final String message;
  final int timestamp;
  final int userId;

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.userId,
  });

  // Getter to convert the timestamp into a DateTime object
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
      timestamp: json['timestamp'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  static List<NotificationModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NotificationModel.fromJson(json)).toList();
  }
}
