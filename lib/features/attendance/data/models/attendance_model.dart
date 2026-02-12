import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    super.id,
    required super.date,
    super.checkInTime,
    super.checkOutTime,
    required super.status,
    super.remarks,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      checkInTime: json['checkInTime'] != null ? DateTime.parse(json['checkInTime']) : null,
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      status: json['status'],
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'status': status,
      'remarks': remarks,
    };
  }

  factory AttendanceModel.fromEntity(Attendance attendance) {
    return AttendanceModel(
      id: attendance.id,
      date: attendance.date,
      checkInTime: attendance.checkInTime,
      checkOutTime: attendance.checkOutTime,
      status: attendance.status,
      remarks: attendance.remarks,
    );
  }
}
