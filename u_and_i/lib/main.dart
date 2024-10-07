import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'sunflower',
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontWeight: FontWeight.w700,
            fontFamily: 'parisienne',
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w700,
            fontFamily: 'snowflower',
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      home: HomeScreen(),
    ),
  );
}
