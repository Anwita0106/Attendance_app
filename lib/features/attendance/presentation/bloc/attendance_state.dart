part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendanceList;

  const AttendanceLoaded(this.attendanceList);

  @override
  List<Object> get props => [attendanceList];
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
