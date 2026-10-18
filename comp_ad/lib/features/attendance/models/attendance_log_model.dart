class AttendanceLogModel {
  final String id;
  final String courseId;
  final DateTime timestamp;
  final String status; // 'present', 'absent', 'canceled'

  const AttendanceLogModel({
    required this.id,
    required this.courseId,
    required this.timestamp,
    required this.status,
  });

  bool get isPresent => status.toLowerCase() == 'present';
  bool get isAbsent => status.toLowerCase() == 'absent';
  bool get isCanceled => status.toLowerCase() == 'canceled';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'course_id': courseId,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }

  factory AttendanceLogModel.fromMap(Map<String, dynamic> map) {
    return AttendanceLogModel(
      id: map['id'] as String,
      courseId: map['course_id'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      status: map['status'] as String,
    );
  }

  AttendanceLogModel copyWith({
    String? id,
    String? courseId,
    DateTime? timestamp,
    String? status,
  }) {
    return AttendanceLogModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }
}
