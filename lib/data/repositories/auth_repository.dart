import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthRepository {
  static const String _userPrefsKey = 'current_user_session';

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonStr = prefs.getString(_userPrefsKey);
    if (userJsonStr == null || userJsonStr.isEmpty) {
      return null;
    }
    try {
      final Map<String, dynamic> userMap = jsonDecode(userJsonStr);
      return UserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API delay
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Please fill in all fields');
    }

    // Default mock user name from email if not saved
    final userName = email.contains('@') 
        ? email.split('@').first.replaceFirst(email[0], email[0].toUpperCase())
        : 'Sokha';

    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: userName,
      email: email,
      videosCount: 12,
      followersCount: 340,
      followingCount: 45,
      bio: 'Cooking, eating and sharing delicious homemade recipes',
    );

    await _saveUserSession(user);
    return user;
  }

  Future<UserModel> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate API delay
    if (fullName.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Please fill in all required fields');
    }
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: fullName.trim(),
      email: email.trim(),
      videosCount: 0,
      followersCount: 0,
      followingCount: 0,
      bio: 'New home cook',
    );

    await _saveUserSession(user);
    return user;
  }

  Future<UserModel> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = UserModel(
      id: 'usr_google_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Google User',
      email: 'user@gmail.com',
      videosCount: 3,
      followersCount: 120,
      followingCount: 18,
      bio: 'Lover of good food',
    );

    await _saveUserSession(user);
    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userPrefsKey);
  }

  Future<void> _saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(user.toJson());
    await prefs.setString(_userPrefsKey, jsonStr);
  }
}
