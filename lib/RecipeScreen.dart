import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'RecipeDetailScreen.dart';
import 'user_profile.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/recipe.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<Recipe> recipes = [];
  String _searchQuery = '';
  String _selectedCategory = 'Все';
  final List<String> categories = [
    'Все',
    'Первые блюда',
    'Вторые блюда',
    'Салаты',
    'Закуски',
    'Десерты',
    'Напитки'
  ];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recipesString = prefs.getString('recipes');

    if (recipesString != null) {
      final List<dynamic> decoded = json.decode(recipesString);
      setState(() {
        recipes = decoded.map((jsonItem) => Recipe.fromJson(jsonItem)).toList();
      });
    } else {
      setState(() {
        recipes = [
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
        _saveRecipes();
      });
    }
  }

  Future<void> _saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonRecipes =
        recipes.map((recipe) => recipe.toJson()).toList();
    prefs.setString('recipes', json.encode(jsonRecipes));
  }

  List<Recipe> _filteredRecipes() {
    return recipes.where((recipe) {
      final matchesSearch = recipe.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          recipe.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Все' || recipe.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = _filteredRecipes();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Рецепты',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddRecipeDialog(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Поиск рецептов',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedCategory = selected ? category : 'Все';
                        });
                      },
                      backgroundColor: Colors.grey[100],
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: Consumer<UserProfile>(
                builder: (context, userProfile, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final effectiveKeyboardType = maxLines > 1 
        ? TextInputType.multiline 
        : (keyboardType ?? TextInputType.text);
        
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller,
            minLines: maxLines,
            maxLines: null,
            keyboardType: effectiveKeyboardType,
            textInputAction: maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: DropdownButtonFormField<String>(
              value: value,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required IconData icon,
    required int value,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  '$label (мин)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: value.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddRecipeDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _imageUrlController = TextEditingController();
    final _ingredientsController = TextEditingController();
    final _instructionsController = TextEditingController();
    String _selectedCategory = categories[1];
    String _selectedDifficulty = 'Средний';
    int _preparationTime = 30;
    double _rating = 4.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Новый рецепт',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    MediaQuery.of(context).viewInsets.bottom + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: _titleController,
                        label: 'Название блюда',
                        icon: Icons.restaurant_menu,
                      ),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Описание',
                        icon: Icons.description,
                        maxLines: 3,
                      ),
                      _buildTextField(
                        controller: _imageUrlController,
                        label: 'URL изображения',
                        icon: Icons.image,
                        keyboardType: TextInputType.url,
                      ),
                      _buildTextField(
                        controller: _ingredientsController,
                        label: 'Ингредиенты (через запятую)',
                        icon: Icons.format_list_bulleted,
                        maxLines: 3,
                      ),
                      _buildTextField(
                        controller: _instructionsController,
                        label: 'Инструкция приготовления',
                        icon: Icons.receipt_long,
                        maxLines: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildDropdownField(
                              label: 'Категория',
                              icon: Icons.category,
                              value: _selectedCategory,
                              items: categories.where((category) => category != 'Все').toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: _buildTimeField(
                              label: 'Время',
                              icon: Icons.timer,
                              value: _preparationTime,
                              onChanged: (value) {
                                setState(() {
                                  _preparationTime = int.tryParse(value) ?? 30;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      _buildDropdownField(
                        label: 'Сложность',
                        icon: Icons.trending_up,
                        value: _selectedDifficulty,
                        items: ['Легкий', 'Средний', 'Сложный'],
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficulty = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Рейтинг: ${_rating.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < _rating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _rating = index + 1.0;
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_titleController.text.isEmpty ||
                        _descriptionController.text.isEmpty ||
                        _ingredientsController.text.isEmpty ||
                        _instructionsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Пожалуйста, заполните все обязательные поля'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final newRecipe = Recipe(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      imageUrl: _imageUrlController.text.isEmpty
                          ? 'https://via.placeholder.com/400x300?text=Нет+изображения'
                          : _imageUrlController.text,
                      ingredients: _ingredientsController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList(),
                      instructions: _instructionsController.text,
                      category: _selectedCategory,
                      cookingTime: _preparationTime,
                      difficulty: _selectedDifficulty,
                      rating: _rating,
                    );

                    setState(() {
                      recipes.add(newRecipe);
                      _saveRecipes();
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Рецепт "${newRecipe.title}" добавлен'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Добавить рецепт'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfile>(
      builder: (context, userProfile, _) {
        final isFavorite = userProfile.isFavorite(recipe);
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12)),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[100],
                        child: Icon(Icons.restaurant,
                            size: 64, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              recipe.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              if (isFavorite) {
                                userProfile.removeFavoriteRecipe(recipe);
                              } else {
                                userProfile.addFavoriteRecipe(recipe);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.cookingTime} мин',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.restaurant_menu,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            recipe.category,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
