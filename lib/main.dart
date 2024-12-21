import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart'; // Подключение google_fonts
import 'screens/main_navigation.dart';

void main() {
  runApp(const ProviderScope(child: UniversityApp()));
}

class UniversityApp extends StatelessWidget {
  const UniversityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Hub',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        textTheme: TextTheme(
          titleLarge: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          bodyMedium: GoogleFonts.lato(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          bodySmall: GoogleFonts.lato(
            fontWeight: FontWeight.w300,
            fontSize: 14,
          ),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
