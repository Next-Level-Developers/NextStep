// lib/features/auth/presentation/widgets/phone_otp_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/ns_button.dart';
import '../../../../core/widgets/ns_snackbar.dart';
import '../auth_provider.dart';

class PhoneOtpSheet extends ConsumerStatefulWidget {
  const PhoneOtpSheet({super.key});

  @override
  ConsumerState<PhoneOtpSheet> createState() => _PhoneOtpSheetState();
}

class _PhoneOtpSheetState extends ConsumerState<PhoneOtpSheet> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _verificationId;
  bool _isOtpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final phone = _phoneController.text.trim();
    // Prepend +91 if user didn't write it
    final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';

    await ref.read(authNotifierProvider.notifier).sendPhoneOtp(
      formattedPhone,
      onCodeSent: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _isOtpSent = true;
          _isLoading = false;
        });
        NSSnackbar.showSuccess(context, 'OTP sent successfully!');
      },
      onFailed: (error) {
        setState(() => _isLoading = false);
        NSSnackbar.showError(context, error);
      },
    );
  }

  void _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      NSSnackbar.showError(context, 'Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signInWithPhone(_verificationId!, otp);
      if (mounted) {
        Navigator.pop(context);
        NSSnackbar.showSuccess(context, 'Signed in successfully!');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        NSSnackbar.showError(context, 'Invalid OTP. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.lg + viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.outlineMedium,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _isOtpSent ? 'Enter OTP' : 'Sign in with Phone',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _isOtpSent
                  ? 'We have sent a 6-digit verification code to ${_phoneController.text}'
                  : 'Enter your phone number to receive a one-time password',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            if (!_isOtpSent) ...[
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: Validators.validatePhone,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+91 ',
                  counterText: '',
                  prefixIcon: Icon(Icons.phone_iphone_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              NSButton.primary(
                label: 'Send OTP',
                onPressed: _sendOtp,
                isLoading: _isLoading,
              ),
            ] else ...[
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                autofocus: true,
                style: const TextStyle(
                  letterSpacing: 8.0,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: '6-digit OTP',
                  counterText: '',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              NSButton.primary(
                label: 'Verify & Sign In',
                onPressed: _verifyOtp,
                isLoading: _isLoading,
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isOtpSent = false;
                    _otpController.clear();
                  });
                },
                child: const Text('Change Phone Number'),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
