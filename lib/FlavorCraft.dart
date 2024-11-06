import 'package:flutter/material.dart';
import 'Profile.dart'; // Импортируем экран профиля
import 'RecipeScreen.dart'; // Импортируем экран рецептов

class FlavorCraft extends StatefulWidget {
  @override
  _FlavorCraftState createState() => _FlavorCraftState();
}

class _FlavorCraftState extends State<FlavorCraft> {
  int _selectedIndex = 0; // Индекс выбранной вкладки

  // Список виджетов для каждой вкладки
  static List<Widget> _widgetOptions = <Widget>[
    RecipeScreen(), // Экран рецептов
    Center(child: Text('Контент для Поиска', style: TextStyle(fontSize: 24))),
    Center(child: Text('Контент для Избранного', style: TextStyle(fontSize: 24))),
    ProfileScreen(), // Экран профиля
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Обновляем индекс выбранной вкладки
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Белый фон
      body: _widgetOptions.elementAt(_selectedIndex), // Отображаем соответствующий контент
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black), // Иконка дома
            label: 'Главное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black), // Иконка поиска
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black), // Иконка избранного
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black), // Иконка профиля
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex, // Устанавливаем текущий индекс
        selectedItemColor: Colors.blueAccent, // Цвет выбранного элемента
        onTap: _onItemTapped, // Обработчик нажатий
      ),
    );
  }
}
