import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'student_page.dart';
import 'reviewer_page.dart';
import 'hod_page.dart';
import 'student_dashboard.dart';

class DemoHub extends StatefulWidget {
  const DemoHub({super.key});

  @override
  State<DemoHub> createState() => _DemoHubState();
}

class _DemoHubState extends State<DemoHub> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _staggerController;

  final List<_PageEntry> pages = [
    _PageEntry(
      title: 'LOGIN',
      subtitle: 'Authentication Gate',
      icon: Icons.lock_outlined,
      page: const LoginPage(),
      glowColor: AppColors.crimson,
    ),
    _PageEntry(
      title: 'SIGN UP',
      subtitle: 'Create Identity',
      icon: Icons.person_add_outlined,
      page: const SignUpPage(),
      glowColor: AppColors.emberGlow,
    ),
    _PageEntry(
      title: 'STUDENT',
      subtitle: 'Submit Notesheet',
      icon: Icons.edit_note_rounded,
      page: const StudentPage(),
      glowColor: const Color(0xFFFF4444),
    ),
    _PageEntry(
      title: 'REVIEWER',
      subtitle: 'Approve / Reject',
      icon: Icons.rate_review_outlined,
      page: const ReviewerPage(),
      glowColor: const Color(0xFFCC1133),
    ),
    _PageEntry(
      title: 'HOD',
      subtitle: 'Final Authority',
      icon: Icons.gavel_rounded,
      page: const HodDashboardPage(),
      glowColor: AppColors.bloodRed,
    ),
    _PageEntry(
      title: 'DASHBOARD',
      subtitle: 'Approved Archive',
      icon: Icons.dashboard_customize_outlined,
      page: const StudentDashboard(),
      glowColor: const Color(0xFFAA0022),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.scaffoldGradient(),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // ── Header ──
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        AppColors.crimson,
                        AppColors.emberGlow.withOpacity(
                          0.6 + _pulseController.value * 0.4,
                        ),
                        AppColors.crimson,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'NOTESHEET',
                      style: AppTextStyles.headingLarge.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                '▸▸ APPROVAL SYSTEM ◂◂',
                style: AppTextStyles.subtitle.copyWith(letterSpacing: 6),
              ),
              const SizedBox(height: 6),
              Text(
                'DEMO MODE',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.pending,
                  letterSpacing: 6,
                  fontSize: 11,
                ),
              ),
              const GlowDivider(),
              // ── Page Grid ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final entry = pages[index];
                      final delay = index * 0.15;
                      return AnimatedBuilder(
                        animation: _staggerController,
                        builder: (context, child) {
                          final progress = (_staggerController.value - delay)
                              .clamp(0.0, 1.0);
                          final curve =
                              Curves.easeOutBack.transform(progress.toDouble());
                          return Transform.translate(
                            offset: Offset(0, 40 * (1 - curve)),
                            child: Opacity(
                              opacity: curve.clamp(0.0, 1.0),
                              child: child,
                            ),
                          );
                        },
                        child: _buildPageCard(entry),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageCard(_PageEntry entry) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => entry.page,
            transitionsBuilder: (_, anim, __, child) {
              return FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: anim,
                    curve: Curves.easeOut,
                  )),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final glow =
              0.15 + (_pulseController.value * 0.15);
          return Container(
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: entry.glowColor.withOpacity(0.35),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: entry.glowColor.withOpacity(glow),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: entry.glowColor.withOpacity(0.1),
                  border: Border.all(
                    color: entry.glowColor.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: entry.glowColor.withOpacity(0.2),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Icon(
                  entry.icon,
                  color: entry.glowColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                entry.title,
                style: AppTextStyles.cardTitle.copyWith(
                  color: entry.glowColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                entry.subtitle,
                style: AppTextStyles.label.copyWith(fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: entry.glowColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: entry.glowColor.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  'ENTER ▸',
                  style: AppTextStyles.label.copyWith(
                    fontSize: 10,
                    color: entry.glowColor.withOpacity(0.8),
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
  final Color glowColor;

  _PageEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
    required this.glowColor,
  });
}
