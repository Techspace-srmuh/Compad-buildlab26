class CardModel {
  final String id;
  final String title;
  final String studentName;
  final String rollNumber;
  final String barcodeValue;
  final String barcodeFormat; // 'CODE_128', 'QR_CODE', etc.

  const CardModel({
    required this.id,
    required this.title,
    required this.studentName,
    required this.rollNumber,
    required this.barcodeValue,
    required this.barcodeFormat,
  });

  bool get isQrCode => barcodeFormat.toUpperCase().contains('QR');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'student_name': studentName,
      'roll_number': rollNumber,
      'barcode_value': barcodeValue,
      'barcode_format': barcodeFormat,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      id: map['id'] as String,
      title: map['title'] as String,
      studentName: map['student_name'] as String,
      rollNumber: map['roll_number'] as String,
      barcodeValue: map['barcode_value'] as String,
      barcodeFormat: map['barcode_format'] as String,
    );
  }

  CardModel copyWith({
    String? id,
    String? title,
    String? studentName,
    String? rollNumber,
    String? barcodeValue,
    String? barcodeFormat,
  }) {
    return CardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      studentName: studentName ?? this.studentName,
      rollNumber: rollNumber ?? this.rollNumber,
      barcodeValue: barcodeValue ?? this.barcodeValue,
      barcodeFormat: barcodeFormat ?? this.barcodeFormat,
    );
  }
}
