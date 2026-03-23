import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorText;
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _demoLogin() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demo mode — login simulated',
                style: AppTextStyles.body),
            backgroundColor: AppColors.bgElevated,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppDecorations.scaffoldGradient(),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Icon ──
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.crimson.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.crimson.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.crimson.withOpacity(0.3),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.lock_outlined,
                          color: AppColors.crimson,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // ── Title ──
                      Text('LOGIN', style: AppTextStyles.headingLarge),
                      const SizedBox(height: 6),
                      Text(
                        'NOTESHEET SYSTEM',
                        style: AppTextStyles.subtitle,
                      ),
                      const SizedBox(height: 32),
                      // ── Card ──
                      Container(
                        decoration: AppDecorations.glowCard(),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            if (_errorText != null)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.red.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  _errorText!,
                                  style: AppTextStyles.bodyMuted.copyWith(
                                    color: AppColors.rejected,
                                  ),
                                ),
                              ),
                            TextField(
                              controller: _emailController,
                              style: AppTextStyles.body,
                              decoration: AppDecorations.inputDecoration(
                                'Email',
                                icon: Icons.email_outlined,
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              style: AppTextStyles.body,
                              decoration:
                                  AppDecorations.inputDecoration(
                                'Password',
                                icon: Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textDim,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            _loading
                                ? const SizedBox(
                                    height: 52,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.crimson,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _demoLogin,
                                    style: AppDecorations.primaryButton(),
                                    child:
                                        Text('LOGIN', style: AppTextStyles.button),
                                  ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SignUpPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: AppTextStyles.bodyMuted.copyWith(
                              color: AppColors.textDim,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: AppTextStyles.bodyMuted.copyWith(
                                  color: AppColors.crimson,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
