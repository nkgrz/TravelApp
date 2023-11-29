import 'package:flutter/material.dart';
import 'package:travel_app/screens/cart_screen.dart';
import 'package:travel_app/screens/favourites_screen.dart';
import 'screens/regions_screen.dart';
import 'screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TravelAgencyApp());
}

class TravelAgencyApp extends StatelessWidget {
  const TravelAgencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
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
        '/profile': (context) => const ProfileScreen(),
        // ... возможно, другие маршруты ...
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const RegionsScreen(),
    const CartScreen(),
    const Favourites(),
    const ProfileScreen(),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Места',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Корзина',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
        // fixedColor: Colors.amber,
        unselectedItemColor: Colors.grey, // Цвет для не выбранных вкладок
        selectedItemColor: Colors.amber, // Цвет для выбранной вкладки
      ),
    );
  }
}

class RegionsScreen extends StatelessWidget {
  const RegionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор региона'),
      ),
      body: const RegionsList(), // Показывает плашки с регионами
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Корзина'),
        ),
        body: const Padding(
          // Отступ между AppBar и первым элементом
          padding: EdgeInsets.only(
              top: 10,
              left: 7,
              right: 7), 
          child: CartList(),
        ));
  }
}

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Избранное'),
        ),
        body: const Padding(
          // Отступ между AppBar и первым элементом
          padding: EdgeInsets.only(
              top: 10,
              left: 7,
              right: 7),
          child: FavouritesList(),
        ));
  }
}