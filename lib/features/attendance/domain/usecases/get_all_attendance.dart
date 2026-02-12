import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/attendance.dart';
import '../repositories/attendance_repository.dart';

class GetAllAttendance implements UseCase<List<Attendance>, NoParams> {
  final AttendanceRepository repository;

  GetAllAttendance(this.repository);

  @override
  Future<Either<Failure, List<Attendance>>> call(NoParams params) async {
    return await repository.getAllAttendance();
  }
}
