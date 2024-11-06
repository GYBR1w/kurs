import 'package:flutter/material.dart';
import 'login.dart'; // Импортируем экран входа
import 'registration_screen.dart'; // Импортируем экран регистрации

class UnloginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Светлый фон
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Логотип или изображение
              Icon(
                Icons.star, // Замените на ваше изображение
                size: 100,
                color: Colors.black54,
              ),
              SizedBox(height: 20),
              // Название приложения
              Text(
                'FlavorCraft',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              // Описание
              Text(
                'Личный кулинарный помощник, легкие и вкусные рецепты на каждый день.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Кнопка входа
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Синий фон
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50), // Растягиваем кнопку на всю ширину
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Увеличиваем радиус закругления
                  ),
                ),
                child: Text(
                  'Войти',
                  style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', color: Colors.white),

                ),
              ),
              SizedBox(height: 20),
              // Кнопка "Создать аккаунт"
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.black), // Черная обводка
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Увеличиваем радиус закругления
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50), // Растягиваем кнопку на всю ширину
                ),
                child: Text(
                  'Создать аккаунт',
                  style: TextStyle(fontSize: 18, fontFamily: 'Montserrat', color: Colors.black), // Цвет текста кнопки
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Метод для создания текстового поля
  Widget _buildTextField(String label, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Увеличиваем радиус закругления
        ),
      ),
      style: TextStyle(fontSize: 18), // Увеличиваем размер текста
    );
  }
}
