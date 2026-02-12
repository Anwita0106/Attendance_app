import 'package:get_it/get_it.dart';
import 'core/database/database_helper.dart';
import 'features/attendance/data/datasources/attendance_local_data_source.dart';
import 'features/attendance/data/repositories/attendance_repository_impl.dart';
import 'features/attendance/domain/repositories/attendance_repository.dart';
import 'features/attendance/domain/usecases/get_attendance_today.dart';
import 'features/attendance/domain/usecases/save_attendance.dart';
import 'features/attendance/domain/usecases/get_all_attendance.dart';
import 'features/attendance/presentation/bloc/attendance_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Attendance
  // Bloc
  sl.registerFactory(
    () => AttendanceBloc(
      getAttendanceToday: sl(),
      saveAttendance: sl(),
      getAllAttendance: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAttendanceToday(sl()));
  sl.registerLazySingleton(() => SaveAttendance(sl()));
  sl.registerLazySingleton(() => GetAllAttendance(sl()));

  // Repository
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AttendanceLocalDataSource>(
    () => AttendanceLocalDataSourceImpl(databaseHelper: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => DatabaseHelper.instance);

  //! External
  // Database instance is handled within DatabaseHelper, but we could expose db here if needed
}
