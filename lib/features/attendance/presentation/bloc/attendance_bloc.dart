import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/usecases/get_attendance_today.dart';
import '../../domain/usecases/save_attendance.dart';
import '../../domain/usecases/get_all_attendance.dart';

part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceToday getAttendanceToday;
  final SaveAttendance saveAttendance;
  final GetAllAttendance getAllAttendance;

  AttendanceBloc({
    required this.getAttendanceToday,
    required this.saveAttendance,
    required this.getAllAttendance,
  }) : super(AttendanceInitial()) {
    on<LoadAttendanceToday>(_onLoadAttendanceToday);
    on<LoadAllAttendance>(_onLoadAllAttendance);
    on<AddAttendanceEvent>(_onAddAttendance);
  }

  Future<void> _onLoadAttendanceToday(
    LoadAttendanceToday event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    final result = await getAttendanceToday(NoParams());
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendanceList) => emit(AttendanceLoaded(attendanceList)),
    );
  }

  Future<void> _onLoadAllAttendance(
    LoadAllAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    final result = await getAllAttendance(NoParams());
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (attendanceList) => emit(AttendanceLoaded(attendanceList)),
    );
  }

  Future<void> _onAddAttendance(
    AddAttendanceEvent event,
    Emitter<AttendanceState> emit,
  ) async {
    // Optimistic update or reload? Let's reload for simplicity and consistency
    // Show loading? Maybe not necessary if it's fast, but good practice.
    // emit(AttendanceLoading()); // careful, this might flicker
    final result = await saveAttendance(SaveAttendanceParams(event.attendance));
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (_) => add(LoadAttendanceToday()), // Reload today's list after adding
    );
  }
}
