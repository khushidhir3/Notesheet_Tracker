import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _formKey = GlobalKey<FormState>();

  String eventName = '', organizer = '', eventType = 'Seminar', venue = '', notes = '';
  DateTime? eventDate;

  final List<String> eventTypes = ['Seminar', 'Workshop', 'Cultural', 'Sports', 'Other'];

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.pinkAccent,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => eventDate = picked);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && eventDate != null) {
      try {
        await FirebaseFirestore.instance.collection('notesheets').add({
          'eventName': eventName,
          'organizer': organizer,
          'eventType': eventType,
          'eventDate': eventDate!.toIso8601String(),
          'venue': venue,
          'notes': notes,
          'status': 'pending_r1',
          'reviewer': 'reviewer1',
          'submittedBy': 'student1@gmail.com', // 👉 isse dynamically set kar sakte ho if you use Firebase Auth
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notesheet submitted successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('Submit Notesheet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Event Name", (val) => eventName = val, true),
              const SizedBox(height: 10),
              _buildTextField("Organizer", (val) => organizer = val, true),
              const SizedBox(height: 10),
              _buildDropdown("Event Type", eventType, eventTypes, (val) => setState(() => eventType = val!)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickDate,
                child: Text(eventDate == null
                    ? "Pick Event Date"
                    : "Date: ${eventDate!.toLocal().toString().split(' ')[0]}"),
              ),
              const SizedBox(height: 10),
              _buildTextField("Venue", (val) => venue = val, true),
              const SizedBox(height: 10),
              _buildTextField("Additional Notes", (val) => notes = val, false, maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.pinkAccent),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent.withOpacity(0.4))),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.pinkAccent)),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, bool isRequired, {int maxLines = 1}) {
    return TextFormField(
      decoration: _decoration(label),
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      validator: isRequired ? (val) => val == null || val.isEmpty ? 'Required' : null : null,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: _decoration(label),
      value: value,
      dropdownColor: Colors.black,
      style: const TextStyle(color: Colors.pinkAccent),
      iconEnabledColor: Colors.pinkAccent,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
