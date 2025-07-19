import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _notesheetController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  DateTime? _selectedDate;

  final SupabaseClient client = Supabase.instance.client;

  final Color maroon = const Color(0xFF800000);

  bool _loading = false;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: maroon,
              onPrimary: Colors.black,
              surface: Colors.black,
              onSurface: maroon,
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  } 
  Future<void> _submitNotesheet() async {
  if (!_formKey.currentState!.validate()) return;

  final user = client.auth.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to submit')),
    );
    return;
  }

  if (_selectedDate == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a date')),
    );
    return;
  }

  setState(() => _loading = true);

  try {
    final response = await client.from('notesheets').insert({
      'student_id': user.id,
      'date': _selectedDate!.toIso8601String(),
      'venue': _venueController.text.trim(),
      'content': _notesheetController.text.trim(),
      'status': 'pending_review',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted successfully, pending review!')),
    );

    _notesheetController.clear();
    _venueController.clear();
    setState(() => _selectedDate = null);
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unexpected error: $error')),
    );
  } finally {
    setState(() => _loading = false);
  }
}










   @override
   Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'Select Date'
        : _selectedDate!.toLocal().toString().split(' ')[0];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: maroon,
        title: const Text('Student Notesheet Form'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Date picker
                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: maroon),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white12,
                    ),
                    child: Text(
                      dateText,
                      style: TextStyle(color: maroon, fontSize: 18),
                    ),
                  ),
                ),
                if (_selectedDate == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 6, left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Date is required', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                const SizedBox(height: 24),

                // Venue input
                TextFormField(
                  controller: _venueController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Venue',
                    hintStyle: const TextStyle(color: Colors.white60),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: maroon),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: maroon),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white12,
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Venue is required' : null,
                ),
                const SizedBox(height: 24),

                // Notesheet content input
                TextFormField(
                  controller: _notesheetController,
                  maxLines: 8,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter your notesheet idea',
                    hintStyle: const TextStyle(color: Colors.white60),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: maroon),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: maroon),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white12,
                  ),
                  validator: (val) =>
                      val == null || val.trim().isEmpty ? 'Notesheet content is required' : null,
                ),
                const SizedBox(height: 32),

                // Submit button
                _loading
                    ? CircularProgressIndicator(color: maroon)
                    : ElevatedButton(
                        onPressed: _submitNotesheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: maroon,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Submit to Reviewer',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
