
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notesheets')
            .where('status', isEqualTo: 'pending_admin')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text('No notesheets pending for Admin.', style: TextStyle(color: Colors.white70)));

          final notesheets = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notesheets.length,
            itemBuilder: (context, index) {
              final doc = notesheets[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.pink.shade900.withOpacity(0.7),
                child: ListTile(
                  title: Text(data['eventName'] ?? '', style: const TextStyle(color: Colors.white)),
                  subtitle: Text(
                    "Organizer: ${data['organizer']}\nVenue: ${data['venue']}\nCreated By: ${data['createdBy']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                        onPressed: () => _updateStatus(doc.id, 'approved'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.redAccent),
                        onPressed: () => _updateStatus(doc.id, 'rejected'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateStatus(String docId, String status) {
    FirebaseFirestore.instance.collection('notesheets').doc(docId).update({'status': status});
  }
}
