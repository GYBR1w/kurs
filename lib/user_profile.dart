import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/recipe.dart';

class UserProfile extends ChangeNotifier {
  String _email = '';
  String _name = '';
  String _avatar = '';
  final Set<Recipe> _favoriteRecipes = {};

  String get email => _email;
  String get name => _name;
  String get avatar => _avatar;
  List<Recipe> get favoriteRecipes => List.unmodifiable(_favoriteRecipes.toList());

  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
    _saveToPrefs();
  }

  void updateName(String newName) {
    _name = newName;
    notifyListeners();
    _saveToPrefs();
  }

  void updateAvatar(String newAvatar) {
    _avatar = newAvatar;
    notifyListeners();
    _saveToPrefs();
  }

  void addFavoriteRecipe(Recipe recipe) {
    if (_favoriteRecipes.add(recipe)) {
      notifyListeners();
      _saveToPrefs();
    }
  }

  void removeFavoriteRecipe(Recipe recipe) {
    if (_favoriteRecipes.remove(recipe)) {
      notifyListeners();
      _saveToPrefs();
    }
  }

  bool isFavorite(Recipe recipe) {
    return _favoriteRecipes.any((r) => r.id == recipe.id);
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email);
    await prefs.setString('name', _name);
    await prefs.setString('avatar', _avatar);
    await prefs.setString(
      'favoriteRecipes',
      jsonEncode(_favoriteRecipes.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString('email') ?? '';
    _name = prefs.getString('name') ?? '';
    _avatar = prefs.getString('avatar') ?? '';

    final favoritesJson = prefs.getString('favoriteRecipes');
    if (favoritesJson != null) {
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      _favoriteRecipes.clear();
      _favoriteRecipes.addAll(
        decoded.map((json) => Recipe.fromJson(json)),
      );
    }

    notifyListeners();
  }

  void clear() {
    _email = '';
    _name = '';
    _avatar = '';
    _favoriteRecipes.clear();
    notifyListeners();
    _saveToPrefs();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _email = '';
    _name = '';
    _avatar = '';
    _favoriteRecipes.clear();
    notifyListeners();
  }
}
