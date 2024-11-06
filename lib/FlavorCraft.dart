import 'package:flutter/material.dart';
import 'Profile.dart'; // Импортируем экран профиля

class FlavorCraft extends StatefulWidget {
  @override
  _FlavorCraftState createState() => _FlavorCraftState();
}

class _FlavorCraftState extends State<FlavorCraft> {
  int _selectedIndex = 0; // Индекс выбранной вкладки

  // Список виджетов для каждой вкладки
  static const List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Контент для Главной вкладки', style: TextStyle(fontSize: 24))),
    Center(child: Text('Контент для Поиска', style: TextStyle(fontSize: 24))),
    Center(child: Text('Контент для Избранного', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    if (index == 3) { // Если нажат элемент "Профиль"
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()), // Переход на экран профиля
      );
    } else {
      setState(() {
        _selectedIndex = index; // Обновляем индекс выбранной вкладки
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Белый фон
      body: _selectedIndex < 3 ? _widgetOptions.elementAt(_selectedIndex) : Container(), // Отображаем соответствующий контент
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
        selectedItemColor: Colors.black, // Цвет выбранной иконки
        unselectedItemColor: Colors.black, // Цвет невыбранных иконок
        backgroundColor: Colors.white, // Белый фон для нижней панели
        elevation: 0, // Убираем тень
        onTap: _onItemTapped, // Обработчик нажатия
      ),
    );
  }
}
