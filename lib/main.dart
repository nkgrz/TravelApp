import 'package:flutter/material.dart';
import 'screens/regions_screen.dart';
import 'screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';

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
                          borderRadius: BorderRadius.circular(20),
                      ),
                      // Стили других кнопок если потребуется прописать тут
                  ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            routes: {
                '/profile': (context) => ProfileScreen(),
                // ... возможно, другие маршруты ...
            },
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





