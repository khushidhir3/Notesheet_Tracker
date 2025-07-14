import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD84dB8AouEUXo3PoOHmtDVQTbSsRsxhPA",
      authDomain: "notesheet-tracker-5df6b.firebaseapp.com",
      projectId: "notesheet-tracker-5df6b",
      storageBucket: "notesheet-tracker-5df6b.firebasestorage.app",
      messagingSenderId: "134835418214",
      appId: "1:134835418214:web:ffdde70071fd4c080a69a7",
      measurementId: "G-5R517E3DMG",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notesheet Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.pinkAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
