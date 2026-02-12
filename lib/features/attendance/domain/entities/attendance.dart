import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final int? id;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String status; // 'Present', 'Absent', 'Half-day'
  final String? remarks;

  const Attendance({
    this.id,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.remarks,
  });

  @override
  List<Object?> get props => [id, date, checkInTime, checkOutTime, status, remarks];
}
