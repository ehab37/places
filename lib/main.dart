import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:places/screens/places.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 103, 33, 243),
  background: const Color.fromARGB(255, 28, 33, 62),
  brightness: Brightness.dark,
);

void main() {
  runApp(
    const ProviderScope(
      child: PlacesApp(),
    ),
  );
}

class PlacesApp extends StatelessWidget {
  const PlacesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.background,
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleSmall: GoogleFonts.ubuntuCondensed(
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.ubuntuCondensed(
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.ubuntuCondensed(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const Places(),
    );
  }
}
