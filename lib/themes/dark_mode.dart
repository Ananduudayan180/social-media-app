import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    //very dart
    surface: Color.fromARGB(255, 9, 9, 9),
    //slightly light
    primary: Color.fromARGB(255, 105, 105, 105),
    //dark
    secondary: Color.fromARGB(255, 20, 20, 20),
    //slightly dark
    inversePrimary: Color.fromARGB(255, 195, 195, 195),
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 9, 9, 9),
);
