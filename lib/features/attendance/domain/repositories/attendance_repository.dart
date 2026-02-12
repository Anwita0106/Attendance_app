import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<Attendance>>> getAttendanceToday();
  Future<Either<Failure, List<Attendance>>> getAllAttendance();
  Future<Either<Failure, void>> saveAttendance(Attendance attendance);
}
