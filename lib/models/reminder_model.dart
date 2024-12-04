import 'package:flutter/material.dart';

class ReminderTimeSlot {
  final String id;
  final TimeOfDay time;
  final String title;
  final bool isEnabled;

  ReminderTimeSlot({
    String? id,
    required this.time,
    required this.title,
    this.isEnabled = true,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  // Convert TimeOfDay to JSON-compatible format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'title': title,
      'isEnabled': isEnabled,
    };
  }

  // Create ReminderTimeSlot from JSON
  factory ReminderTimeSlot.fromJson(Map<String, dynamic> json) {
    return ReminderTimeSlot(
      id: json['id'],
      time: TimeOfDay(hour: json['hour'], minute: json['minute']),
      title: json['title'],
      isEnabled: json['isEnabled'],
    );
  }

  ReminderTimeSlot copyWith({
    String? id,
    TimeOfDay? time,
    String? title,
    bool? isEnabled,
  }) {
    return ReminderTimeSlot(
      id: id ?? this.id,
      time: time ?? this.time,
      title: title ?? this.title,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
