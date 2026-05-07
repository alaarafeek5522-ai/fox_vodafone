import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoxVodafoneApp());
}

class FoxVodafoneApp extends StatelessWidget {
  const FoxVodafoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fox Vodafone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFE53935),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFE53935),
          secondary: const Color(0xFFC62828),
          surface: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
