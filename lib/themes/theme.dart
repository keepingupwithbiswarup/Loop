import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color.fromARGB(255, 52, 51, 65),
  scaffoldBackgroundColor: Colors.white,
  textTheme: TextTheme(
    titleLarge: GoogleFonts.montserrat(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.montserrat(
        color: const Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.bold,
        fontSize: 20),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 15,
    ),
    labelSmall: GoogleFonts.blinker(
      fontSize: 18,
      color: const Color.fromARGB(255, 194, 194, 194), // Define only color
    ),
    labelMedium: GoogleFonts.blinker(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 52, 51, 65), // Define only color
    ),
    bodySmall: GoogleFonts.blinker(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 52, 51, 65), // Define only color
    ),
    bodyMedium: GoogleFonts.blinker(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 241, 241, 241), // Define only color
    ),
    bodyLarge: GoogleFonts.blinker(
      fontSize: 30,
      color: const Color.fromARGB(255, 52, 51, 65), // Define only color
    ),
    labelLarge: GoogleFonts.blinker(
      fontSize: 20,
      color: const Color.fromARGB(255, 52, 51, 65), // Define only color
    ),
    displayMedium: GoogleFonts.blinker(
      fontSize: 20,
      color: const Color.fromARGB(255, 241, 241, 241), // Define only color
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  scaffoldBackgroundColor: Colors.black,
  textTheme: TextTheme(
    titleLarge: GoogleFonts.montserrat(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 15,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
    titleMedium: GoogleFonts.montserrat(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.bold,
        fontSize: 20),
  ),
);
