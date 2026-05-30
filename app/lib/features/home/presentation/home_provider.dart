// lib/features/home/presentation/home_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class HomeTab extends _$HomeTab {
  @override
  int build() {
    return 0; // Default to Careers (index 0)
  }

  void setTab(int index) {
    state = index;
  }
}
