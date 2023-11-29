import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

final AuthService authService = AuthService();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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
        const Text("Вход",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Пароль'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleLogin,
          child: const Text('Войти'),
        ),
        TextButton(
          onPressed: () => setState(() => _isRegistering = true),
          child: const Text('Регистрация'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        const Text("Регистрация",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Имя'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(labelText: 'E-mail'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(labelText: 'Пароль'),
          obscureText: true,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _handleRegister,
          child: const Text('Зарегистрироваться'),
        ),
        TextButton(
          onPressed: () => setState(() => _isRegistering = false),
          child: const Text('Уже зарегистрированы? Войти'),
        ),
      ],
    );
  }

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

  void _handleLogin() async {
    if (!isValidEmail(_emailController.text)) {
      _showErrorDialog("Введите корректный e-mail");
      return;
    }

    if (!isValidPassword(_passwordController.text)) {
      _showErrorDialog(
          "Пароль должен содержать не менее 8 символов и состоять только из символов английского алфавита");
      return;
    }

    try {
      var user = await authService.loginUser(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        setState(() => _currentUser = user);
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        // print("Firebase error code: ${error.code}");
        switch (error.code) {
          case 'user-not-found':
            _showErrorDialog("Пользователь с таким e-mail не зарегистрирован");
            break;
          case 'wrong-password':
            _showErrorDialog("Неверный пароль");
            break;
          case 'INVALID_LOGIN_CREDENTIALS':
            _showErrorDialog(
                "Неверные учетные данные. Пожалуйста, проверьте ваш e-mail и пароль и попробуйте снова");
            break;
          case 'too-many-requests':
            _showErrorDialog("Слишком много попыток входа. Попробуйте позднее");
            break;
          default:
            _showErrorDialog("Произошла ошибка при входе. Попробуйте снова.");
        }
      } else {
        _showErrorDialog("Неизвестная ошибка. Пожалуйста, попробуйте снова.");
      }
    }
  }

  void _handleRegister() async {
    if (!isValidEmail(_emailController.text)) {
      _showErrorDialog("Введите корректный e-mail");
      return;
    }

    if (!isValidPassword(_passwordController.text)) {
      _showErrorDialog(
          "Пароль должен содержать не менее 8 символов и состоять только из символов английского алфавита");
      return;
    }
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
      if (error is FirebaseAuthException &&
          error.code == 'email-already-in-use') {
        _showErrorDialog("Пользователь с таким e-mail уже зарегистрирован");
      } else {
        _showErrorDialog(error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
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
                child:
                    _isRegistering ? _buildRegisterForm() : _buildLoginForm(),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text("Профиль")),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _currentUser!.photoURL != null
                      ? NetworkImage(_currentUser!.photoURL!)
                      : const AssetImage("assets/default_avatar.png")
                          as ImageProvider,
                ),
                const SizedBox(height: 20),
                Text(
                    'Привет, ${_currentUser!.displayName ?? _currentUser!.email}!',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(_currentUser!.email ?? 'Нет адреса электронной почты',
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await authService.logout();
                    setState(() {
                      _currentUser = null;
                    });
                  },
                  child: const Text('Выйти'),
                ),
                const SizedBox(height: 10),
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
  }
}

bool isValidEmail(String email) {
  final RegExp emailRegExp =
      RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
  return emailRegExp.hasMatch(email);
}

bool isValidPassword(String password) {
  // Проверка длины пароля и состоит ли он только из символов английского алфавита
  final RegExp passwordRegExp = RegExp(r"^[a-zA-Z0-9]{8,}$");
  return passwordRegExp.hasMatch(password);
}

class EditProfileScreen extends StatefulWidget {
  final User currentUser;

  const EditProfileScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayNameController.text = widget.currentUser.displayName ?? '';
    _emailController.text = widget.currentUser.email ?? '';
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    try {
      await widget.currentUser.updateDisplayName(_displayNameController.text);
      // Опционально: обновите адрес электронной почты
      // await widget.currentUser.updateEmail(_emailController.text);
      if (_oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty) {
        // Возможно, потребуется повторная аутентификация пользователя перед сменой пароля
        // Firebase Auth требует недавней аутентификации для операций, влияющих на безопасность
        await authService.reauthenticateUser(
          _emailController.text,
          _oldPasswordController.text,
        );
        await widget.currentUser.updatePassword(_newPasswordController.text);
      }
      // Navigator.pop;
      Navigator.of(context).pop(); // Возвращаемся назад с обновленными данными
    } catch (error) {
      // Обработка ошибок, например, показ диалогового окна с ошибкой
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование Профиля'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveProfile),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: _oldPasswordController,
              decoration: const InputDecoration(labelText: 'Старый пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: 'Новый пароль'),
              obscureText: true,
            ),
            // Дополнительные поля, если необходимо
          ],
        ),
      ),
    );
  }
}
