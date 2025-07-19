import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import'login_page.dart';
class HodDashboardPage extends StatefulWidget {
  const HodDashboardPage({super.key});

  @override
  State<HodDashboardPage> createState() => _HodDashboardPageState();
}

class _HodDashboardPageState extends State<HodDashboardPage> {
  final SupabaseClient client = Supabase.instance.client;
  List<dynamic> reviewerApprovedNotesheets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviewerApprovedNotesheets();
  }

  Future<void> fetchReviewerApprovedNotesheets() async {
    try {
      final response = await client
          .from('notesheets')
          .select()
          
          .eq('status', 'approved'); 

      setState(() {
        reviewerApprovedNotesheets = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching notesheets: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading data')),
        );
      }
    }
  }

  Future<void> handleApproval(String id, bool isApproved) async {
    try {
      await client
          .from('notesheets')
          .update({'status': isApproved ? 'final_approved' : 'rejected'})
          .eq('id', id);

      fetchReviewerApprovedNotesheets();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isApproved ? 'Approved' : 'Rejected'),
        ),
      );
    } catch (e) {
      print('Error approving/rejecting: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating status')),
      );
    }
  }
  
  Future<void> handleLogout() async {
    try {
      await client.auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(context, 
         MaterialPageRoute(builder: (context) => LoginPage()),
         );
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
        title: const Text('HOD Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 4,
         actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: handleLogout,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : reviewerApprovedNotesheets.isEmpty
              ? const Center(
                  child: Text(
                    'No notesheets for final approval',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: reviewerApprovedNotesheets.length,
                  itemBuilder: (context, index) {
                    final sheet = reviewerApprovedNotesheets[index];
                    return Card(
                      color: const Color(0xFF2B2B2B),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 6,
                      child: ListTile(
                        
                       title: Text(
            'Submitted by: ${sheet['student_id'] ?? 'Unknown'}',
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),
subtitle: Text(
  'Content: ${sheet['content'] ?? 'No content'}',
  style: const TextStyle(color: Colors.grey),
),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                              onPressed: () => handleApproval(sheet['id'], true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => handleApproval(sheet['id'], false),
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
