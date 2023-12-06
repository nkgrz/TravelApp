import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_form.dart';
import 'edit_profile_screen.dart';
import 'package:travel_app/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  // Текущий аутентифицированный пользователь.
  User? _currentUser = AuthService().currentUser;
  // Состояние, указывающее на то, находится ли пользователь в режиме регистрации.
  bool _isRegistering = false;

  // Функция для обновления состояния аутентификации.
  void _updateAuthState(User? user) {
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isRegistering = false;
      });
    }
  }

  // Построение виджета, который отображает информацию профиля пользователя.
  Widget _buildProfileView() {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Профиль",
              style: TextStyle(fontWeight: FontWeight.w500))),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              // Отображение аватара пользователя.
              CircleAvatar(
                radius: 50,
                backgroundImage: _currentUser!.photoURL != null
                    ? NetworkImage(_currentUser!.photoURL!)
                    : const AssetImage("assets/default_avatar.png")
                        as ImageProvider,
              ),
              const SizedBox(height: 20),
              // Отображение имени или email пользователя.
              Text(
                'Привет, ${_currentUser!.displayName ?? _currentUser!.email}!',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Отображение email пользователя.
              Text(_currentUser!.email ?? 'Нет адреса электронной почты',
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 20),
              // Кнопка выхода из системы.
              ElevatedButton(
                onPressed: () async {
                  await AuthService().logout();
                  _updateAuthState(null);
                },
                child: const Text('Выйти'),
              ),
              const SizedBox(height: 20),
              // Кнопка для перехода к редактированию профиля.
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfileScreen(currentUser: _currentUser!),
                    ),
                  );
                },
                child: const Text('Редактировать Профиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Построение виджета для входа или регистрации пользователя.
  Widget _buildAuthView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
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
              // AuthForm используется для входа или регистрации пользователя.
              child: AuthForm(
                isRegistering: _isRegistering,
                onFormSwitch: (isRegistering) =>
                    setState(() => _isRegistering = isRegistering),
                onAuthSuccess: _updateAuthState,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Основной метод построения UI.
  @override
  Widget build(BuildContext context) {
    // Отображение соответствующего виджета в зависимости от состояния аутентификации.
    return _currentUser == null ? _buildAuthView() : _buildProfileView();
  }
}
