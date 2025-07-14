import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewerPage extends StatelessWidget {
  final String reviewerId;
  const ReviewerPage({super.key, required this.reviewerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviewer Dashboard - $reviewerId'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notesheets')
            .where('reviewer', isEqualTo: reviewerId)
            .where('status', isGreaterThanOrEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final notesheets = snapshot.data!.docs;
          if (notesheets.isEmpty) {
            return const Center(child: Text("No notesheets to review"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notesheets.length,
            itemBuilder: (context, index) {
              final data = notesheets[index];
              return Card(
                color: Colors.pink.shade900.withOpacity(0.7),
                child: ListTile(
                  title: Text(data['eventName'], style: const TextStyle(color: Colors.white)),
                  subtitle: Text("Organizer: ${data['organizer']}\nStatus: ${data['status']}", style: const TextStyle(color: Colors.white70)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.greenAccent),
                        onPressed: () => _updateNotesheet(data.id, approved: true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        onPressed: () => _updateNotesheet(data.id, approved: false),
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

  void _updateNotesheet(String docId, {required bool approved}) {
    final notesheetRef = FirebaseFirestore.instance.collection('notesheets').doc(docId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(notesheetRef);
      if (!snapshot.exists) return;

      final currentStatus = snapshot['status'];
      final nextReviewer = _getNextReviewer(currentStatus);
      final nextStatus = approved
          ? (nextReviewer != null ? 'pending_${nextReviewer.split('reviewer').last}' : 'approved')
          : 'rejected';

      transaction.update(notesheetRef, {
        'status': nextStatus,
        'reviewer': approved ? nextReviewer ?? 'hod' : reviewerId,
      });
    });
  }

  String? _getNextReviewer(String currentStatus) {
    if (currentStatus == 'pending_r1') return 'reviewer2';
    if (currentStatus == 'pending_r2') return null; // next is hod
    return null;
  }
}
