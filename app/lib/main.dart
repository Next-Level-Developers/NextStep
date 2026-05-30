// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'core/services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialise Hive for local questionnaire caching
  await Hive.initFlutter();

  // 2. Initialise Firebase Auth wrapper
  // Note: To configure Firebase for your own Project, download the google-services.json
  // (Android) and GoogleService-Info.plist (iOS) from the Firebase Console and place
  // them in their respective native directories.
  // Then run: `flutterfire configure` to generate firebase_options.dart
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('Make sure to:');
    debugPrint('1. Download google-services.json from Firebase Console');
    debugPrint('2. Place it in android/app/src/main/');
    debugPrint('3. Run: flutterfire configure');
  }

  // 3. Run the application wrapped with ProviderScope
  runApp(
    ProviderScope(
      child: const NextStepApp(),
      observers: [_RiverpodObserver()],
    ),
  );
}

/// Observer that initializes Firebase Messaging after ProviderScope is ready.
class _RiverpodObserver extends ProviderObserver {
  bool _messagingInitialized = false;

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Initialize Firebase Messaging after the app starts
    if (!_messagingInitialized && newValue != null) {
      _messagingInitialized = true;
      // Initialize Firebase Messaging in the background
      Future.microtask(
        () => container.read(firebaseMessagingServiceProvider).initialize(),
      );
    }
  }
}
