import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/appwrite_service.dart';
import '../main.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  List<Map<String, dynamic>> _approvedNotesheets = [];
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
    if (demoMode) {
      setState(() {
        _approvedNotesheets = [
          {
            'id': '1',
            'date': '2026-03-15T00:00:00',
            'venue': 'Auditorium A',
            'content': 'Annual cultural fest budget allocation — approved by HOD',
            'status': 'final_approved',
          },
        ];
        _loading = false;
      });
      return;
    }

    try {
      final docs = await AppwriteService.getUserNotesheets();
      if (mounted) {
        setState(() {
          _approvedNotesheets = docs
              .where((doc) => doc.data['status'] == 'final_approved')
              .map((doc) => {
                    'id': doc.$id,
                    'date': doc.data['date'],
                    'venue': doc.data['venue'],
                    'content': doc.data['content'],
                    'status': doc.data['status'],
                  })
              .toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Approved Archive',
        onLogout: () => Navigator.pop(context),
        extraActions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: StatusBadge(
              text: '${_approvedNotesheets.length} Approved',
              color: AppColors.approved,
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
              // Achievement header
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                padding: const EdgeInsets.all(18),
                decoration: AppDecorations.glowCard(
                  glowColor: AppColors.approved,
                  glowIntensity: 0.15,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.approved.withOpacity(0.1),
                        border: Border.all(
                          color: AppColors.approved.withOpacity(0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.approved.withOpacity(0.2),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.emoji_events_rounded,
                          color: AppColors.approved, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACHIEVEMENTS UNLOCKED',
                            style: AppTextStyles.cardTitle.copyWith(
                              color: AppColors.approved,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_approvedNotesheets.length} notesheets approved',
                            style: AppTextStyles.label,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '${_approvedNotesheets.length}',
                          style: AppTextStyles.heading.copyWith(
                            color: AppColors.approved,
                            fontSize: 28,
                            shadows: [
                              Shadow(
                                color: AppColors.approved.withOpacity(0.5),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        Text('TOTAL', style: AppTextStyles.label.copyWith(fontSize: 9)),
                      ],
                    ),
                  ],
                ),
              ),
              // List
              Expanded(
                child: _loading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.approved))
                  : _approvedNotesheets.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_outlined,
                                color: AppColors.crimson.withOpacity(0.3),
                                size: 64),
                            const SizedBox(height: 16),
                            Text('NO ACHIEVEMENTS', style: AppTextStyles.heading),
                            const SizedBox(height: 6),
                            Text('No approved notesheets yet',
                                style: AppTextStyles.subtitle),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _approvedNotesheets.length,
                        itemBuilder: (context, index) {
                          return _buildAchievementCard(
                              _approvedNotesheets[index], index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> sheet, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: AppDecorations.glowCard(
        glowColor: AppColors.approved,
        glowIntensity: 0.12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rank number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.approved.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.approved.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  '#${index + 1}',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.approved,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sheet['date'].toString().split('T')[0],
                          style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.approved,
                          ),
                        ),
                      ),
                      const StatusBadge(
                        text: 'APPROVED',
                        color: AppColors.approved,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: AppColors.textDim, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        sheet['venue'] ?? 'N/A',
                        style: AppTextStyles.label.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sheet['content'] ?? '',
                    style: AppTextStyles.cardBody,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
