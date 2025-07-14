import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_page.dart';
import 'reviewer_page.dart';
import 'hod_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '', password = '', role = 'student';
  bool isLoading = false;
  bool isLoggedIn = false;

  void _login() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
      isLoggedIn = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged in as $role")),
    );

    if (role == 'student') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => StudentPage()));
    } else if (role.startsWith('reviewer')) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewerPage(reviewerId: role)));
    } else if (role == 'hod') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const HodDashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoggedIn ? "$role Dashboard" : "Notesheet Login"),
        backgroundColor: Colors.black,
      ),
      body: isLoggedIn ? _buildDashboard() : _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, Colors.pink.shade900, Colors.purple.shade900],
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Notesheet Login", style: TextStyle(fontSize: 24, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            ),
                            child: const Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          onPressed: _showNotesheetForm,
          icon: const Icon(Icons.add),
          label: const Text("Submit Notesheet"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
        ),
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
          borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.3)),
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
        items: ['student', 'reviewer1', 'reviewer2', 'hod']
            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
            .toList(),
        onChanged: (val) => setState(() => role = val!),
      ),
    );
  }

  void _showNotesheetForm() {
    final formKey = GlobalKey<FormState>();
    String event = '', organizer = '', venue = '', notes = '';
    String type = 'Seminar';
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Submit Notesheet", style: TextStyle(color: Colors.pinkAccent)),
        content: StatefulBuilder(
          builder: (context, setModalState) => SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildInput("Event", (val) => event = val),
                  const SizedBox(height: 10),
                  _buildInput("Organizer", (val) => organizer = val),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: type,
                    decoration: _decoration("Type"),
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.pinkAccent),
                    items: ['Seminar', 'Workshop', 'Cultural', 'Sports']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (val) => setModalState(() => type = val!),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setModalState(() => selectedDate = picked);
                          },
                          child: Text(selectedDate == null
                              ? "Pick Date"
                              : selectedDate!.toLocal().toString().split(' ')[0]),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) setModalState(() => selectedTime = picked);
                          },
                          child: Text(selectedTime == null
                              ? "Pick Time"
                              : selectedTime!.format(context)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildInput("Venue", (val) => venue = val),
                  const SizedBox(height: 10),
                  _buildInput("Additional Notes", (val) => notes = val, maxLines: 3),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Submit"),
            onPressed: () async {
              if (formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
                await FirebaseFirestore.instance.collection('notesheets').add({
                  'eventName': event,
                  'organizer': organizer,
                  'type': type,
                  'venue': venue,
                  'notes': notes,
                  'submittedBy': email,
                  'date': selectedDate!.toIso8601String(),
                  'time': selectedTime!.format(context),
                  'status': 'pending_r1',
                  'reviewer': 'reviewer1',
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notesheet submitted!")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fill all fields")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInput(String label, Function(String) onChanged, {int maxLines = 1}) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: _decoration(label),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      onChanged: onChanged,
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.pinkAccent),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pinkAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.3)),
      ),
    );
  }
}
