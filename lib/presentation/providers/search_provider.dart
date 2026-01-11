import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/search_service.dart';
import '../providers/vehicle_provider.dart';
import '../providers/driver_provider.dart';
import '../providers/party_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/document_provider.dart';

// Search service provider
final searchServiceProvider = Provider<SearchService>((ref) {
  final vehicleRepo = ref.read(vehicleRepositoryProvider);
  final driverRepo = ref.read(driverRepositoryProvider);
  final partyRepo = ref.read(partyRepositoryProvider);
  final tripRepo = ref.read(tripRepositoryProvider);
  final expenseRepo = ref.read(expenseRepositoryProvider);
  final paymentRepo = ref.read(paymentRepositoryProvider);
  final documentRepo = ref.read(documentRepositoryProvider);

  return SearchService(
    expenseRepo,
    paymentRepo,
    documentRepo,
    tripRepo,
    vehicleRepo,
    driverRepo,
    partyRepo,
  );
});

Map<String, List<SearchResult>> _groupResultsByType(List<SearchResult> results) {
  final grouped = <String, List<SearchResult>>{};
  for (final r in results) {
    grouped.putIfAbsent(r.type, () => <SearchResult>[]).add(r);
  }
  return grouped;
}

// Search results provider
final searchResultsProvider = FutureProvider.family<Map<String, List<SearchResult>>, String>((ref, query) {
  final service = ref.read(searchServiceProvider);
  return service.searchAll(query).then(_groupResultsByType);
});

// Advanced search results provider
final advancedSearchResultsProvider = FutureProvider.family<Map<String, List<SearchResult>>, SearchFilters>((ref, filters) {
  final service = ref.read(searchServiceProvider);
  return service.searchWithFilters(filters).then(_groupResultsByType);
});

// Search suggestions provider
final searchSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, query) {
  final service = ref.read(searchServiceProvider);
  return service.getSearchSuggestions(query);
});

// Filter options provider
final filterOptionsProvider = FutureProvider<Map<String, List<String>>>((ref) {
  final service = ref.read(searchServiceProvider);
  return service.getFilterOptions();
});

// Search state provider
class SearchState {
  final String query;
  final bool isSearching;
  final bool showAdvanced;
  final SearchFilters filters;
  final List<String> searchHistory;
  final List<String> savedSearches;
  final String? error;
  final Map<String, List<SearchResult>>? results;

  SearchState({
    this.query = '',
    this.isSearching = false,
    this.showAdvanced = false,
    this.filters = const SearchFilters(),
    this.searchHistory = const [],
    this.savedSearches = const [],
    this.error,
    this.results,
  });

  SearchState copyWith({
    String? query,
    bool? isSearching,
    bool? showAdvanced,
    SearchFilters? filters,
    List<String>? searchHistory,
    List<String>? savedSearches,
    String? error,
    Map<String, List<SearchResult>>? results,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      showAdvanced: showAdvanced ?? this.showAdvanced,
      filters: filters ?? this.filters,
      searchHistory: searchHistory ?? this.searchHistory,
      savedSearches: savedSearches ?? this.savedSearches,
      error: error ?? this.error,
      results: results ?? this.results,
    );
  }
}

// Search state notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final SearchService _searchService;

  SearchNotifier(this._searchService) : super(SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        query: '',
        results: null,
        error: null,
      );
      return;
    }

    state = state.copyWith(
      query: query,
      isSearching: true,
      error: null,
    );

    try {
      final results = _groupResultsByType(await _searchService.searchAll(query));
      
      // Add to search history
      final history = List<String>.from(state.searchHistory);
      history.remove(query);
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }

      state = state.copyWith(
        isSearching: false,
        results: results,
        searchHistory: history,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: 'Search failed: $e',
      );
    }
  }

  Future<void> advancedSearch(SearchFilters filters) async {
    state = state.copyWith(
      isSearching: true,
      error: null,
    );

    try {
      final results = _groupResultsByType(await _searchService.searchWithFilters(filters));
      
      state = state.copyWith(
        isSearching: false,
        results: results,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: 'Advanced search failed: $e',
      );
    }
  }

  void toggleAdvanced() {
    state = state.copyWith(showAdvanced: !state.showAdvanced);
  }

  void updateFilters(SearchFilters filters) {
    state = state.copyWith(filters: filters);
  }

  void clearFilters() {
    state = state.copyWith(filters: const SearchFilters());
  }

  void saveSearch(String name) {
    if (state.query.isNotEmpty) {
      final savedSearches = List<String>.from(state.savedSearches);
      if (!savedSearches.contains(name)) {
        savedSearches.add(name);
        state = state.copyWith(savedSearches: savedSearches);
      }
    }
  }

  void deleteSavedSearch(String name) {
    final savedSearches = List<String>.from(state.savedSearches);
    savedSearches.remove(name);
    state = state.copyWith(savedSearches: savedSearches);
  }

  void clearSearchHistory() {
    state = state.copyWith(searchHistory: []);
  }

  void clearResults() {
    state = state.copyWith(
      query: '',
      results: null,
      error: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  int get totalResults {
    if (state.results == null) return 0;
    return state.results!.values.fold(0, (sum, results) => sum + results.length);
  }
}

// Search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final searchService = ref.read(searchServiceProvider);
  return SearchNotifier(searchService);
});

// Search history provider
final searchHistoryProvider = Provider<List<String>>((ref) {
  return ref.watch(searchProvider).searchHistory;
});

// Saved searches provider
final savedSearchesProvider = Provider<List<String>>((ref) {
  return ref.watch(searchProvider).savedSearches;
});

// Search query provider
final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(searchProvider).query;
});

// Search results count provider
final searchResultsCountProvider = Provider<int>((ref) {
  return ref.read(searchProvider).totalResults;
});

// Search error provider
final searchErrorProvider = Provider<String?>((ref) {
  return ref.watch(searchProvider).error;
});

// Search loading provider
final searchLoadingProvider = Provider<bool>((ref) {
  return ref.watch(searchProvider).isSearching;
});

// Advanced search visibility provider
final advancedSearchVisibilityProvider = Provider<bool>((ref) {
  return ref.watch(searchProvider).showAdvanced;
});

// Current filters provider
final currentFiltersProvider = Provider<SearchFilters>((ref) {
  return ref.watch(searchProvider).filters;
});

// Search results provider (from state)
final searchResultsFromStateProvider = Provider<Map<String, List<SearchResult>>?>((
  ref,
) {
  return ref.watch(searchProvider).results;
});

// Quick search provider
class QuickSearchState {
  final String query;
  final bool isSearching;
  final List<SearchResult> results;
  final String? error;

  QuickSearchState({
    this.query = '',
    this.isSearching = false,
    this.results = const [],
    this.error,
  });

  QuickSearchState copyWith({
    String? query,
    bool? isSearching,
    List<SearchResult>? results,
    String? error,
  }) {
    return QuickSearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      results: results ?? this.results,
      error: error ?? this.error,
    );
  }
}

// Quick search notifier
class QuickSearchNotifier extends StateNotifier<QuickSearchState> {
  final SearchService _searchService;

  QuickSearchNotifier(this._searchService) : super(QuickSearchState());

  Future<void> quickSearch(String query, String type) async {
    if (query.isEmpty) {
      state = state.copyWith(
        query: '',
        results: [],
        error: null,
      );
      return;
    }

    state = state.copyWith(
      query: query,
      isSearching: true,
      error: null,
    );

    try {
      final filters = SearchFilters(
        query: query,
        includeExpenses: type == 'all' || type == 'expense',
        includePayments: type == 'all' || type == 'payment',
        includeDocuments: type == 'all' || type == 'document',
      );

      final allResults = await _searchService.searchWithFilters(filters);

      state = state.copyWith(
        isSearching: false,
        results: allResults,
      );
    } catch (e) {
      state = state.copyWith(
        isSearching: false,
        error: 'Quick search failed: $e',
      );
    }
  }

  void clear() {
    state = state.copyWith(
      query: '',
      results: [],
      error: null,
    );
  }
}

// Quick search provider
final quickSearchProvider = StateNotifierProvider<QuickSearchNotifier, QuickSearchState>((ref) {
  final searchService = ref.read(searchServiceProvider);
  return QuickSearchNotifier(searchService);
});

// Search analytics provider
class SearchAnalytics {
  final int totalSearches;
  final int averageResults;
  final Map<String, int> searchCounts;
  final List<String> popularQueries;

  SearchAnalytics({
    required this.totalSearches,
    required this.averageResults,
    required this.searchCounts,
    required this.popularQueries,
  });
}

// Search analytics provider
final searchAnalyticsProvider = Provider<SearchAnalytics>((ref) {
  // This would be implemented with actual analytics data
  return SearchAnalytics(
    totalSearches: 0,
    averageResults: 0,
    searchCounts: {},
    popularQueries: [],
  );
});

// Search preferences provider
class SearchPreferences {
  final int maxHistoryItems;
  final bool showSuggestions;
  final bool autoSearch;
  final int debounceMs;
  final List<String> defaultFilters;

  SearchPreferences({
    this.maxHistoryItems = 10,
    this.showSuggestions = true,
    this.autoSearch = true,
    this.debounceMs = 300,
    this.defaultFilters = const [],
  });

  SearchPreferences copyWith({
    int? maxHistoryItems,
    bool? showSuggestions,
    bool? autoSearch,
    int? debounceMs,
    List<String>? defaultFilters,
  }) {
    return SearchPreferences(
      maxHistoryItems: maxHistoryItems ?? this.maxHistoryItems,
      showSuggestions: showSuggestions ?? this.showSuggestions,
      autoSearch: autoSearch ?? this.autoSearch,
      debounceMs: debounceMs ?? this.debounceMs,
      defaultFilters: defaultFilters ?? this.defaultFilters,
    );
  }
}

// Search preferences provider
final searchPreferencesProvider = Provider<SearchPreferences>((ref) {
  return SearchPreferences();
});
