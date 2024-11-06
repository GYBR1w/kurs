import 'package:flutter/material.dart';
import 'RecipeDetailScreen.dart';

class Recipe {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });
}

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final List<Recipe> recipes = [
    Recipe(
      title: 'Спагетти Карбонара',
      description: 'Классическое итальянское блюдо из спагетти с соусом на основе яиц и сыра, с добавлением панчетты.',
      imageUrl: 'https://eda.ru/images/RecipeOpenGraph/1200x630/pasta-karbonara-pasta-alla-carbonara_50865_ogimage.jpg',
      ingredients: ['Спагетти (400 г)', 'Панчетта (150 г)', 'Яйцо (2 шт.)', 'Пармезан (50 г)', 'Чёрный перец (по вкусу)', 'Соль (по вкусу)'],
      instructions: '1. Отварите спагетти в большом количестве подсоленной воды до состояния аль денте.\n2. Нарежьте панчетту мелкими кубиками и обжарьте на сковороде до золотистой корочки.\n3. В отдельной миске взбейте яйца с тертым пармезаном и чёрным перцем.\n4. Когда спагетти будут готовы, слейте воду и быстро добавьте их в сковороду с панчеттой.\n5. Снимите с огня и сразу же добавьте яичную смесь, хорошо перемешивая.\n6. Подавайте с дополнительным тертым пармезаном и чёрным перцем по вкусу.',
    ),
  ];

  void _addRecipe(String title, String description, String imageUrl, List<String> ingredients, String instructions) {
    setState(() {
      recipes.add(Recipe(
        title: title,
        description: description,
        imageUrl: imageUrl,
        ingredients: ingredients,
        instructions: instructions,
      ));
    });
  }

  Future<void> _showAddRecipeDialog() async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController ingredientsController = TextEditingController();
    final TextEditingController instructionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить новый рецепт'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: 'Название')),
              TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Описание')),
              TextField(controller: imageUrlController, decoration: InputDecoration(labelText: 'URL изображения')),
              TextField(controller: ingredientsController, decoration: InputDecoration(labelText: 'Ингредиенты (через запятую)')),
              TextField(controller: instructionsController, decoration: InputDecoration(labelText: 'Инструкции')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final ingredients = ingredientsController.text.split(',').map((s) => s.trim()).toList();
                _addRecipe(
                  titleController.text,
                  descriptionController.text,
                  imageUrlController.text,
                  ingredients,
                  instructionsController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Рецепты',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailScreen(recipe: recipe),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddRecipeDialog,
        child: Icon(Icons.add),
        tooltip: 'Добавить рецепт',
      ),
    );
  }
}
