// lib/features/explore/presentation/explore_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/career_remote_source.dart';
import '../domain/career_entity.dart';

/// Provider for listing career domains.
final careerDomainsProvider =
    FutureProvider<List<CareerDomainEntity>>((ref) async {
  final source = ref.watch(careerRemoteSourceProvider);
  return source.listDomains();
});

/// State for career list search/filter parameters.
class CareerFilterState {
  final String? search;
  final String? domainSlug;
  final int page;

  const CareerFilterState({
    this.search,
    this.domainSlug,
    this.page = 1,
  });

  CareerFilterState copyWith({
    String? search,
    String? domainSlug,
    int? page,
  }) {
    return CareerFilterState(
      search: search ?? this.search,
      domainSlug: domainSlug ?? this.domainSlug,
      page: page ?? this.page,
    );
  }
}

/// Notifier for career list with search/filter/pagination.
class CareerListNotifier extends StateNotifier<AsyncValue<CareerListResponse>> {
  final CareerRemoteSource _source;
  CareerFilterState _filter = const CareerFilterState();

  CareerListNotifier(this._source) : super(const AsyncValue.loading()) {
    _fetch();
  }

  CareerFilterState get filter => _filter;

  Future<void> _fetch() async {
    state = const AsyncValue.loading();
    try {
      final result = await _source.listCareers(
        search: _filter.search,
        domainSlug: _filter.domainSlug,
        page: _filter.page,
      );
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void search(String query) {
    _filter = CareerFilterState(search: query.isEmpty ? null : query);
    _fetch();
  }

  void filterByDomain(String? domainSlug) {
    _filter = CareerFilterState(
      search: _filter.search,
      domainSlug: domainSlug,
    );
    _fetch();
  }

  void loadPage(int page) {
    _filter = _filter.copyWith(page: page);
    _fetch();
  }

  void refresh() => _fetch();
}

final careerListProvider = StateNotifierProvider<CareerListNotifier,
    AsyncValue<CareerListResponse>>((ref) {
  final source = ref.watch(careerRemoteSourceProvider);
  return CareerListNotifier(source);
});
