import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/student_page.dart';
import 'pages/reviewer_page.dart';
import 'pages/hod_page.dart';
import 'pages/student_dashboard.dart';

const MaterialColor maroon = MaterialColor(0xFF800000, {
  50: Color(0xFF800000),
  100: Color(0xFF800000),
  200: Color(0xFF800000),
  300: Color(0xFF800000),
  400: Color(0xFF800000),
  500: Color(0xFF800000),
  600: Color(0xFF800000),
  700: Color(0xFF800000),
  800: Color(0xFF800000),
  900: Color(0xFF800000),
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://wdffpeiwqmkpmbvkncqw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkZmZwZWl3cW1rcG1idmtuY3F3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI4NTk5MzMsImV4cCI6MjA2ODQzNTkzM30.I83lUfDX2h0h2KkMR5yHO3ZvqBCgvSQRSJMiM3ZLWyo',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      return const LoginPage();
    } else {
      final userId = session.user.id;
      final response = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
      final role = response['role'];
      if (role == 'student') {
        return const StudentPage();
      } else if (role == 'reviewer') {
        return const ReviewerPage();
      } else if (role == 'hod') {
        return const HodDashboardPage();
      } else {
        return const StudentDashboard();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notesheet Approval System',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF800000), // Maroon
        scaffoldBackgroundColor: const Color(
          0xFF1A0000,
        ), // Dark maroonish background
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF800000), // Accent maroon
          brightness: Brightness.dark,
        ),
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
