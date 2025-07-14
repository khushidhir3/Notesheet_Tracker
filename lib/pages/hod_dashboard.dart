
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HodDashboard extends StatelessWidget {
  const HodDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOD Dashboard'),
        backgroundColor: Colors.pinkAccent,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notesheets')
            .where('status', isEqualTo: 'pending_hod')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return const Center(child: Text('No notesheets pending for HOD.', style: TextStyle(color: Colors.white70)));

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
                  subtitle: Text("Organizer: ${data['organizer']}\nVenue: ${data['venue']}\nReviewer: ${data['reviewer']}",
                      style: const TextStyle(color: Colors.white70)),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.greenAccent),
                        onPressed: () => _updateStatus(doc.id, 'pending_admin'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
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

  void _updateStatus(String docId, String newStatus) {
    FirebaseFirestore.instance.collection('notesheets').doc(docId).update({'status': newStatus});
  }
}
