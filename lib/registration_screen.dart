import 'package:flutter/material.dart';
import 'FlavorCraft.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class RegistrationScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _showSuccessSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Аккаунт успешно создан!',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.email,
                  size: 100,
                  color: Colors.black54,
                ),
                SizedBox(height: 20),
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
                _buildTextField('Почта', context, controller: _emailController),
                SizedBox(height: 16),
                _buildTextField('Пароль', context, obscureText: true, controller: _passwordController),
                SizedBox(height: 16),
                _buildTextField('Подтверждение пароля', context, obscureText: true, controller: _confirmPasswordController),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final userProfile = Provider.of<UserProfile>(context, listen: false);
                      userProfile.updateName(_nameController.text);
                      userProfile.updateEmail(_emailController.text);
                      userProfile.saveUserData();

                      _showSuccessSnackBar(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => FlavorCraft()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildTextField(String hintText, BuildContext context, {bool obscureText = false, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
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
