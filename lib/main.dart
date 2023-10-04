import 'package:flutter/material.dart';
import 'regions.dart';

void main() => runApp(TravelAgencyApp());

class TravelAgencyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
		home: MainScreen(),
		theme: new ThemeData(
			appBarTheme: AppBarTheme(
                toolbarHeight: 40.0, // Установите желаемую высоту AppBar
                color: Colors.amber, // Цвет AppBar
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

class ProfileScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Профиль'),
            ),
            body: Center(
                child: Text('Личный кабинет пользователя'),
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
