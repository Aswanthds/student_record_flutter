import 'package:flutter/material.dart';
import 'package:student/Screens/home_screen.dart';
import 'package:student/functions/functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(
            background: Color(0xFFEEEEEE),
            primary: Color(0xFFDA7D03),
            brightness: Brightness.light,
            secondary: Color(0xFFDA7D03)),
      ),
      home: const HomeScreen(),
    );
  }
}
