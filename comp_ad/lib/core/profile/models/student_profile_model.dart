import 'dart:convert';

class StudentProfileModel {
  final String id;
  final String name;
  final String collegeName;
  final String rollNo;
  final String year;
  final String department;
  final bool isAnonymous;
  final bool isBiometricEnabled;
  final bool isSetupCompleted;

  const StudentProfileModel({
    this.id = 'primary',
    this.name = '',
    this.collegeName = '',
    this.rollNo = '',
    this.year = '1st Year',
    this.department = '',
    this.isAnonymous = false,
    this.isBiometricEnabled = false,
    this.isSetupCompleted = false,
  });

  String get displayName => name.trim().isNotEmpty ? name : 'Student';
  String get displayCollege => collegeName.trim().isNotEmpty ? collegeName : 'Campus';
  String get displayRollNo => rollNo.trim().isNotEmpty ? rollNo : 'Unassigned';
  String get displayDepartment => department.trim().isNotEmpty ? department : 'Department';

  /// Generates the payload string for QR Code rendering and sharing
  String toQrPayload() {
    final Map<String, dynamic> data = {
      'type': 'COMPAD_IDENTITY_CHIP',
      'id': id,
      'name': isAnonymous ? 'Anonymous Student' : name,
      'college': isAnonymous ? 'Confidential' : collegeName,
      'roll_no': isAnonymous ? 'HIDDEN' : rollNo,
      'year': year,
      'department': isAnonymous ? 'Confidential' : department,
      'is_anonymous': isAnonymous,
      'v': 2,
    };
    return jsonEncode(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'college_name': collegeName,
      'roll_no': rollNo,
      'year': year,
      'department': department,
      'is_anonymous': isAnonymous ? 1 : 0,
      'is_biometric_enabled': isBiometricEnabled ? 1 : 0,
      'is_setup_completed': isSetupCompleted ? 1 : 0,
    };
  }

  factory StudentProfileModel.fromMap(Map<String, dynamic> map) {
    return StudentProfileModel(
      id: map['id'] as String? ?? 'primary',
      name: map['name'] as String? ?? '',
      collegeName: map['college_name'] as String? ?? '',
      rollNo: map['roll_no'] as String? ?? '',
      year: map['year'] as String? ?? '1st Year',
      department: map['department'] as String? ?? '',
      isAnonymous: (map['is_anonymous'] as int? ?? 0) == 1,
      isBiometricEnabled: (map['is_biometric_enabled'] as int? ?? 0) == 1,
      isSetupCompleted: (map['is_setup_completed'] as int? ?? 0) == 1,
    );
  }

  StudentProfileModel copyWith({
    String? id,
    String? name,
    String? collegeName,
    String? rollNo,
    String? year,
    String? department,
    bool? isAnonymous,
    bool? isBiometricEnabled,
    bool? isSetupCompleted,
  }) {
    return StudentProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      collegeName: collegeName ?? this.collegeName,
      rollNo: rollNo ?? this.rollNo,
      year: year ?? this.year,
      department: department ?? this.department,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isSetupCompleted: isSetupCompleted ?? this.isSetupCompleted,
    );
  }
}
