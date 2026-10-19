import 'package:flutter/material.dart';

class CourseModel {
  final String id;
  final String code;
  final String name;
  final String instructor;
  final String colorHex;
  final String defaultRoom;

  const CourseModel({
    required this.id,
    required this.code,
    required this.name,
    this.instructor = '',
    required this.colorHex,
    this.defaultRoom = '',
  });

  Color get color {
    try {
      final cleanHex = colorHex.replaceAll('#', '');
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'instructor': instructor,
      'color_hex': colorHex,
      'default_room': defaultRoom,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String,
      code: map['code'] as String,
      name: map['name'] as String,
      instructor: (map['instructor'] as String?) ?? '',
      colorHex: (map['color_hex'] as String?) ?? '6366F1',
      defaultRoom: (map['default_room'] as String?) ?? '',
    );
  }

  CourseModel copyWith({
    String? id,
    String? code,
    String? name,
    String? instructor,
    String? colorHex,
    String? defaultRoom,
  }) {
    return CourseModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      instructor: instructor ?? this.instructor,
      colorHex: colorHex ?? this.colorHex,
      defaultRoom: defaultRoom ?? this.defaultRoom,
    );
  }
}
