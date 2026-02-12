import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_local_data_source.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource localDataSource;

  AttendanceRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Attendance>>> getAllAttendance() async {
    try {
      final result = await localDataSource.getAllAttendance();
      return Right(result);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
       return const Left(DatabaseFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceToday() async {
    try {
      final result = await localDataSource.getAttendanceToday();
      return Right(result);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
       return const Left(DatabaseFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> saveAttendance(Attendance attendance) async {
    try {
      final attendanceModel = AttendanceModel.fromEntity(attendance);
      await localDataSource.saveAttendance(attendanceModel);
      return const Right(null);
    } on DatabaseFailure catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
       return const Left(DatabaseFailure('Unexpected error occurred'));
    }
  }
}
