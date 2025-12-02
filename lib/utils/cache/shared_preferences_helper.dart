import 'dart:convert';
import 'package:flexpay/features/bookings/models/bookings_models.dart';
import 'package:flexpay/utils/services/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flexpay/features/auth/models/user_model.dart';

class SharedPreferencesHelper {
  static const String _userModelKey = 'user_model';
  static const String _firstLaunchKey = 'isFirstLaunch';
  static const String _bookingsKey = 'all_bookings';

  static SharedPreferences? _cachedPrefs;

  // ----------------- Initialization & Warmup -----------------
  /// Initialize SharedPreferences to avoid first-access delays
  /// This warms up the SharedPreferences instance and caches it
  static Future<void> init() async {
    try {
      _cachedPrefs = await SharedPreferences.getInstance();
      AppLogger.log('✅ SharedPreferences warmed up and cached');
    } catch (e) {
      AppLogger.log('⚠️ SharedPreferences warmup failed: $e');
      // Don't throw - this shouldn't crash the app
    }
  }

  /// Get SharedPreferences instance with caching
  static Future<SharedPreferences> _getPrefs() async {
    _cachedPrefs ??= await SharedPreferences.getInstance();
    return _cachedPrefs!;
  }

  // ----------------- First Launch -----------------
  static Future<bool> isFirstLaunch() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  static Future<void> setFirstLaunchDone() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_firstLaunchKey, false);
  }

  // ----------------- UserModel Handling -----------------
  static Future<void> saveUserModel(UserModel userModel) async {
    final prefs = await _getPrefs();
    if (userModel.user.firstName.isEmpty) {
      AppLogger.log('❌ Warning: Saving UserModel with empty firstName');
    }
    final jsonString = jsonEncode(userModel.toJson());
    await prefs.setString(_userModelKey, jsonString);
    AppLogger.log('[Shared_Pref] Saved User Model: $jsonString');
  }

  static Future<UserModel?> getUserModel() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_userModelKey);
    if (jsonString == null) {
      AppLogger.log('❌ SharedPreferences: No UserModel found');
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final userModel = UserModel.fromJson(jsonMap);
      if (userModel.user.firstName.isEmpty) {
        AppLogger.log(
          '❌ SharedPreferences: Retrieved UserModel with empty firstName',
        );
      }
      return userModel;
    } catch (e) {
      AppLogger.log(
        '❌ SharedPreferences: Failed to decode user model: $e - clearing corrupt key',
      );
      await prefs.remove(_userModelKey);
      return null;
    }
  }

  static Future<void> clearUserModel() async {
    final prefs = await _getPrefs();
    await prefs.remove(_userModelKey);
    AppLogger.log('✅ SharedPreferences: UserModel cleared');
  }

  // ----------------- Kapu Onboarding Handling -----------------
  static Future<bool> hasVisitedKapu(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_visited_kapu_$userId';
    final visited = prefs.getBool(key) ?? false;
    AppLogger.log(
      visited
          ? '📗 [KAPU PREF] User $userId has visited Kapu onboarding before.'
          : '🟡 [KAPU PREF] User $userId has NOT visited Kapu onboarding yet.',
    );
    return visited;
  }

  static Future<void> markKapuVisited(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_visited_kapu_$userId';
    await prefs.setBool(key, true);
    AppLogger.log('✅ [KAPU PREF] Marked user $userId as having visited Kapu.');
  }

  static Future<void> resetKapuVisit(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_visited_kapu_$userId';
    await prefs.remove(key);
    AppLogger.log('🔁 [KAPU PREF] Reset Kapu visit for user $userId.');
  }

  // ----------------- Kapu Interaction Handling -----------------
  static Future<bool> hasUsedKapu(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_used_kapu_$userId';
    final used = prefs.getBool(key) ?? false;
    AppLogger.log(
      used
          ? '🟢 [KAPU PREF] User $userId has used Kapu before.'
          : '🟠 [KAPU PREF] User $userId has NOT used Kapu yet.',
    );
    return used;
  }

  static Future<void> markKapuUsed(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_used_kapu_$userId';
    await prefs.setBool(key, true);
    AppLogger.log('✅ [KAPU PREF] Marked user $userId as having used Kapu.');
  }

  static Future<void> resetKapuUsage(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_used_kapu_$userId';
    await prefs.remove(key);
    AppLogger.log('🔁 [KAPU PREF] Reset Kapu usage for user $userId.');
  }

  // ----------------- Kapu Interaction Flag -----------------
  static Future<bool> hasInteractedWithKapu(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_interacted_with_kapu_$userId';
    final interacted = prefs.getBool(key) ?? false;
    AppLogger.log(
      interacted
          ? '🟢 [KAPU PREF] User $userId has interacted with Kapu before.'
          : '🟡 [KAPU PREF] User $userId has NOT interacted with Kapu yet.',
    );
    return interacted;
  }

  static Future<void> markKapuInteracted(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_interacted_with_kapu_$userId';
    await prefs.setBool(key, true);
    AppLogger.log('✅ [KAPU PREF] Marked user $userId as having interacted with Kapu.');
  }

  static Future<void> resetKapuInteraction(String userId) async {
    final prefs = await _getPrefs();
    final key = 'has_interacted_with_kapu_$userId';
    await prefs.remove(key);
    AppLogger.log('🔁 [KAPU PREF] Reset Kapu interaction for user $userId.');
  }

  // ----------------- Bookings Handling -----------------
  static Future<void> saveBookings(AllBookingsResponse bookingsResponse) async {
    final prefs = await _getPrefs();
    final jsonString = jsonEncode(bookingsResponse.toJson());
    await prefs.setString(_bookingsKey, jsonString);
    AppLogger.log('[Shared_Pref] Saved Bookings: $jsonString');
  }

  static Future<AllBookingsResponse?> getBookingsModel() async {
    final prefs = await _getPrefs();
    final jsonString = prefs.getString(_bookingsKey);
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return AllBookingsResponse.fromJson(jsonMap);
    } catch (e) {
      AppLogger.log(
        '❌ SharedPreferences: Failed to decode bookings: $e - clearing corrupt key',
      );
      await prefs.remove(_bookingsKey);
      return null;
    }
  }

  static Future<void> clearBookings() async {
    final prefs = await _getPrefs();
    await prefs.remove(_bookingsKey);
  }

  // ----------------- Logout -----------------
  static Future<void> logout() async {
    final prefs = await _getPrefs();
    await prefs.remove(_userModelKey);
    AppLogger.log("✅ User successfully logged out");
  }
}
