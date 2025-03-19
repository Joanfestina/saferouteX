import 'package:flutter/material.dart';
import 'screens/login_selection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginSelectionPage(), // Main starting page
      debugShowCheckedModeBanner: false, // Removes the debug banner
    );
  }
}
