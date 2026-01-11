import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../providers/filter_options_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/enhanced_widgets.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isAdvancedSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    ref.read(searchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final searchSuggestions = ref.watch(searchSuggestionsProvider(_searchController.text));
    final filterOptions = ref.watch(filterOptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showSearchHistory(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _toggleAdvancedSearch(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search vehicles, drivers, parties, trips...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchState.query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(searchProvider.notifier).clearResults();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          // Advanced Search Filters
          if (_isAdvancedSearchVisible)
            _buildAdvancedFilters(context, filterOptions),

          // Search Suggestions
          if (searchState.query.isNotEmpty && searchState.results == null)
            _buildSearchSuggestions(context, searchSuggestions),

          // Search Results
          Expanded(
            child: _buildSearchResults(context, searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(BuildContext context, AsyncSnapshot<Map<String, List<String>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot.hasError) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('Error loading filters: ${snapshot.error}')),
      );
    }

    final options = snapshot.data!;
    final filters = ref.watch(currentFiltersProvider);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Advanced Filters',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => ref.read(searchProvider.notifier).clearFilters(),
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Module Selection
            const Text('Search in:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('Vehicles'),
                  selected: filters.includeVehicles,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includeVehicles: selected),
                    );
                  },
                ),
                FilterChip(
                  label: const Text('Drivers'),
                  selected: filters.includeDrivers,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includeDrivers: selected),
                    );
                  },
                ),
                FilterChip(
                  label: const Text('Parties'),
                  selected: filters.includeParties,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includeParties: selected),
                    );
                  },
                ),
                FilterChip(
                  label: const Text('Trips'),
                  selected: filters.includeTrips,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includeTrips: selected),
                    );
                  },
                ),
                FilterChip(
                  label: const Text('Expenses'),
                  selected: filters.includeExpenses,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includeExpenses: selected),
                    );
                  },
                ),
                FilterChip(
                  label: const Text('Payments'),
                  selected: filters.includePayments,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includePayments: selected),
                    );
                  },
                ),
                FilterChip(
                  label: const Text('Documents'),
                  selected: filters.includeDocuments,
                  onSelected: (selected) {
                    ref.read(searchProvider.notifier).updateFilters(
                      filters.copyWith(includeDocuments: selected),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Status Filters
            const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Vehicle Status
                if (filters.includeVehicles && options['vehicleStatus'] != null)
                  DropdownButton<String>(
                    hint: const Text('Vehicle Status'),
                    value: filters.vehicleStatus,
                    items: options['vehicleStatus']!.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).updateFilters(
                        filters.copyWith(vehicleStatus: value),
                      );
                    },
                  ),

                // Driver Status
                if (filters.includeDrivers && options['driverStatus'] != null)
                  DropdownButton<String>(
                    hint: const Text('Driver Status'),
                    value: filters.driverStatus,
                    items: options['driverStatus']!.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).updateFilters(
                        filters.copyWith(driverStatus: value),
                      );
                    },
                  ),

                // Trip Status
                if (filters.includeTrips && options['tripStatus'] != null)
                  DropdownButton<String>(
                    hint: const Text('Trip Status'),
                    value: filters.tripStatus,
                    items: options['tripStatus']!.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      ref.read(searchProvider.notifier).updateFilters(
                        filters.copyWith(tripStatus: value),
                      );
                    },
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Date Range Filter
            const Text('Date Range:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectStartDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Start Date', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            filters.startDate != null
                                ? '${filters.startDate!.day}/${filters.startDate!.month}/${filters.startDate!.year}'
                                : 'Select date',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectEndDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).colorScheme.outline),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('End Date', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            filters.endDate != null
                                ? '${filters.endDate!.day}/${filters.endDate!.month}/${filters.endDate!.year}'
                                : 'Select date',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Apply Filters Button
            ElevatedButton.icon(
              onPressed: () {
                ref.read(searchProvider.notifier).advancedSearch(filters);
              },
              icon: const Icon(Icons.search),
              label: const Text('Apply Filters'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSuggestions(BuildContext context, AsyncSnapshot<List<String>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
      return const SizedBox.shrink();
    }

    final suggestions = snapshot.data!;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            leading: const Icon(Icons.search),
            title: Text(suggestion),
            onTap: () {
              _searchController.text = suggestion;
              _searchFocusNode.unfocus();
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchState searchState) {
    if (searchState.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              searchState.error!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(searchProvider.notifier).clearError();
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (searchState.results == null) {
      return _buildEmptyState(context);
    }

    final results = searchState.results!;
    final totalResults = results.values.fold(0, (sum, list) => sum + list.length);

    if (totalResults == 0) {
      return _buildNoResultsState(context);
    }

    return Column(
      children: [
        // Results Summary
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '$totalResults results found',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (searchState.query.isNotEmpty)
                TextButton(
                  onPressed: () {
                    ref.read(searchProvider.notifier).saveSearch(searchState.query);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search saved')),
                    );
                  },
                  child: const Text('Save Search'),
                ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final category = results.keys.elementAt(index);
              final categoryResults = results[category]!;

              if (categoryResults.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(category)),
                        const SizedBox(width: 8),
                        Text(
                          _getCategoryTitle(category),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${categoryResults.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category Results
                  ...categoryResults.map((result) => _buildResultItem(context, result)),

                  const SizedBox(height: 16),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResultItem(BuildContext context, SearchResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCategoryColor(result.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getCategoryIcon(result.type),
            color: _getCategoryColor(result.type),
            size: 20,
          ),
        ),
        title: Text(result.title),
        subtitle: Text(result.subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          _navigateToResult(context, result);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search Anything',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Find vehicles, drivers, parties, trips, expenses, payments, and documents',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _toggleAdvancedSearch(),
            icon: const Icon(Icons.filter_list),
            label: const Text('Advanced Search'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or adjust your filters',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ref.read(searchProvider.notifier).clearFilters();
                },
                child: const Text('Clear Filters'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  _searchController.clear();
                  ref.read(searchProvider.notifier).clearResults();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear Search'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'vehicle':
        return Icons.local_shipping;
      case 'driver':
        return Icons.people;
      case 'party':
        return Icons.business;
      case 'trip':
        return Icons.directions;
      case 'expense':
        return Icons.receipt_long;
      case 'payment':
        return Icons.account_balance_wallet;
      case 'document':
        return Icons.insert_drive_file;
      default:
        return Icons.folder;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'vehicle':
        return AppTheme.primaryColor;
      case 'driver':
        return AppTheme.successColor;
      case 'party':
        return AppTheme.infoColor;
      case 'trip':
        return AppTheme.warningColor;
      case 'expense':
        return AppTheme.warningColor;
      case 'payment':
        return AppTheme.successColor;
      case 'document':
        return AppTheme.infoColor;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'vehicle':
        return 'Vehicles';
      case 'driver':
        return 'Drivers';
      case 'party':
        return 'Parties';
      case 'trip':
        return 'Trips';
      case 'expense':
        return 'Expenses';
      case 'payment':
        return 'Payments';
      case 'document':
        return 'Documents';
      default:
        return category;
    }
  }

  void _navigateToResult(BuildContext context, SearchResult result) {
    // Navigate to the appropriate detail screen based on result type
    switch (result.type) {
      case 'vehicle':
        // TODO: Navigate to vehicle detail
        break;
      case 'driver':
        // TODO: Navigate to driver detail
        break;
      case 'party':
        // TODO: Navigate to party detail
        break;
      case 'trip':
        // TODO: Navigate to trip detail
        break;
      case 'expense':
        // TODO: Navigate to expense detail
        break;
      case 'payment':
        // TODO: Navigate to payment detail
        break;
      case 'document':
        // TODO: Navigate to document detail
        break;
    }
  }

  void _toggleAdvancedSearch() {
    setState(() {
      _isAdvancedSearchVisible = !_isAdvancedSearchVisible;
    });
    ref.read(searchProvider.notifier).toggleAdvanced();
  }

  void _selectStartDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final filters = ref.read(currentFiltersProvider);
      ref.read(searchProvider.notifier).updateFilters(
        filters.copyWith(startDate: date),
      );
    }
  }

  void _selectEndDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      final filters = ref.read(currentFiltersProvider);
      ref.read(searchProvider.notifier).updateFilters(
        filters.copyWith(endDate: date),
      );
    }
  }

  void _showSearchHistory(BuildContext context) {
    final searchHistory = ref.watch(searchHistoryProvider);
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Search History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    ref.read(searchProvider.notifier).clearSearchHistory();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (searchHistory.isEmpty)
              const Text('No search history yet')
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  final query = searchHistory[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(query),
                    onTap: () {
                      _searchController.text = query;
                      Navigator.of(context).pop();
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        // TODO: Remove specific item from history
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
