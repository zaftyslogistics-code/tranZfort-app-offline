import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';

// Shared database provider - simplified approach
final databaseProvider = Provider<AppDatabase>((ref) {
  try {
    // Remove print statements for production
    return AppDatabase();
  } catch (e) {
    // Log error silently for production
    // TODO: Add proper error logging
    rethrow;
  }
});
