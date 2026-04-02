import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/appwrite_service.dart';
import '../main.dart';

class ReviewerPage extends StatefulWidget {
  const ReviewerPage({super.key});

  @override
  State<ReviewerPage> createState() => _ReviewerPageState();
}

class _ReviewerPageState extends State<ReviewerPage>
    with SingleTickerProviderStateMixin {
  bool _loading = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  List<Map<String, dynamic>> _notesheets = [];
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    if (demoMode) {
      setState(() {
        _notesheets = [
          {
            'id': '1',
            'student_id': 'STU-0042',
            'venue': 'Auditorium A',
            'date': '2026-03-20T00:00:00',
            'content': 'Request for annual cultural fest budget allocation and venue setup',
            'status': 'pending_review',
          },
        ];
        _loading = false;
      });
      return;
    }

    try {
      final docs = await AppwriteService.getNotesheetsByStatus('pending');
      if (mounted) {
        setState(() {
          _notesheets = docs.map((doc) => {
            'id': doc.$id,
            'student_id': doc.data['userId'], // Or fetch profile to get name
            'date': doc.data['date'],
            'venue': doc.data['venue'],
            'content': doc.data['content'],
            'status': doc.data['status'],
          }).toList();
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _approveSheet(int index) async {
    final sheet = _notesheets[index];
    if (demoMode) {
      setState(() => _notesheets.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demo: Approved')));
      return;
    }

    try {
      await AppwriteService.updateNotesheetStatus(sheet['id'], 'reviewer_approved');
      setState(() => _notesheets.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Approved — forwarded to HOD')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _rejectSheet(int index) async {
    final sheet = _notesheets[index];
    if (demoMode) {
      setState(() => _notesheets.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demo: Rejected')));
      return;
    }

    try {
      await AppwriteService.updateNotesheetStatus(sheet['id'], 'rejected');
      setState(() => _notesheets.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rejected and removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Reviewer',
        onLogout: () => Navigator.pop(context),
        extraActions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: StatusBadge(
              text: '${_notesheets.length} Pending',
              color: AppColors.pending,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: AppDecorations.scaffoldGradient(),
        child: FadeTransition(
          opacity: _fadeIn,
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.crimson))
              : _notesheets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined,
                              color: AppColors.crimson.withOpacity(0.3), size: 64),
                          const SizedBox(height: 16),
                          Text('ALL CLEAR', style: AppTextStyles.heading),
                          const SizedBox(height: 6),
                          Text('No pending notesheets',
                              style: AppTextStyles.subtitle),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _notesheets.length,
                      itemBuilder: (context, index) {
                        final sheet = _notesheets[index];
                        return _buildQuestCard(sheet, index);
                      },
                    ),
        ),
      ),
    );
  }

  Widget _buildQuestCard(Map<String, dynamic> sheet, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppDecorations.glowCard(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.crimson.withOpacity(0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.crimson,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sheet['student_id'],
                        style: AppTextStyles.cardTitle,
                      ),
                      Text(
                        sheet['date'].toString().split('T')[0],
                        style: AppTextStyles.label.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const StatusBadge(
                  text: 'PENDING',
                  color: AppColors.pending,
                ),
              ],
            ),
            const GlowDivider(),
            // Details
            _detailRow(Icons.location_on_outlined, 'Venue', sheet['venue']),
            const SizedBox(height: 8),
            _detailRow(Icons.article_outlined, 'Content', sheet['content']),
            const SizedBox(height: 18),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _approveSheet(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.approved.withOpacity(0.15),
                      foregroundColor: AppColors.approved,
                      side: BorderSide(
                        color: AppColors.approved.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: Text('APPROVE',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.approved,
                          fontSize: 12,
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _rejectSheet(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rejected.withOpacity(0.15),
                      foregroundColor: AppColors.rejected,
                      side: BorderSide(
                        color: AppColors.rejected.withOpacity(0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: Text('REJECT',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.rejected,
                          fontSize: 12,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textDim, size: 16),
        const SizedBox(width: 8),
        Text('$label: ', style: AppTextStyles.label.copyWith(fontSize: 13)),
        Expanded(
          child: Text(value, style: AppTextStyles.cardBody),
        ),
      ],
    );
  }
}
