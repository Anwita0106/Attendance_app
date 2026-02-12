import '../../../../core/database/database_helper.dart';
import '../../../../core/error/failures.dart';
import '../models/attendance_model.dart';

abstract class AttendanceLocalDataSource {
  Future<List<AttendanceModel>> getAttendanceToday();
  Future<List<AttendanceModel>> getAllAttendance();
  Future<void> saveAttendance(AttendanceModel attendance);
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final DatabaseHelper databaseHelper;

  AttendanceLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<AttendanceModel>> getAllAttendance() async {
    try {
      final result = await databaseHelper.queryAll('attendance');
      return result.map((e) => AttendanceModel.fromJson(e)).toList();
    } catch (e) {
      throw const DatabaseFailure('Failed to fetch attendance records');
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceToday() async {
     try {
      final now = DateTime.now();
      // Logic: Query items where 'date' matches today.
      final result = await databaseHelper.queryByDate('attendance', now.toIso8601String());
      return result.map((e) => AttendanceModel.fromJson(e)).toList();
    } catch (e) {
      throw const DatabaseFailure('Failed to fetch today\'s attendance');
    }
  }

  @override
  Future<void> saveAttendance(AttendanceModel attendance) async {
    try {
      await databaseHelper.insert('attendance', attendance.toJson());
    } catch (e) {
      throw const DatabaseFailure('Failed to save attendance record');
    }
  }
}
