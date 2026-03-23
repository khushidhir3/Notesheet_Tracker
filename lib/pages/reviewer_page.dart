import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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

  // Demo data
  final List<Map<String, dynamic>> _notesheets = [
    {
      'id': '1',
      'student_id': 'STU-0042',
      'venue': 'Auditorium A',
      'date': '2026-03-20T00:00:00',
      'content': 'Request for annual cultural fest budget allocation and venue setup',
      'status': 'pending_review',
    },
    {
      'id': '2',
      'student_id': 'STU-0087',
      'venue': 'Seminar Hall B',
      'date': '2026-03-18T00:00:00',
      'content': 'Technical workshop on AI/ML — guest speaker arrangements',
      'status': 'pending_review',
    },
    {
      'id': '3',
      'student_id': 'STU-0115',
      'venue': 'Sports Ground',
      'date': '2026-03-25T00:00:00',
      'content': 'Inter-college cricket tournament logistics and funding',
      'status': 'pending_review',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _approveSheet(int index) {
    setState(() => _notesheets.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.approved, size: 18),
            const SizedBox(width: 8),
            Text('Approved — forwarded to HOD', style: AppTextStyles.body),
          ],
        ),
        backgroundColor: AppColors.bgElevated,
      ),
    );
  }

  void _rejectSheet(int index) {
    setState(() => _notesheets.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.cancel, color: AppColors.rejected, size: 18),
            const SizedBox(width: 8),
            Text('Rejected and removed', style: AppTextStyles.body),
          ],
        ),
        backgroundColor: AppColors.bgElevated,
      ),
    );
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
          child: _notesheets.isEmpty
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
