import 'package:flutter/material.dart';
import 'pages/login_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notesheet Tracker (UI Only)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.pinkAccent,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: LoginPage(),
    );
  }
}
