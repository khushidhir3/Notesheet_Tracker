import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════
//  COLOR PALETTE — Dark Crimson Gothic
// ═══════════════════════════════════════════

class AppColors {
  // Backgrounds
  static const Color bgDark = Color(0xFF0A0A0A);
  static const Color bgCard = Color(0xFF1A0A0A);
  static const Color bgSurface = Color(0xFF120808);
  static const Color bgElevated = Color(0xFF1E0E0E);

  // Accents
  static const Color crimson = Color(0xFFDC143C);
  static const Color bloodRed = Color(0xFF8B0000);
  static const Color emberGlow = Color(0xFFFF2D2D);
  static const Color deepCrimson = Color(0xFF5C0A0A);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCCAAAA);
  static const Color textMuted = Color(0xFFFF9999);
  static const Color textDim = Color(0xFF886666);

  // Status
  static const Color approved = Color(0xFF00FF88);
  static const Color rejected = Color(0xFFFF3333);
  static const Color pending = Color(0xFFFFAA00);

  // Gradients
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0A0A0A), Color(0xFF1A0505), Color(0xFF0A0A0A)],
  );

  static const LinearGradient crimsonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bloodRed, crimson],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A0A0A), Color(0xFF150505)],
  );
}

// ═══════════════════════════════════════════
//  TEXT STYLES
// ═══════════════════════════════════════════

class AppTextStyles {
  static TextStyle get heading => GoogleFonts.orbitron(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.crimson,
        letterSpacing: 3,
      );

  static TextStyle get headingLarge => GoogleFonts.orbitron(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        color: AppColors.crimson,
        letterSpacing: 4,
        shadows: [
          Shadow(color: AppColors.emberGlow.withOpacity(0.5), blurRadius: 20),
        ],
      );

  static TextStyle get subtitle => GoogleFonts.rajdhani(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
        letterSpacing: 4,
      );

  static TextStyle get body => GoogleFonts.rajdhani(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMuted => GoogleFonts.rajdhani(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get label => GoogleFonts.rajdhani(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDim,
        letterSpacing: 2,
      );

  static TextStyle get button => GoogleFonts.orbitron(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 2,
      );

  static TextStyle get cardTitle => GoogleFonts.orbitron(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.crimson,
        letterSpacing: 1.5,
      );

  static TextStyle get cardBody => GoogleFonts.rajdhani(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );
}

// ═══════════════════════════════════════════
//  DECORATIONS & WIDGETS
// ═══════════════════════════════════════════

class AppDecorations {
  /// Glowing card with crimson border
  static BoxDecoration glowCard({Color? glowColor, double glowIntensity = 0.3}) {
    final glow = glowColor ?? AppColors.crimson;
    return BoxDecoration(
      gradient: AppColors.cardGradient,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: glow.withOpacity(0.4),
        width: 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: glow.withOpacity(glowIntensity),
          blurRadius: 20,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: glow.withOpacity(glowIntensity * 0.5),
          blurRadius: 40,
          spreadRadius: -5,
        ),
      ],
    );
  }

  /// Input field decoration
  static InputDecoration inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.rajdhani(
        color: AppColors.textDim,
        fontSize: 16,
        letterSpacing: 1,
      ),
      prefixIcon: icon != null
          ? Icon(icon, color: AppColors.crimson.withOpacity(0.7), size: 20)
          : null,
      filled: true,
      fillColor: AppColors.bgSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.bloodRed.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.crimson, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade900),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  /// Primary action button
  static ButtonStyle primaryButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.crimson,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 8,
      shadowColor: AppColors.crimson.withOpacity(0.5),
    );
  }

  /// Gradient background scaffold
  static BoxDecoration scaffoldGradient() {
    return const BoxDecoration(
      gradient: AppColors.bgGradient,
    );
  }
}

// ═══════════════════════════════════════════
//  REUSABLE WIDGETS
// ═══════════════════════════════════════════

/// A glowing divider
class GlowDivider extends StatelessWidget {
  const GlowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.crimson.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

/// Status badge styled as a game rank
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const StatusBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.orbitron(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

/// Gradient AppBar
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLogout;
  final List<Widget>? extraActions;

  const GradientAppBar({
    super.key,
    required this.title,
    this.onLogout,
    this.extraActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0505), Color(0xFF0A0A0A)],
        ),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF3D0000),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (Navigator.canPop(context))
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.crimson.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.crimson.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.crimson,
                      size: 18,
                    ),
                  ),
                ),
              if (Navigator.canPop(context)) const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.crimson,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (extraActions != null) ...extraActions!,
              if (onLogout != null)
                GestureDetector(
                  onTap: onLogout,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.crimson.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.crimson.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.crimson,
                      size: 20,
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
