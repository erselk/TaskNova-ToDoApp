import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "User";
  int _avatarColorIndex = 0; // 0-based index for predefined colors
  String? _profileImagePath;
  bool _isLoading = true;

  String get userName => _userName;
  int get avatarColorIndex => _avatarColorIndex;
  String? get profileImagePath => _profileImagePath;
  bool get isLoading => _isLoading;

  // Predefined avatar colors
  static List<Color> get avatarColors => [
    const Color(0xFF4F46E5), // Indigo (Default)
    const Color(0xFFEF4444), // Red
    const Color(0xFFF59E0B), // Amber
    const Color(0xFF10B981), // Emerald
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF8B5CF6), // Violet
    const Color(0xFFEC4899), // Pink
    const Color(0xFF14B8A6), // Teal
  ];

  Color get currentAvatarColor {
    if (UserProvider.avatarColors.isEmpty) return Colors.blue;
    return UserProvider.avatarColors[_avatarColorIndex % UserProvider.avatarColors.length];
  }

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('userName') ?? "User";
      _avatarColorIndex = prefs.getInt('avatarColorIndex') ?? 0;
      _profileImagePath = prefs.getString('profileImagePath');
    } catch (e) {
      if (kDebugMode) {
        print("Error loading user data: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserData({required String name, required int colorIndex, String? imagePath}) async {
    _userName = name;
    _avatarColorIndex = colorIndex;
    if (imagePath != null) {
      _profileImagePath = imagePath;
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setInt('avatarColorIndex', colorIndex);
      if (imagePath != null) {
        await prefs.setString('profileImagePath', imagePath);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving user data: $e");
      }
    }
  }

  Future<void> clearUserData() async {
    _userName = "User";
    _avatarColorIndex = 0;
    _profileImagePath = null;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('avatarColorIndex');
    await prefs.remove('profileImagePath');
  }
}
