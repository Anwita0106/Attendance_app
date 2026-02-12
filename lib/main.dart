import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/attendance/presentation/pages/attendance_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize dependency injection
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0), // School Blue
          brightness: Brightness.light,
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF64B5F6),
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      themeMode:
          ThemeMode.system, // Starts with system, toggling implemented later
      home: const AttendancePage(),
    );
  }
}
