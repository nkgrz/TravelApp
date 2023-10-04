import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'regions.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TravelAgencyApp());
}

class TravelAgencyApp extends StatelessWidget {
	@override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          toolbarHeight: 40.0, // Высота AppBar
          color: Colors.amber, // Цвет AppBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Задайте желаемое значение радиуса скругления
            ),
            // Если вы хотите задать другие стили для кнопок, добавьте их здесь
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
    @override
    _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
    int _currentIndex = 0;

    final List<Widget> _tabs = [
        RegionsScreen(),
        CartScreen(),
        ProfileScreen(),
    ];

    void _onTabTapped(int index) {
        setState(() {
        _currentIndex = index;
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        body: _tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: 'Места',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Корзина',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
            ),
            ],
            fixedColor: Colors.amber,
        ),
        );
    }
}

class CartScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Корзина'),
            ),
            body: Center(
                child: Text('Содержимое корзины'),
            ),
        );
    }
}

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isRegistering) ...[
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: 'Имя'),
                      ),
                      SizedBox(height: 16),
                    ],
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
                      onPressed: () async {
                        var user;
                        if (_isRegistering) {
                          user = await authService.registerUser(
                              _emailController.text, _passwordController.text);
                          if (user != null) {
                            await user.updateDisplayName(_nameController.text);
                          }
                        } else {
                          user = await authService.loginUser(
                              _emailController.text, _passwordController.text);
                        }

                        if (user != null) {
                          setState(() {
                            _currentUser = user;
                          });
                        } else {
                          // Обработка ошибок
                        }
                      },
                      child: Text(_isRegistering ? 'Зарегистрироваться' : 'Войти'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(
                        _isRegistering ? 'Уже зарегистрированы? Войти' : 'Регистрация',
                      ),
                    ),
                  ],
                ),
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


class RegionsScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
            title: Text('Выбор региона'),
            ),
            body: 
                RegionsList(), // Показывает плашки с регионами
        );
    }
}

// Авторизация
final AuthService authService = AuthService();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Авторизация")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () async {
                var user = await authService.loginUser(_emailController.text, _passwordController.text);
                if (user != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                } else {
                  // Обработка ошибок
                }
              },
              child: Text('Войти'),
            ),
            ElevatedButton(
              onPressed: () async {
                var user = await authService.registerUser(_emailController.text, _passwordController.text);
                if (user != null) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                } else {
                  // Обработка ошибок
                }
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Вход
  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);  // Добавить обработку ошибок
      return null;
    }
  }

  // Регистрация
  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);  // Добавить обработку ошибок
      return null;
    }
  }

  // Выход
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;
}
