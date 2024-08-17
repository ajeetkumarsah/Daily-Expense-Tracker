import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/database_provider.dart';

class AuthRepository {
  Future<int> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final db = await DatabaseProvider().database;
    await prefs.setString('username', user.username);
    return await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await DatabaseProvider().database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      User user = User.fromMap(result.first);
      // Save the user login state in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      await prefs.setInt('userId', user.id ?? 0);

      return user;
    }
    return null;
  }

  Future<bool> logoutUser() async {
    // Remove the user login state from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }

  Future<bool> checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }
}
