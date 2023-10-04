import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

final AuthService authService = AuthService();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  User? _currentUser;
  final _nameController = TextEditingController();
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _currentUser = authService.currentUser;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'E-mail'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Пароль'),
          obscureText: true,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleLogin,
          child: Text('Войти'),
        ),
        TextButton(
          onPressed: () => setState(() => _isRegistering = true),
          child: Text('Регистрация'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Имя'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'E-mail'),
        ),
        SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(labelText: 'Пароль'),
          obscureText: true,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleRegister,
          child: Text('Зарегистрироваться'),
        ),
        TextButton(
          onPressed: () => setState(() => _isRegistering = false),
          child: Text('Уже зарегистрированы? Войти'),
        ),
      ],
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Ок'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _handleLogin() async {
    try {
      var user = await authService.loginUser(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        setState(() => _currentUser = user);
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  void _handleRegister() async {
    try {
      var user = await authService.registerUser(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        await user.updateDisplayName(_nameController.text);
        setState(() => _currentUser = user);
      }
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isRegistering ? "Регистрация" : "Вход"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _isRegistering ? _buildRegisterForm() : _buildLoginForm(),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text("Профиль")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Добро пожаловать, ${_currentUser!.displayName ?? _currentUser!.email}!'),
              ElevatedButton(
                onPressed: () async {
                  await authService.logout();
                  setState(() {
                    _currentUser = null;
                  });
                },
                child: Text('Выйти'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
