import 'package:flutter/material.dart';
import 'FlavorCraft.dart'; // Импортируем экран FlavorCraft
import 'unlogin.dart'; // Импортируем экран UnloginScreen

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // Ключ для формы

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
                  Icons.login, // Иконка для входа
                  size: 100,
                  color: Colors.black54,
                ),
                SizedBox(height: 20),
                // Заголовок
                Text(
                  'Войти',
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
                _buildTextField('Почта'),
                SizedBox(height: 16),
                _buildTextField('Пароль', obscureText: true),
                SizedBox(height: 30),
                // Кнопка входа
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) { // Валидация формы
                      // Переход на экран FlavorCraft
                      Navigator.push(
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
                    'Войти',
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

  Widget _buildTextField(String hintText, {bool obscureText = false}) {
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
          return 'Пожалуйста, заполните это поле'; // Сообщение об ошибке
        }
        return null;
      },
    );
  }
}
