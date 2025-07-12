import 'package:flutter/material.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '', role = 'student';
  bool isLoading = false;

  void _login() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged in as $role")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Colors.pink.shade900,
                  Colors.purple.shade900
                ],
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 350,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          "Notesheet Login",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField("Email", false, (val) => email = val),
                        const SizedBox(height: 15),
                        _buildTextField("Password", true, (val) => password = val),
                        const SizedBox(height: 15),
                        _buildDropdown(),
                        const SizedBox(height: 20),
                        isLoading
                            ? const CircularProgressIndicator(color: Colors.pinkAccent)
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, bool obscureText, Function(String) onChanged) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.pinkAccent),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.pinkAccent),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: role,
        dropdownColor: Colors.black,
        iconEnabledColor: Colors.pinkAccent,
        style: const TextStyle(color: Colors.pinkAccent),
        underline: const SizedBox(),
        items: ['student', 'reviewer1', 'reviewer2', 'hod', 'admin']
            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
            .toList(),
        onChanged: (val) => setState(() => role = val!),
      ),
    );
  }
}
