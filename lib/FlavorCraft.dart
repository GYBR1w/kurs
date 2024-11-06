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
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Главное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            label: 'Поиск',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.black),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Профиль',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        selectedLabelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
        onTap: _onItemTapped,
      ),
    );
  }
}
