import 'package:shared_preferences/shared_preferences.dart';

/// Favorites Service
/// Manages user favorites for vehicles, drivers, and routes
class FavoritesService {
  static const String _vehicleFavoritesKey = 'favorite_vehicles';
  static const String _driverFavoritesKey = 'favorite_drivers';
  static const String _routeFavoritesKey = 'favorite_routes';

  /// Add vehicle to favorites
  Future<void> addVehicleFavorite(String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_vehicleFavoritesKey) ?? [];
    if (!favorites.contains(vehicleId)) {
      favorites.add(vehicleId);
      await prefs.setStringList(_vehicleFavoritesKey, favorites);
    }
  }

  /// Remove vehicle from favorites
  Future<void> removeVehicleFavorite(String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_vehicleFavoritesKey) ?? [];
    favorites.remove(vehicleId);
    await prefs.setStringList(_vehicleFavoritesKey, favorites);
  }

  /// Check if vehicle is favorite
  Future<bool> isVehicleFavorite(String vehicleId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_vehicleFavoritesKey) ?? [];
    return favorites.contains(vehicleId);
  }

  /// Get all favorite vehicles
  Future<List<String>> getVehicleFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_vehicleFavoritesKey) ?? [];
  }

  /// Add driver to favorites
  Future<void> addDriverFavorite(String driverId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_driverFavoritesKey) ?? [];
    if (!favorites.contains(driverId)) {
      favorites.add(driverId);
      await prefs.setStringList(_driverFavoritesKey, favorites);
    }
  }

  /// Remove driver from favorites
  Future<void> removeDriverFavorite(String driverId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_driverFavoritesKey) ?? [];
    favorites.remove(driverId);
    await prefs.setStringList(_driverFavoritesKey, favorites);
  }

  /// Check if driver is favorite
  Future<bool> isDriverFavorite(String driverId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_driverFavoritesKey) ?? [];
    return favorites.contains(driverId);
  }

  /// Get all favorite drivers
  Future<List<String>> getDriverFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_driverFavoritesKey) ?? [];
  }

  /// Add route to favorites
  Future<void> addRouteFavorite(String route) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_routeFavoritesKey) ?? [];
    if (!favorites.contains(route)) {
      favorites.add(route);
      await prefs.setStringList(_routeFavoritesKey, favorites);
    }
  }

  /// Remove route from favorites
  Future<void> removeRouteFavorite(String route) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_routeFavoritesKey) ?? [];
    favorites.remove(route);
    await prefs.setStringList(_routeFavoritesKey, favorites);
  }

  /// Check if route is favorite
  Future<bool> isRouteFavorite(String route) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_routeFavoritesKey) ?? [];
    return favorites.contains(route);
  }

  /// Get all favorite routes
  Future<List<String>> getRouteFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_routeFavoritesKey) ?? [];
  }

  /// Toggle vehicle favorite
  Future<bool> toggleVehicleFavorite(String vehicleId) async {
    final isFavorite = await isVehicleFavorite(vehicleId);
    if (isFavorite) {
      await removeVehicleFavorite(vehicleId);
      return false;
    } else {
      await addVehicleFavorite(vehicleId);
      return true;
    }
  }

  /// Toggle driver favorite
  Future<bool> toggleDriverFavorite(String driverId) async {
    final isFavorite = await isDriverFavorite(driverId);
    if (isFavorite) {
      await removeDriverFavorite(driverId);
      return false;
    } else {
      await addDriverFavorite(driverId);
      return true;
    }
  }

  /// Toggle route favorite
  Future<bool> toggleRouteFavorite(String route) async {
    final isFavorite = await isRouteFavorite(route);
    if (isFavorite) {
      await removeRouteFavorite(route);
      return false;
    } else {
      await addRouteFavorite(route);
      return true;
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_vehicleFavoritesKey);
    await prefs.remove(_driverFavoritesKey);
    await prefs.remove(_routeFavoritesKey);
  }
}
