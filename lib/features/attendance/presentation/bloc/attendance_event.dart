part of 'attendance_bloc.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object> get props => [];
}

class LoadAttendanceToday extends AttendanceEvent {}

class LoadAllAttendance extends AttendanceEvent {}

class AddAttendanceEvent extends AttendanceEvent {
  final Attendance attendance;

  const AddAttendanceEvent(this.attendance);

  @override
  List<Object> get props => [attendance];
}
