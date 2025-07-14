import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'notesheet_page.dart';

class DashboardPage extends StatelessWidget {
  final AppUser user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user.role.toUpperCase()} Dashboard"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome, ${user.email}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 30),

            // Student Notesheet Button
            if (user.role == 'student')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotesheetPage(user: user)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                ),
                child: const Text("Submit Notesheet"),
              ),

            // Reviewer or HOD dummy content
            if (user.role == 'reviewer' || user.role == 'hod')
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "You have access to all submissions.",
                  style: const TextStyle(fontSize: 16, color: Colors.pinkAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
