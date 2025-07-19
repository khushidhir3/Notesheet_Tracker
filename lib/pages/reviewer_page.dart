import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewerPage extends StatefulWidget {
  const ReviewerPage({super.key});

  @override
  State<ReviewerPage> createState() => _ReviewerPageState();
}

class _ReviewerPageState extends State<ReviewerPage> {
  final SupabaseClient client = Supabase.instance.client;
  List<dynamic> notesheets = [];
  bool _loading = false;

  final Color maroon = const Color(0xFF800000);

  @override
  void initState() {
    super.initState();
    _fetchPendingNotesheets();
  }

  Future<void> _fetchPendingNotesheets() async {
    setState(() => _loading = true);
    try {
      final response = await client
          .from('notesheets')
          .select()
          .eq('status', 'pending_review');

      setState(() => notesheets = response);
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching notesheets: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updateStatus(String id, String status, int index) async {
  try {
    await client.from('notesheets').update({'status': status}).eq('id', id);
    setState(() {
      notesheets.removeAt(index);
    });
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }
}

Future<void> _deleteNoteSheet(String id) async {
  final response = await client
      .from('notesheets')
      .delete()
      .eq('id', id);

  // Optionally, handle errors with logging or user feedback
  // if (response.error != null) {
  //   debugPrint('Error deleting notesheet: ${response.error!.message}');
  // } else {
  //   debugPrint('Notesheet deleted successfully');
  // }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Reviewer Dashboard'),
        backgroundColor: maroon,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: maroon))
          : notesheets.isEmpty
              ? const Center(
                  child: Text(
                    'No pending notesheets',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: notesheets.length,
                  itemBuilder: (context, index) {
                    final sheet = notesheets[index];
                    return Card(
                      color: Colors.white12,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: maroon),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoText('Student ID', sheet['student_id']),
                            _infoText('Venue', sheet['venue']),
                            _infoText('Date', sheet['date'].toString().split('T')[0]),
                            _infoText('Content', sheet['content']),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _updateStatus(
                                      sheet['id'], 'approved', index),
                                  icon: const Icon(Icons.check),
                                  label: const Text('Approve'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: maroon,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    final id = sheet['id']?.toString();
                                    if (id == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Invalid sheet ID')),
                                      );
                                      return;
                                    }
                                    _updateStatus(id, 'rejected', index);
                                    _deleteNoteSheet(id);
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text('Reject'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _infoText(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$title: $value',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}


