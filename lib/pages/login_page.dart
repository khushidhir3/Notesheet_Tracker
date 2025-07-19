import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_page.dart';
import 'student_page.dart';
import 'reviewer_page.dart';
import 'hod_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final supabase = Supabase.instance.client;
  bool _loading = false;
  String? _errorText;

  Future<void> login() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        setState(() {
          _errorText = 'Login failed. Try again.';
          _loading = false;
        });
        return;
      }

      final roleResponse = await supabase
          .from('users')
          .select('role')
          .eq('id', user.id)
          .single();

      final role = roleResponse['role'];

      switch (role) {
        case 'student':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const StudentPage()));
          break;
        case 'reviewer':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const ReviewerPage()));
          break;
        case 'hod':
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) =>const HodDashboardPage()));
          break;
        default:
          setState(() {
            _errorText = 'Invalid user role.';
          });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorText = e.message;
      });
    } catch (e) {
      setState(() {
        _errorText = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const maroon = Color(0xFF800000);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: maroon,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'NOTESHEET SYSTEM',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: maroon),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (_errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.white60),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: maroon),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: maroon),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white60),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: maroon),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: maroon),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: maroon,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpPage()),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(color: maroon),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
