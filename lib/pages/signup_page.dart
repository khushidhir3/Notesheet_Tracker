import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedRole = 'student';
  bool _loading = false;
  String? _errorText;
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  final List<_RoleOption> _roles = [
    _RoleOption('student', 'Student', Icons.school_outlined),
    _RoleOption('reviewer', 'Reviewer', Icons.rate_review_outlined),
    _RoleOption('hod', 'HOD', Icons.gavel_rounded),
    _RoleOption('dashboard', 'Dashboard', Icons.dashboard_outlined),
  ];

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
    _nameController.dispose();
    super.dispose();
  }

  void _demoSignup() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demo mode — signup simulated',
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
                          color: AppColors.emberGlow.withOpacity(0.1),
                          border: Border.all(
                            color: AppColors.emberGlow.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.emberGlow.withOpacity(0.3),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_add_outlined,
                          color: AppColors.emberGlow,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('SIGN UP', style: AppTextStyles.headingLarge),
                      const SizedBox(height: 6),
                      Text('CREATE IDENTITY', style: AppTextStyles.subtitle),
                      const SizedBox(height: 32),
                      // ── Card ──
                      Container(
                        decoration: AppDecorations.glowCard(
                          glowColor: AppColors.emberGlow,
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
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
                              TextFormField(
                                controller: _nameController,
                                style: AppTextStyles.body,
                                validator: (val) => val == null || val.isEmpty
                                    ? 'Enter your name'
                                    : null,
                                decoration: AppDecorations.inputDecoration(
                                  'Name',
                                  icon: Icons.person_outline,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
                                style: AppTextStyles.body,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) => val == null || val.isEmpty
                                    ? 'Enter email'
                                    : null,
                                decoration: AppDecorations.inputDecoration(
                                  'Email',
                                  icon: Icons.email_outlined,
                                ),
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: AppTextStyles.body,
                                validator: (val) =>
                                    val != null && val.length < 8
                                        ? 'Minimum 8 characters'
                                        : null,
                                decoration: AppDecorations.inputDecoration(
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
                              const SizedBox(height: 14),
                              // ── Role Selector ──
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.bgSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppColors.bloodRed.withOpacity(0.3),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 14, top: 10, bottom: 6),
                                      child: Text(
                                        'SELECT CLASS',
                                        style: AppTextStyles.label,
                                      ),
                                    ),
                                    ...List.generate(_roles.length, (i) {
                                      final role = _roles[i];
                                      final selected =
                                          _selectedRole == role.value;
                                      return GestureDetector(
                                        onTap: () => setState(
                                            () => _selectedRole = role.value),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? AppColors.crimson
                                                    .withOpacity(0.15)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: selected
                                                ? Border.all(
                                                    color: AppColors.crimson
                                                        .withOpacity(0.4),
                                                  )
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                role.icon,
                                                color: selected
                                                    ? AppColors.crimson
                                                    : AppColors.textDim,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                role.label,
                                                style: AppTextStyles.body
                                                    .copyWith(
                                                  color: selected
                                                      ? AppColors.crimson
                                                      : AppColors
                                                          .textSecondary,
                                                ),
                                              ),
                                              const Spacer(),
                                              if (selected)
                                                const Icon(
                                                  Icons.check_circle,
                                                  color: AppColors.crimson,
                                                  size: 18,
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
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
                                      onPressed: _demoSignup,
                                      style: AppDecorations.primaryButton(),
                                      child: Text('SIGN UP',
                                          style: AppTextStyles.button),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: AppTextStyles.bodyMuted.copyWith(
                              color: AppColors.textDim,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: AppTextStyles.bodyMuted.copyWith(
                                  color: AppColors.crimson,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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

class _RoleOption {
  final String value;
  final String label;
  final IconData icon;
  _RoleOption(this.value, this.label, this.icon);
}
