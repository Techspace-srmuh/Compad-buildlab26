import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CalendarActivityModel {
  final String id;
  final String title;
  final String date; // 'YYYY-MM-DD'
  final String time; // '10:00 AM'
  final String category; // 'Exam', 'Assignment', 'Lab/Viva', 'Event', 'Deadline', 'Personal'
  final String colorHex;
  final String notes;
  final bool isCompleted;

  const CalendarActivityModel({
    required this.id,
    required this.title,
    required this.date,
    this.time = '',
    required this.category,
    required this.colorHex,
    this.notes = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'category': category,
      'color_hex': colorHex,
      'notes': notes,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory CalendarActivityModel.fromMap(Map<String, dynamic> map) {
    return CalendarActivityModel(
      id: map['id'] as String,
      title: map['title'] as String,
      date: map['date'] as String,
      time: map['time'] as String? ?? '',
      category: map['category'] as String? ?? 'Event',
      colorHex: map['color_hex'] as String? ?? '06B6D4',
      notes: map['notes'] as String? ?? '',
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
    );
  }

  Color get color {
    try {
      final clean = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xFF06B6D4);
    }
  }

  IconData get icon {
    switch (category.toLowerCase()) {
      case 'exam':
      case 'midsem':
      case 'endsem':
        return LucideIcons.graduationCap;
      case 'assignment':
      case 'project':
        return LucideIcons.fileCode;
      case 'lab/viva':
      case 'viva':
      case 'lab':
        return LucideIcons.flaskConical;
      case 'deadline':
      case 'submission':
        return LucideIcons.alarmClock;
      case 'event':
      case 'fest':
      case 'sports':
        return LucideIcons.trophy;
      default:
        return LucideIcons.calendarCheck;
    }
  }

  CalendarActivityModel copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? category,
    String? colorHex,
    String? notes,
    bool? isCompleted,
  }) {
    return CalendarActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      colorHex: colorHex ?? this.colorHex,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
