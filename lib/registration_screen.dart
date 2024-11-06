import 'package:flutter/material.dart';
import 'FlavorCraft.dart'; // Импортируем экран FlavorCraft

class RegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // Ключ для формы

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Аккаунт успешно создан!',
          style: TextStyle(fontFamily: 'Montserrat'), // Используем Montserrat
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Светлый фон
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Добавляем ключ для формы
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Логотип или изображение
                Icon(
                  Icons.email, // Иконка для регистрации
                  size: 100,
                  color: Colors.black54,
                ),
                SizedBox(height: 20),
                // Заголовок
                Text(
                  'Создать аккаунт',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 40),
                // Поля ввода
                _buildTextField('Почта', context), // Добавили контекст
                SizedBox(height: 16),
                _buildTextField('Пароль', context, obscureText: true), // Добавили контекст
                SizedBox(height: 16),
                _buildTextField('Подтверждение пароля', context, obscureText: true), // Добавили контекст
                SizedBox(height: 30),
                // Кнопка создания аккаунта
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) { // Валидация формы
                      _showSuccessSnackBar(context); // Отображение SnackBar
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FlavorCraft()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Синий фон
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50), // Растягиваем кнопку на всю ширину
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Углы округлые
                    ),
                  ),
                  child: Text(
                    'Создать аккаунт',
                    style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Назад',
                    style: TextStyle(fontFamily: 'Montserrat', color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText, BuildContext context, {bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, заполните это поле';
        }
        return null;
      },
    );
  }
}
