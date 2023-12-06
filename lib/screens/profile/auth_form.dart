import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/services/auth_service.dart';
import 'package:travel_app/utils/validation.dart';

// Основной виджет для формы аутентификации
class AuthForm extends StatefulWidget {
  final bool isRegistering; // Флаг, указывающий, является ли форма формой регистрации
  final Function(bool) onFormSwitch; // Callback-функция для переключения между формами
  final Function(User? user) onAuthSuccess; // Callback-функция для успешной аутентификации

  const AuthForm({
    Key? key,
    required this.isRegistering,
    required this.onFormSwitch,
    required this.onAuthSuccess,
  }) : super(key: key);

  @override
  AuthFormState createState() => AuthFormState();
}

// Состояние виджета формы аутентификации
class AuthFormState extends State<AuthForm> {
  final _emailController = TextEditingController(); // Контроллер для поля ввода e-mail
  final _passwordController = TextEditingController(); // Контроллер для поля ввода пароля
  final _nameController = TextEditingController(); // Контроллер для поля ввода имени пользователя
  final AuthService _authService = AuthService(); // Сервис аутентификации

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Виджет для построения формы входа
  Widget _buildLoginForm() {
    return Column(
      children: [
        // Заголовок для формы входа
        const Text("Вход",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        // Поле для ввода e-mail
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 16),
        // Поле для ввода пароля
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Пароль'),
          obscureText: true, // Скрываем вводимые символы
        ),
        const SizedBox(height: 16),
        // Кнопка для входа
        ElevatedButton(
          onPressed: _handleLogin,
          child: const Text('Войти'),
        ),
        // Кнопка для переключения на форму регистрации
        TextButton(
          onPressed: () => widget.onFormSwitch(true),
          child: const Text('Регистрация'),
        ),
      ],
    );
  }

  // Виджет для построения формы регистрации
  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Заголовок для формы регистрации
        const Text("Регистрация",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        // Поле для ввода имени
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Имя'),
        ),
        const SizedBox(height: 16),
        // Поле для ввода e-mail
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 16),
        // Поле для ввода пароля
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Пароль'),
          obscureText: true, // Скрываем вводимые символы
        ),
        const SizedBox(height: 16),
        // Кнопка для регистрации
        ElevatedButton(
          onPressed: _handleRegister,
          child: const Text('Зарегистрироваться'),
        ),
        // Кнопка для переключения на форму входа
        TextButton(
          onPressed: () => widget.onFormSwitch(false),
          child: const Text('Уже зарегистрированы? Войти'),
        ),
      ],
    );
  }

  // Всплывающий диалог с сообщением об ошибке
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(
          child: Text('Ошибка'),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ок'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  // Обработчик нажатия на кнопку входа
  void _handleLogin() async {
    if (!Validation.isValidEmail(_emailController.text)) {
      _showErrorDialog("Введите корректный e-mail");
      return;
    }

    if (!Validation.isValidPassword(_passwordController.text)) {
      _showErrorDialog("Пароль должен содержать не менее 8 символов и состоять только из символов английского алфавита");
      return;
    }

    try {
      var user = await _authService.loginUser(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        widget.onAuthSuccess(user);
      }
    } catch (error) {
      _showErrorDialog("Ошибка при входе: ${error.toString()}");
    }
  }

  // Обработчик нажатия на кнопку регистрации
  void _handleRegister() async {
    if (!Validation.isValidEmail(_emailController.text)) {
      _showErrorDialog("Введите корректный e-mail");
      return;
    }

    if (!Validation.isValidPassword(_passwordController.text)) {
      _showErrorDialog("Пароль должен содержать не менее 8 символов и состоять только из символов английского алфавита");
      return;
    }

    try {
      var user = await _authService.registerUser(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        await user.updateDisplayName(_nameController.text);
        widget.onAuthSuccess(user);
      }
    } catch (error) {
      _showErrorDialog("Ошибка при регистрации: ${error.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isRegistering ? _buildRegisterForm() : _buildLoginForm();
  }
}
