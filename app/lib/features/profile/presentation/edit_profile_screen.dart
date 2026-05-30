// lib/features/profile/presentation/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/ns_snackbar.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../auth/data/auth_repository_impl.dart';
import '../../auth/domain/user_entity.dart';
import '../data/profile_remote_source.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedAcademicStage = 'grade_8_9';
  String? _selectedCity;
  String? _selectedCareerClarity;
  bool _isLoading = false;

  static const _academicStages = {
    'grade_8_9': 'Grade 8-9',
    'grade_10': 'Grade 10',
    'grade_11_12_science': 'Grade 11-12 (Science)',
    'grade_11_12_commerce': 'Grade 11-12 (Commerce)',
    'grade_11_12_arts': 'Grade 11-12 (Arts)',
    'college_year_1_2': 'College Year 1-2',
  };

  static const _careerClarityOptions = {
    'clear': 'Clear about my career',
    'few_options': 'Have a few options in mind',
    'none': 'No idea at all',
    'wants_to_explore': 'Want to explore more',
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      _nameController.text = user.fullName ?? '';
      _phoneController.text = user.phone ?? '';
      if (user.studentProfile != null) {
        _selectedAcademicStage =
            user.studentProfile!.academicStage;
        _selectedCity = user.studentProfile!.city;
        _selectedCareerClarity = user.studentProfile!.careerClarity;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Update user name/phone
      final profileSource = ref.read(profileRemoteSourceProvider);
      await profileSource.updateUserProfile(
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      // Update student profile
      final authRepo = ref.read(authRepositoryProvider);
      await authRepo.updateStudentProfile(
        StudentProfileEntity(
          academicStage: _selectedAcademicStage,
          city: _selectedCity,
          careerClarity: _selectedCareerClarity,
        ),
      );

      ref.invalidate(currentUserProvider);

      if (mounted) {
        NSSnackbar.showSuccess(context, 'Profile updated successfully!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        NSSnackbar.showError(context, 'Failed to update profile: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Academic Stage
              DropdownButtonFormField<String>(
                value: _selectedAcademicStage,
                decoration: const InputDecoration(
                  labelText: 'Academic Stage',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                items: _academicStages.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedAcademicStage = v);
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Career Clarity
              DropdownButtonFormField<String>(
                value: _selectedCareerClarity,
                decoration: const InputDecoration(
                  labelText: 'Career Clarity',
                  prefixIcon: Icon(Icons.lightbulb_outline_rounded),
                ),
                items: _careerClarityOptions.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _selectedCareerClarity = v),
              ),
              const SizedBox(height: AppSpacing.xl),

              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
