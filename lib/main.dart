import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/demo_hub.dart';
import 'theme/app_theme.dart';
import 'services/appwrite_service.dart';

// ═══════════════════════════════════════════
//  Set to false when connecting real backend
// ═══════════════════════════════════════════
const bool demoMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite
  if (!demoMode) {
    AppwriteService.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notesheet Approval System',
      theme: ThemeData.dark().copyWith(
        primaryColor: AppColors.crimson,
        scaffoldBackgroundColor: AppColors.bgDark,
        textTheme: GoogleFonts.rajdhaniTextTheme(
          ThemeData.dark().textTheme,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.crimson,
          secondary: AppColors.bloodRed,
          surface: AppColors.bgCard,
          error: AppColors.rejected,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.bgSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.bloodRed.withOpacity(0.3)),
          ),
        ),
      ),
      home: const DemoHub(),
    );
  }
}
