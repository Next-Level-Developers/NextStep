// lib/features/auth/presentation/auth_provider.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/auth/firebase_auth_service.dart';
import '../../../core/auth/token_storage.dart';
import '../data/auth_repository_impl.dart';
import '../domain/user_entity.dart';

part 'auth_provider.g.dart';

/// Stream of the current Firebase user session.
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return FirebaseAuthService.authStateChanges;
}

/// Fetches and caches the current User profile from the Django backend.
/// Only fires if Firebase is authenticated and an access token exists.
@riverpod
Future<UserEntity?> currentUser(CurrentUserRef ref) async {
  final authState = ref.watch(authStateProvider).value;
  if (authState == null) return null;

  final hasAccess = await TokenStorage.hasAccessToken();
  if (!hasAccess) return null;

  final repo = ref.watch(authRepositoryProvider);
  return repo.getCurrentUser();
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<void> build() {}

  /// Signs in using email and password.
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithEmail(email, password);
      // Invalidate current user to trigger fresh profile fetch
      ref.invalidate(currentUserProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Signs up using email and password.
  Future<void> signUp(String email, String password, String fullName) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.signUpWithEmail(email, password);
      
      // Update full name in backend
      await repo.updateStudentProfile(
        StudentProfileEntity(
          academicStage: 'grade_8_9', // default placeholder
        ),
      );
      
      ref.invalidate(currentUserProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Signs in using Google Sign-In.
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithGoogle();
      ref.invalidate(currentUserProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Sends OTP to the provided phone number.
  Future<void> sendPhoneOtp(
    String phone, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
  }) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendPhoneOtp(
        phone,
        onCodeSent: onCodeSent,
        onFailed: onFailed,
      );
    } catch (e) {
      onFailed(e.toString());
    }
  }

  /// Verifies OTP and signs in.
  Future<void> signInWithPhone(String verificationId, String smsCode) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithPhone(verificationId, smsCode);
      ref.invalidate(currentUserProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Signs out of all sessions.
  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
      ref.invalidate(currentUserProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
