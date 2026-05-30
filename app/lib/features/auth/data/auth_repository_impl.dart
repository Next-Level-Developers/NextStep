// lib/features/auth/data/auth_repository_impl.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/auth/firebase_auth_service.dart';
import '../../../core/auth/token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';
import 'auth_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;

  AuthRepositoryImpl(this._remoteSource);

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    final firebaseToken = await FirebaseAuthService.signInWithEmail(
      email: email,
      password: password,
    );
    return exchangeFirebaseToken(firebaseToken);
  }

  @override
  Future<UserEntity> signUpWithEmail(String email, String password) async {
    // Note: Django API also needs to map the Firebase registration to a profile,
    // which it does when exchanging the token if `is_new_user` is true or automatically on verification.
    final firebaseToken = await FirebaseAuthService.signUpWithEmail(
      email: email,
      password: password,
      fullName: '', // Can update this later using PATCH /users/me/
    );
    return exchangeFirebaseToken(firebaseToken);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    final firebaseToken = await FirebaseAuthService.signInWithGoogle();
    if (firebaseToken == null) {
      throw Exception('Google sign in was cancelled');
    }
    return exchangeFirebaseToken(firebaseToken);
  }

  @override
  Future<void> sendPhoneOtp(
    String phone, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
  }) async {
    await FirebaseAuthService.verifyPhoneNumber(
      phoneNumber: phone,
      onCodeSent: (verificationId, _) => onCodeSent(verificationId),
      onAutoVerified: (_) {},
      onFailed: (e) => onFailed(FirebaseAuthService.mapFirebaseError(e.code)),
    );
  }

  @override
  Future<UserEntity> signInWithPhone(String verificationId, String smsCode) async {
    final firebaseToken = await FirebaseAuthService.signInWithPhoneOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return exchangeFirebaseToken(firebaseToken);
  }

  @override
  Future<void> signOut() async {
    await FirebaseAuthService.signOut();
    await TokenStorage.clearAll();
    
    // Clear Hive boxes if needed
    try {
      await Hive.deleteFromDisk();
    } catch (_) {
      // Ignore if Hive deletion fails or isn't initialized fully
    }

    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Future<UserEntity> exchangeFirebaseToken(String idToken) async {
    final responseData = await _remoteSource.exchangeFirebaseToken(idToken);
    final access = responseData['access'] as String;
    final refresh = responseData['refresh'] as String;
    
    // Save tokens securely
    await TokenStorage.saveTokenPair(access: access, refresh: refresh);

    // Extract User object from data
    final userData = responseData['user'] as Map<String, dynamic>;
    return UserEntity.fromJson(userData);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    return _remoteSource.getCurrentUser();
  }

  @override
  Future<StudentProfileEntity> updateStudentProfile(StudentProfileEntity profile) async {
    return _remoteSource.updateStudentProfile(profile);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteSource = ref.watch(authRemoteSourceProvider);
  return AuthRepositoryImpl(remoteSource);
});
