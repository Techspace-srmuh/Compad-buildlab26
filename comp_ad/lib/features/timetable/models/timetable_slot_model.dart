import 'course_model.dart';

class TimetableSlotModel {
  final String id;
  final String courseId;
  final int dayOfWeek; // 1 = Mon, 2 = Tue, ..., 6 = Sat, 7 = Sun
  final String startTime; // "08:30"
  final String endTime; // "10:00"
  final String room;
  final CourseModel? course;

  const TimetableSlotModel({
    required this.id,
    required this.courseId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
    };
  }

  factory TimetableSlotModel.fromMap(Map<String, dynamic> map, {CourseModel? course}) {
    return TimetableSlotModel(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      dayOfWeek: map['day_of_week'] as int,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
      room: (map['room'] as String?) ?? '',
      course: course,
    );
  }

  TimetableSlotModel copyWith({
    String? id,
    String? courseId,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? room,
    CourseModel? course,
  }) {
    return TimetableSlotModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      course: course ?? this.course,
    );
  }
}
