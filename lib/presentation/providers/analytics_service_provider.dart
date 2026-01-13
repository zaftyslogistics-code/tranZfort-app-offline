import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/analytics_service.dart';
import 'database_provider.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final database = ref.watch(databaseProvider);
  return AnalyticsService(database);
});
