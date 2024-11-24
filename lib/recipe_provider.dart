import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/recipe.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  RecipeProvider() {
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recipesString = prefs.getString('recipes');

    if (recipesString != null) {
      final List<dynamic> decoded = json.decode(recipesString);
      _recipes = decoded.map((jsonItem) => Recipe.fromJson(jsonItem)).toList();
      notifyListeners();
    } else {
      _recipes = [
        Recipe(
          title: 'Спагетти Карбонара',
          description:
              'Классическое итальянское блюдо с беконом и сливочным соусом',
          imageUrl:
              'https://eda.ru/images/RecipeOpenGraph/1200x630/pasta-karbonara-pasta-alla-carbonara_50865_ogimage.jpg',
          ingredients: [
            'Спагетти (400 г)',
            'Панчетта (150 г)',
            'Яйцо (2 шт.)',
            'Пармезан (50 г)',
            'Чёрный перец (по вкусу)',
            'Соль (по вкусу)'
          ],
          instructions:
              '1. Отварите спагетти в подсоленной воде аль денте\n2. Обжарьте панчетту до хрустящей корочки\n3. Смешайте яйца с тёртым пармезаном\n4. Соедините все ингредиенты',
          category: 'Вторые блюда',
          cookingTime: 30,
          difficulty: 'Средний',
          rating: 4.8,
        ),
        Recipe(
          title: 'Борщ',
          description: 'Традиционный украинский борщ со сметаной',
          imageUrl:
              'https://eda.ru/images/RecipePhoto/930x622/borsch-s-hrenom_29213_photo_56956.webp',
          ingredients: [
            'Свекла (1 шт.)',
            'Картофель (3 шт.)',
            'Морковь (1 шт.)',
            'Лук (1 шт.)',
            'Капуста (200 г)'
          ],
          instructions:
              '1. Сварите бульон\n2. Подготовьте овощи\n3. Добавьте их в правильном порядке\n4. Варите до готовности',
          category: 'Первые блюда',
          cookingTime: 120,
          difficulty: 'Сложный',
          rating: 4.9,
        ),
      ];
      saveRecipes();
    }
  }

  Future<void> saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonRecipes =
        _recipes.map((recipe) => recipe.toJson()).toList();
    prefs.setString('recipes', json.encode(jsonRecipes));
    notifyListeners();
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    saveRecipes();
  }

  void removeRecipe(Recipe recipe) {
    _recipes.removeWhere((r) => r.title == recipe.title);
    saveRecipes();
  }
}
