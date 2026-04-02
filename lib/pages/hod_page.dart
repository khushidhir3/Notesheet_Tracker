import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/appwrite_service.dart';
import '../main.dart';

class HodDashboardPage extends StatefulWidget {
  const HodDashboardPage({super.key});

  @override
  State<HodDashboardPage> createState() => _HodDashboardPageState();
}

class _HodDashboardPageState extends State<HodDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  List<Map<String, dynamic>> _approvedSheets = [];
  bool _loading = true;

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
        _approvedSheets = [
          {
            'id': '1',
            'student_id': 'STU-0042',
            'content': 'Request for annual cultural fest budget allocation and venue setup',
            'venue': 'Auditorium A',
            'date': '2026-03-20T00:00:00',
            'status': 'approved',
          },
        ];
        _loading = false;
      });
      return;
    }

    try {
      final docs = await AppwriteService.getNotesheetsByStatus('reviewer_approved');
      if (mounted) {
        setState(() {
          _approvedSheets = docs.map((doc) => {
            'id': doc.$id,
            'student_id': doc.data['userId'],
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

  void _handleApproval(int index, bool isApproved) async {
    final sheet = _approvedSheets[index];
    if (demoMode) {
      setState(() => _approvedSheets.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Demo: ${isApproved ? 'Approved' : 'Rejected'}')));
      return;
    }

    try {
      final newStatus = isApproved ? 'final_approved' : 'rejected';
      await AppwriteService.updateNotesheetStatus(sheet['id'], newStatus);
      setState(() => _approvedSheets.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isApproved ? 'Final approval granted' : 'Rejected by HOD')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'HOD — Final Authority',
        onLogout: () => Navigator.pop(context),
        extraActions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: StatusBadge(
              text: '${_approvedSheets.length} Awaiting',
              color: AppColors.crimson,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: AppDecorations.scaffoldGradient(),
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            children: [
              // Stats bar
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: AppDecorations.glowCard(
                  glowColor: AppColors.bloodRed,
                  glowIntensity: 0.15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _statItem('PENDING', '${_approvedSheets.length}', AppColors.pending),
                    Container(
                      width: 1,
                      height: 30,
                      color: AppColors.bloodRed.withOpacity(0.3),
                    ),
                    _statItem('APPROVED', '12', AppColors.approved),
                    Container(
                      width: 1,
                      height: 30,
                      color: AppColors.bloodRed.withOpacity(0.3),
                    ),
                    _statItem('REJECTED', '3', AppColors.rejected),
                  ],
                ),
              ),
              // List
              Expanded(
                child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.bloodRed))
                  : _approvedSheets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_outlined,
                                color: AppColors.crimson.withOpacity(0.3), size: 64),
                            const SizedBox(height: 16),
                            Text('ALL REVIEWED', style: AppTextStyles.heading),
                            const SizedBox(height: 6),
                            Text('No pending approvals',
                                style: AppTextStyles.subtitle),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _approvedSheets.length,
                        itemBuilder: (context, index) {
                          return _buildCard(_approvedSheets[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heading.copyWith(
            fontSize: 22,
            color: color,
            shadows: [Shadow(color: color.withOpacity(0.5), blurRadius: 10)],
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.label.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> sheet, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppDecorations.glowCard(glowColor: AppColors.bloodRed),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bloodRed.withOpacity(0.15),
                    border: Border.all(
                      color: AppColors.bloodRed.withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.bloodRed.withOpacity(0.2),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.gavel_rounded,
                      color: AppColors.crimson, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sheet['student_id'],
                          style: AppTextStyles.cardTitle),
                      Text(
                        sheet['date'].toString().split('T')[0],
                        style: AppTextStyles.label.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const StatusBadge(
                  text: 'REVIEW APPROVED',
                  color: AppColors.pending,
                ),
              ],
            ),
            const GlowDivider(),
            // Content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.article_outlined,
                    color: AppColors.textDim, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sheet['content'] ?? 'No content',
                    style: AppTextStyles.cardBody,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.textDim, size: 16),
                const SizedBox(width: 8),
                Text(sheet['venue'] ?? '', style: AppTextStyles.cardBody),
              ],
            ),
            const SizedBox(height: 18),
            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApproval(index, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.approved.withOpacity(0.12),
                      foregroundColor: AppColors.approved,
                      side: BorderSide(
                          color: AppColors.approved.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.verified_rounded, size: 18),
                    label: Text('FINAL APPROVE',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.approved,
                          fontSize: 11,
                        )),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApproval(index, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rejected.withOpacity(0.12),
                      foregroundColor: AppColors.rejected,
                      side: BorderSide(
                          color: AppColors.rejected.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    label: Text('REJECT',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.rejected,
                          fontSize: 11,
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
}
