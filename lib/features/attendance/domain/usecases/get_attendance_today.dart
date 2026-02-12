import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceToday implements UseCase<List<Attendance>, NoParams> {
  final AttendanceRepository repository;

  GetAttendanceToday(this.repository);

  @override
  Future<Either<Failure, List<Attendance>>> call(NoParams params) async {
    return await repository.getAttendanceToday();
  }
}
