import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final SupabaseClient client = Supabase.instance.client;
  List<dynamic> approvedNotesheets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApprovedNotesheets();
  }

  Future<void> fetchApprovedNotesheets() async {
    try {
      final response = await client
          .from('notesheets')
          .select()
          .eq('status', 'final_approved'); 

      setState(() {
        approvedNotesheets = response;
        isLoading = false;
      });
    } catch (e) {
      print('Fetch error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading approved notesheets')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }
   Future<void> handleLogout() async {
    try {
      await client.auth.signOut();

      if (mounted) {
        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginPage()),); 
      }
    } catch (e) {
      print('Logout failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Approved Notesheets'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.redAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: handleLogout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
          : approvedNotesheets.isEmpty
              ? const Center(
                  child: Text(
                    'No notesheets approved yet.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: approvedNotesheets.length,
                  itemBuilder: (context, index) {
                    final sheet = approvedNotesheets[index];
                    return Card(
                      color: const Color(0xFF1A1A1A),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          sheet['date'].toString().split('T')[0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sheet['venue'] ?? 'venue',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              sheet['content'] ?? 'content',
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
