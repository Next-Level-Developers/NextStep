// lib/features/auth/domain/auth_repository.dart
import 'user_entity.dart';

abstract class AuthRepository {
  /// Signs in a user with email and password via Firebase Auth,
  /// then exchanges the token with Django backend.
  Future<UserEntity> signInWithEmail(String email, String password);

  /// Signs up a user with email and password via Firebase Auth,
  /// then exchanges the token with Django backend.
  Future<UserEntity> signUpWithEmail(String email, String password);

  /// Signs in a user with Google Sign-In,
  /// then exchanges the token with Django backend.
  Future<UserEntity> signInWithGoogle();

  /// Verifies phone number by sending OTP.
  Future<void> sendPhoneOtp(
    String phone, {
    required Function(String verificationId) onCodeSent,
    required Function(String error) onFailed,
  });

  /// Signs in with SMS OTP verification ID and code,
  /// then exchanges the token with Django backend.
  Future<UserEntity> signInWithPhone(String verificationId, String smsCode);

  /// Signs out of Firebase, clears secure tokens and clears Hive caches.
  Future<void> signOut();

  /// Exchanges the Firebase ID token for a Django JWT pair (access & refresh).
  Future<UserEntity> exchangeFirebaseToken(String idToken);

  /// Fetches the currently logged in user's profile details.
  Future<UserEntity> getCurrentUser();

  /// Updates student profile details on Django backend.
  Future<StudentProfileEntity> updateStudentProfile(StudentProfileEntity profile);
}
