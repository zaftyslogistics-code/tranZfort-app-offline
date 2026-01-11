import 'dart:convert';
import 'dart:math';
import '../repositories/user_repository.dart';
import '../database.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  // User roles
  static const List<String> userRoles = [
    'admin',
    'manager',
    'operator',
    'viewer',
  ];

  // Default permissions for each role
  static const Map<String, List<String>> rolePermissions = {
    'admin': [
      'users.create',
      'users.read',
      'users.update',
      'users.delete',
      'vehicles.create',
      'vehicles.read',
      'vehicles.update',
      'vehicles.delete',
      'drivers.create',
      'drivers.read',
      'drivers.update',
      'drivers.delete',
      'parties.create',
      'parties.read',
      'parties.update',
      'parties.delete',
      'trips.create',
      'trips.read',
      'trips.update',
      'trips.delete',
      'expenses.create',
      'expenses.read',
      'expenses.update',
      'expenses.delete',
      'payments.create',
      'payments.read',
      'payments.update',
      'payments.delete',
      'documents.create',
      'documents.read',
      'documents.update',
      'documents.delete',
      'reports.read',
      'reports.export',
      'system.settings',
      'system.backup',
      'system.restore',
    ],
    'manager': [
      'vehicles.create',
      'vehicles.read',
      'vehicles.update',
      'drivers.create',
      'drivers.read',
      'drivers.update',
      'parties.create',
      'parties.read',
      'parties.update',
      'trips.create',
      'trips.read',
      'trips.update',
      'expenses.create',
      'expenses.read',
      'expenses.update',
      'payments.create',
      'payments.read',
      'payments.update',
      'documents.create',
      'documents.read',
      'documents.update',
      'reports.read',
      'reports.export',
    ],
    'operator': [
      'vehicles.read',
      'drivers.read',
      'parties.read',
      'trips.create',
      'trips.read',
      'trips.update',
      'expenses.create',
      'expenses.read',
      'expenses.update',
      'payments.create',
      'payments.read',
      'payments.update',
      'documents.create',
      'documents.read',
      'documents.update',
      'reports.read',
    ],
    'viewer': [
      'vehicles.read',
      'drivers.read',
      'parties.read',
      'trips.read',
      'expenses.read',
      'payments.read',
      'documents.read',
      'reports.read',
    ],
  };

  // Create a new user
  Future<String> createUser({
    required String username,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phone,
    String? profilePicture,
  }) async {
    // Validate user data
    final validationErrors = _userRepository.validateUserData(
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    if (validationErrors.isNotEmpty) {
      throw Exception('Validation failed: ${validationErrors.values.join(', ')}');
    }

    // Check if username already exists
    if (await _userRepository.usernameExists(username)) {
      throw Exception('Username already exists');
    }

    // Check if email already exists
    if (await _userRepository.emailExists(email)) {
      throw Exception('Email already exists');
    }

    // Validate role
    if (!userRoles.contains(role)) {
      throw Exception('Invalid role: $role');
    }

    // Hash password (simplified - in production, use proper hashing)
    final passwordHash = _hashPassword(password);

    // Create user
    final user = User(
      id: _generateId(),
      username: username,
      email: email,
      passwordHash: passwordHash,
      firstName: firstName,
      lastName: lastName,
      role: role,
      phone: phone,
      profilePicture: profilePicture,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _userRepository.createUser(user);

    // Add role permissions
    final permissions = rolePermissions[role] ?? [];
    for (final permission in permissions) {
      await _userRepository.addUserPermission(user.id, permission);
    }

    return user.id;
  }

  // Authenticate user
  Future<User?> authenticateUser(String username, String password) async {
    final passwordHash = _hashPassword(password);
    final user = await _userRepository.validateUserCredentials(username, passwordHash);
    
    if (user != null) {
      // Update last login
      await _userRepository.updateLastLogin(user.id);
      return user;
    }
    
    return null;
  }

  // Update user profile
  Future<void> updateUserProfile(
    String userId, {
    String? firstName,
    String? lastName,
    String? phone,
    String? profilePicture,
  }) async {
    // Validate user data
    final validationErrors = _userRepository.validateUserData(
      username: '', // Not updating username
      email: '', // Not updating email
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      phone: phone,
    );

    if (validationErrors.isNotEmpty) {
      throw Exception('Validation failed: ${validationErrors.values.join(', ')}');
    }

    await _userRepository.updateUserProfile(
      userId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      profilePicture: profilePicture,
    );
  }

  // Change user password
  Future<void> changeUserPassword(String userId, String currentPassword, String newPassword) async {
    final user = await _userRepository.getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Verify current password
    final currentPasswordHash = _hashPassword(currentPassword);
    if (user.passwordHash != currentPasswordHash) {
      throw Exception('Current password is incorrect');
    }

    // Validate new password
    if (newPassword.length < 6) {
      throw Exception('New password must be at least 6 characters');
    }

    // Update password
    final newPasswordHash = _hashPassword(newPassword);
    await _userRepository.changeUserPassword(userId, newPasswordHash);
  }

  // Change user role
  Future<void> changeUserRole(String userId, String newRole) async {
    final user = await _userRepository.getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    if (!userRoles.contains(newRole)) {
      throw Exception('Invalid role: $newRole');
    }

    // Remove old permissions
    final oldPermissions = rolePermissions[user.role] ?? [];
    for (final permission in oldPermissions) {
      await _userRepository.removeUserPermission(userId, permission);
    }

    // Update user role
    await _userRepository.updateUser(user.copyWith(
      role: newRole,
      updatedAt: DateTime.now(),
    ));

    // Add new permissions
    final newPermissions = rolePermissions[newRole] ?? [];
    for (final permission in newPermissions) {
      await _userRepository.addUserPermission(userId, permission);
    }
  }

  // Activate/Deactivate user
  Future<void> setUserActiveStatus(String userId, bool isActive) async {
    await _userRepository.setUserActiveStatus(userId, isActive);
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    final user = await _userRepository.getUserById(userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Don't allow deletion of admin users
    if (user.role == 'admin') {
      throw Exception('Cannot delete admin users');
    }

    await _userRepository.deleteUser(userId);
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    final stats = await _userRepository.getUserStatistics();
    final roleCounts = await _userRepository.getUserCountByRole();
    
    return {
      'totalUsers': stats['total'] ?? 0,
      'activeUsers': stats['active'] ?? 0,
      'inactiveUsers': stats['inactive'] ?? 0,
      'roleDistribution': roleCounts,
      'recentlyActive': await _userRepository.getRecentlyActiveUsers(),
    };
  }

  // Get user activity summary
  Future<Map<String, dynamic>> getUserActivitySummary(String userId) async {
    return await _userRepository.getUserActivitySummary(userId);
  }

  // Check if user has permission
  Future<bool> hasPermission(String userId, String permission) async {
    return await _userRepository.hasPermission(userId, permission);
  }

  // Get all available roles
  List<String> getAvailableRoles() {
    return List.from(userRoles);
  }

  // Get permissions for role
  List<String> getRolePermissions(String role) {
    return List.from(rolePermissions[role] ?? []);
  }

  // Get all available permissions
  List<String> getAllPermissions() {
    final allPermissions = <String>{};
    for (final permissions in rolePermissions.values) {
      allPermissions.addAll(permissions);
    }
    return allPermissions.toList();
  }

  // Validate user data
  Map<String, String> validateUserData({
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    String? phone,
    String? password,
  }) {
    final errors = _userRepository.validateUserData(
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    // Password validation
    if (password != null) {
      if (password.isEmpty) {
        errors['password'] = 'Password is required';
      } else if (password.length < 6) {
        errors['password'] = 'Password must be at least 6 characters';
      } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
        errors['password'] = 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
      }
    }

    return errors;
  }

  // Generate user report
  Future<Map<String, dynamic>> generateUserReport() async {
    final allUsers = await _userRepository.getAllUsers();
    final activeUsers = allUsers.where((u) => u.isActive).length;
    final inactiveUsers = allUsers.where((u) => !u.isActive).length;
    
    final roleStats = <String, Map<String, dynamic>>{};
    for (final role in userRoles) {
      final roleUsers = allUsers.where((u) => u.role == role);
      roleStats[role] = {
        'total': roleUsers.length,
        'active': roleUsers.where((u) => u.isActive).length,
        'inactive': roleUsers.where((u) => !u.isActive).length,
      };
    }

    return {
      'summary': {
        'totalUsers': allUsers.length,
        'activeUsers': activeUsers,
        'inactiveUsers': inactiveUsers,
        'activationRate': allUsers.isNotEmpty ? (activeUsers / allUsers.length * 100).toStringAsFixed(1) : '0.0',
      },
      'roleStats': roleStats,
      'users': allUsers.map((user) => {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'name': '${user.firstName} ${user.lastName}',
        'role': user.role,
        'phone': user.phone,
        'isActive': user.isActive,
        'lastLoginAt': user.lastLoginAt,
        'createdAt': user.createdAt,
      }).toList(),
    };
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    return await _userRepository.searchUsers(query);
  }

  // Get users by role
  Future<List<User>> getUsersByRole(String role) async {
    return await _userRepository.getUsersByRole(role);
  }

  // Get active users
  Future<List<User>> getActiveUsers() async {
    return await _userRepository.getActiveUsers();
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    return await _userRepository.getAllUsers();
  }

  // Get user by ID
  Future<User?> getUserById(String id) async {
    return await _userRepository.getUserById(id);
  }

  // Simple password hashing (in production, use bcrypt or similar)
  String _hashPassword(String password) {
    // This is a simplified hashing method
    // In production, use proper cryptographic hashing
    final bytes = utf8.encode(password + 'tranzfort_salt');
    final hash = base64Encode(bytes);
    return hash;
  }

  // Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString().padLeft(3, '0');
  }

  // Get predefined user roles with descriptions
  Map<String, String> getRoleDescriptions() {
    return {
      'admin': 'Full system access including user management and system settings',
      'manager': 'Can manage all business operations except user management',
      'operator': 'Can create and manage trips, expenses, and payments',
      'viewer': 'Read-only access to all data and reports',
    };
  }

  // Get permission descriptions
  Map<String, String> getPermissionDescriptions() {
    return {
      'users.create': 'Create new users',
      'users.read': 'View user information',
      'users.update': 'Update user information',
      'users.delete': 'Delete users',
      'vehicles.create': 'Create new vehicles',
      'vehicles.read': 'View vehicle information',
      'vehicles.update': 'Update vehicle information',
      'vehicles.delete': 'Delete vehicles',
      'drivers.create': 'Create new drivers',
      'drivers.read': 'View driver information',
      'drivers.update': 'Update driver information',
      'drivers.delete': 'Delete drivers',
      'parties.create': 'Create new parties',
      'parties.read': 'View party information',
      'parties.update': 'Update party information',
      'parties.delete': 'Delete parties',
      'trips.create': 'Create new trips',
      'trips.read': 'View trip information',
      'trips.update': 'Update trip information',
      'trips.delete': 'Delete trips',
      'expenses.create': 'Create new expenses',
      'expenses.read': 'View expense information',
      'expenses.update': 'Update expense information',
      'expenses.delete': 'Delete expenses',
      'payments.create': 'Create new payments',
      'payments.read': 'View payment information',
      'payments.update': 'Update payment information',
      'payments.delete': 'Delete payments',
      'documents.create': 'Create new documents',
      'documents.read': 'View document information',
      'documents.update': 'Update document information',
      'documents.delete': 'Delete documents',
      'reports.read': 'View reports',
      'reports.export': 'Export reports',
      'system.settings': 'Access system settings',
      'system.backup': 'Create system backups',
      'system.restore': 'Restore system backups',
    };
  }
}
