import 'package:finf_app/core/util/time_formatter.dart';

class StaticRecord {
  final String createdAt;
  final String updatedAt;
  final int id;
  final int userId;
  final int record;
  final bool highest;

  StaticRecord({
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.userId,
    required this.record,
    required this.highest,
  });

  String get formattedRecord => TimeFormatter.formatSeconds(record);

  factory StaticRecord.fromJson(Map<String, dynamic> json) {
    return StaticRecord(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      id: json['id'],
      userId: json['userId'],
      record: json['record'],
      highest: json['highest'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      'userId': userId,
      'record': record,
      'highest': highest,
    };
  }
}
