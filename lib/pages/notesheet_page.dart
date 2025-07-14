import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class NotesheetPage extends StatefulWidget {
  final AppUser user;

  const NotesheetPage({super.key, required this.user});

  @override
  State<NotesheetPage> createState() => _NotesheetPageState();
}

class _NotesheetPageState extends State<NotesheetPage> {
  final _formKey = GlobalKey<FormState>();

  String eventName = '';
  String organizer = '';
  String venue = '';
  String reviewer = 'reviewer1';

  List<String> reviewers = ['reviewer1', 'reviewer2'];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('notesheets').add({
          'eventName': eventName,
          'organizer': organizer,
          'venue': venue,
          'reviewer': reviewer,
          'submittedBy': widget.user.email,
          'status': 'pending_r1',
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Notesheet submitted to Firebase!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Notesheet"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Event Name", (val) => eventName = val),
              const SizedBox(height: 10),
              _buildTextField("Organizer", (val) => organizer = val),
              const SizedBox(height: 10),
              _buildTextField("Venue", (val) => venue = val),
              const SizedBox(height: 10),
              _buildDropdown("Reviewer", reviewer, reviewers, (val) {
                setState(() => reviewer = val!);
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.pinkAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.pinkAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.3)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
      ),
      dropdownColor: Colors.black,
      value: value,
      style: const TextStyle(color: Colors.pinkAccent),
      iconEnabledColor: Colors.pinkAccent,
      items: items.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
      onChanged: onChanged,
    );
  }
}
