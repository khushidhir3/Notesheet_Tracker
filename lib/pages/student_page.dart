import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _notesheetController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  DateTime? _selectedDate;
  bool _loading = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    _notesheetController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.crimson,
              onPrimary: Colors.black,
              surface: AppColors.bgCard,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.bgDark,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _demoSubmit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a date', style: AppTextStyles.body),
          backgroundColor: AppColors.bgElevated,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _loading = false;
          _notesheetController.clear();
          _venueController.clear();
          _selectedDate = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.approved, size: 18),
                const SizedBox(width: 8),
                Text('Submitted successfully!', style: AppTextStyles.body),
              ],
            ),
            backgroundColor: AppColors.bgElevated,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'SELECT DATE'
        : _selectedDate!.toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Student Form',
        onLogout: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: AppDecorations.scaffoldGradient(),
        child: FadeTransition(
          opacity: _fadeIn,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Header ──
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.crimson.withOpacity(0.1),
                            border: Border.all(
                              color: AppColors.crimson.withOpacity(0.3),
                            ),
                          ),
                          child: const Icon(Icons.edit_note_rounded,
                              color: AppColors.crimson, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('NEW NOTESHEET',
                                style: AppTextStyles.cardTitle),
                            Text('Submit your request',
                                style: AppTextStyles.label),
                          ],
                        ),
                      ],
                    ),
                    const GlowDivider(),

                    // ── Form Card ──
                    Container(
                      decoration: AppDecorations.glowCard(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Date picker
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: AppColors.bgSurface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _selectedDate != null
                                      ? AppColors.crimson.withOpacity(0.5)
                                      : AppColors.bloodRed.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: _selectedDate != null
                                        ? AppColors.crimson
                                        : AppColors.textDim,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    dateText,
                                    style: _selectedDate != null
                                        ? AppTextStyles.body
                                        : AppTextStyles.label,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Venue
                          TextFormField(
                            controller: _venueController,
                            style: AppTextStyles.body,
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Venue is required'
                                    : null,
                            decoration: AppDecorations.inputDecoration(
                              'Venue',
                              icon: Icons.location_on_outlined,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Content
                          TextFormField(
                            controller: _notesheetController,
                            maxLines: 6,
                            style: AppTextStyles.body,
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                    ? 'Content is required'
                                    : null,
                            decoration: AppDecorations.inputDecoration(
                              'Enter your notesheet idea...',
                              icon: Icons.description_outlined,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Submit
                          _loading
                              ? const SizedBox(
                                  height: 52,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.crimson,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: _demoSubmit,
                                  style: AppDecorations.primaryButton(),
                                  icon: const Icon(Icons.send_rounded,
                                      size: 18),
                                  label: Text('SUBMIT TO REVIEWER',
                                      style: AppTextStyles.button
                                          .copyWith(fontSize: 14)),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
