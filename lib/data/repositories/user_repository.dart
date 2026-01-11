import 'dart:math';
import 'package:drift/drift.dart';
import '../database.dart';

class UserRepository {
  final AppDatabase _db;

  UserRepository(this._db);

  // Create a new user
  Future<void> createUser(User user) async {
    await _db.into(_db.users).insert(user);
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    return await (_db.select(_db.users)
          ..orderBy([(u) => OrderingTerm(expression: u.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  // Get user by ID
  Future<User?> getUserById(String id) async {
    return await (_db.select(_db.users)..where((u) => u.id.equals(id)))
        .getSingleOrNull();
  }

  // Get user by username
  Future<User?> getUserByUsername(String username) async {
    return await (_db.select(_db.users)..where((u) => u.username.equals(username)))
        .getSingleOrNull();
  }

  // Get user by email
  Future<User?> getUserByEmail(String email) async {
    return await (_db.select(_db.users)..where((u) => u.email.equals(email)))
        .getSingleOrNull();
  }

  // Update user
  Future<void> updateUser(User user) async {
    await _db.update(_db.users).replace(user);
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    await (_db.delete(_db.users)..where((u) => u.id.equals(id))).go();
  }

  // Get active users
  Future<List<User>> getActiveUsers() async {
    return await (_db.select(_db.users)
          ..where((u) => u.isActive.equals(true))
          ..orderBy([(u) => OrderingTerm(expression: u.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  // Get users by role
  Future<List<User>> getUsersByRole(String role) async {
    return await (_db.select(_db.users)
          ..where((u) => u.role.equals(role))
          ..orderBy([(u) => OrderingTerm(expression: u.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    if (query.isEmpty) {
      return await getAllUsers();
    }

    final q = '%$query%';

    return await (_db.select(_db.users)
          ..where((u) => 
                u.firstName.like(q) |
                u.lastName.like(q) |
                u.username.like(q) |
                u.email.like(q) |
                u.phone.like(q)))
        .get();
  }

  // Update user last login
  Future<void> updateLastLogin(String userId) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(lastLoginAt: Value(DateTime.now())));
  }

  // Activate/Deactivate user
  Future<void> setUserActiveStatus(String userId, bool isActive) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(isActive: Value(isActive)));
  }

  // Get user statistics
  Future<Map<String, int>> getUserStatistics() async {
    final allUsers = await getAllUsers();
    final activeUsers = allUsers.where((u) => u.isActive).length;
    final inactiveUsers = allUsers.where((u) => !u.isActive).length;
    
    final roles = <String, int>{};
    for (final user in allUsers) {
      roles[user.role] = (roles[user.role] ?? 0) + 1;
    }

    return {
      'total': allUsers.length,
      'active': activeUsers,
      'inactive': inactiveUsers,
      ...roles,
    };
  }

  // Validate user credentials
  Future<User?> validateUserCredentials(String username, String passwordHash) async {
    return await (_db.select(_db.users)
          ..where((u) => 
                u.username.equals(username) &
                u.passwordHash.equals(passwordHash) &
                u.isActive.equals(true)))
        .getSingleOrNull();
  }

  // Check if username exists
  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // Get users created in date range
  Future<List<User>> getUsersCreatedInRange(DateTime startDate, DateTime endDate) async {
    return await (_db.select(_db.users)
          ..where((u) => 
                u.createdAt.isBetweenValues(startDate, endDate))
          ..orderBy([(u) => OrderingTerm(expression: u.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  // Get users who logged in recently
  Future<List<User>> getRecentlyActiveUsers({int days = 7}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return await (_db.select(_db.users)
          ..where((u) => 
                u.lastLoginAt.isNotNull() &
                u.lastLoginAt.isBiggerOrEqualValue(cutoffDate))
          ..orderBy([(u) => OrderingTerm(expression: u.lastLoginAt, mode: OrderingMode.desc)]))
        .get();
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, {
    String? firstName,
    String? lastName,
    String? phone,
    String? profilePicture,
  }) async {
    final updateData = UsersCompanion(
      firstName: firstName != null ? Value(firstName) : const Value.absent(),
      lastName: lastName != null ? Value(lastName) : const Value.absent(),
      phone: phone != null ? Value(phone) : const Value.absent(),
      profilePicture: profilePicture != null ? Value(profilePicture) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    await (_db.update(_db.users)..where((u) => u.id.equals(userId)))
        .write(updateData);
  }

  // Change user password
  Future<void> changeUserPassword(String userId, String newPasswordHash) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(
          passwordHash: Value(newPasswordHash),
          updatedAt: Value(DateTime.now()),
        ));
  }

  // Get user count by role
  Future<Map<String, int>> getUserCountByRole() async {
    final users = await getAllUsers();
    final roleCounts = <String, int>{};
    
    for (final user in users) {
      roleCounts[user.role] = (roleCounts[user.role] ?? 0) + 1;
    }
    
    return roleCounts;
  }

  // Get user activity summary
  Future<Map<String, dynamic>> getUserActivitySummary(String userId) async {
    final user = await getUserById(userId);
    if (user == null) return {};

    final sessions = await (_db.select(_db.userSessions)
          ..where((s) => s.userId.equals(userId))
          ..orderBy([(s) => OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc)])
          ..limit(10))
        .get();

    final activities = await (_db.select(_db.activityLogs)
          ..where((a) => a.userId.equals(userId))
          ..orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)])
          ..limit(10))
        .get();

    return {
      'user': user,
      'recentSessions': sessions,
      'recentActivities': activities,
      'totalSessions': sessions.length,
      'totalActivities': activities.length,
    };
  }

  // Validate user data
  Map<String, String> validateUserData({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    String? phone,
  }) {
    final errors = <String, String>{};

    // Username validation
    if (username.isEmpty) {
      errors['username'] = 'Username is required';
    } else if (username.length < 3) {
      errors['username'] = 'Username must be at least 3 characters';
    } else if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      errors['username'] = 'Username can only contain letters, numbers, and underscores';
    }

    // Email validation
    if (email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      errors['email'] = 'Please enter a valid email address';
    }

    // First name validation
    if (firstName.isEmpty) {
      errors['firstName'] = 'First name is required';
    } else if (firstName.length < 2) {
      errors['firstName'] = 'First name must be at least 2 characters';
    }

    // Last name validation
    if (lastName.isEmpty) {
      errors['lastName'] = 'Last name is required';
    } else if (lastName.length < 2) {
      errors['lastName'] = 'Last name must be at least 2 characters';
    }

    // Phone validation (optional)
    if (phone != null && phone.isNotEmpty) {
      if (!RegExp(r'^[\d\s\-\+\(\)]+$').hasMatch(phone)) {
        errors['phone'] = 'Please enter a valid phone number';
      }
    }

    return errors;
  }

  // Get user permissions
  Future<List<String>> getUserPermissions(String userId) async {
    final permissions = await (_db.select(_db.userPermissions)
          ..where((p) => p.userId.equals(userId)))
        .get();

    return permissions.map((p) => p.permission).toList();
  }

  // Add user permission
  Future<void> addUserPermission(String userId, String permission) async {
    final permissionEntry = UserPermission(
      id: _generateId(),
      userId: userId,
      permission: permission,
      createdAt: DateTime.now(),
    );

    await _db.into(_db.userPermissions).insert(permissionEntry);
  }

  // Remove user permission
  Future<void> removeUserPermission(String userId, String permission) async {
    await (_db.delete(_db.userPermissions)
          ..where((p) => 
                p.userId.equals(userId) &
                p.permission.equals(permission)))
        .go();
  }

  // Check if user has permission
  Future<bool> hasPermission(String userId, String permission) async {
    final user = await getUserById(userId);
    if (user == null || !user.isActive) return false;

    // Admin role has all permissions
    if (user.role == 'admin') return true;

    // Check specific permissions
    final permissions = await getUserPermissions(userId);
    return permissions.contains(permission);
  }

  // Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString().padLeft(3, '0');
  }
}
