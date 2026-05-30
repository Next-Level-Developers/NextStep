// lib/core/auth/firebase_auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Thin wrapper around Firebase Auth SDK.
/// The rest of the app never imports firebase_auth directly — it goes through here.
class FirebaseAuthService {
  FirebaseAuthService._();

  // Lazy getters to avoid accessing FirebaseAuth.instance before Firebase.initializeApp()
  static FirebaseAuth get _auth => FirebaseAuth.instance;
  static GoogleSignIn get _googleSignIn => GoogleSignIn();

  // ── Streams ─────────────────────────────────────────────────────────────────

  /// Stream of Firebase [User] changes. null = signed out.
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Returns the current Firebase user, or null if not signed in.
  static User? get currentUser => _auth.currentUser;

  // ── Sign In Methods ──────────────────────────────────────────────────────────

  /// Signs in with email and password. Returns the Firebase ID token on success.
  static Future<String> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getIdToken(credential.user!);
  }

  /// Creates a new account with email and password. Returns the Firebase ID token.
  static Future<String> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(fullName);
    return _getIdToken(credential.user!);
  }

  /// Signs in with Google. Returns the Firebase ID token on success.
  static Future<String?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // User cancelled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return _getIdToken(userCredential.user!);
  }

  /// Initiates phone OTP verification.
  static Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(PhoneAuthCredential) onAutoVerified,
    required void Function(FirebaseAuthException) onFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onAutoVerified,
      verificationFailed: onFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Signs in with OTP SMS code after phone verification.
  static Future<String> signInWithPhoneOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return _getIdToken(userCredential.user!);
  }

  // ── Password Reset ───────────────────────────────────────────────────────────

  static Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  // ── Sign Out ─────────────────────────────────────────────────────────────────

  static Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  static Future<String> _getIdToken(User user) async {
    final token = await user.getIdToken(true);
    if (token == null) throw Exception('Failed to get Firebase ID token');
    return token;
  }

  /// Forces a token refresh and returns the new Firebase ID token.
  static Future<String?> refreshIdToken() async {
    return _auth.currentUser?.getIdToken(true);
  }

  /// Maps Firebase error codes to user-friendly messages.
  static String mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
