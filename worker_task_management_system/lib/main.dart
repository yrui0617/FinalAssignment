import 'package:flutter/material.dart';
import 'package:worker_task_management_system/view/splashscreen.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: const SplashScreen(),
    );
  }
}
