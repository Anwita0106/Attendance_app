import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class SaveAttendanceParams {
  final Attendance attendance;
  const SaveAttendanceParams(this.attendance);
}

class SaveAttendance implements UseCase<void, SaveAttendanceParams> {
  final AttendanceRepository repository;

  SaveAttendance(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveAttendanceParams params) async {
    return await repository.saveAttendance(params.attendance);
  }
}
