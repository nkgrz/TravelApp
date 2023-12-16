import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/screens/cart_screen.dart';
import 'package:travel_app/screens/favourites_screen.dart';
import 'package:travel_app/screens/profile/profile_screen.dart';
import 'package:travel_app/services/local_data.dart';
import 'package:travel_app/utils/change_theme.dart';
import 'screens/regions_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await loadData();
  runApp(const TravelAgencyApp());
}

class TravelAgencyApp extends StatelessWidget {
  const TravelAgencyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeProvider(), // Инициализация провайдера темы
        child:
            Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
          return MaterialApp(
            home: const MainScreen(),
            theme: themeProvider.isDarkMode
                ? MyAppTheme.darkTheme
                : MyAppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            routes: {
              '/profile': (context) => const ProfileScreen(),
              // ... возможно, другие маршруты ...
            },
          );
        }));
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
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
        title: const Text('Направления',
            style: TextStyle(fontWeight: FontWeight.w500)),
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
          title: const Text('Корзина',
              style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        body: const Padding(
          // Отступ между AppBar и первым элементом
          padding: EdgeInsets.only(top: 10, left: 7, right: 7),
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
          title: const Text('Избранное',
              style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        body: const Padding(
          // Отступ между AppBar и первым элементом
          padding: EdgeInsets.only(top: 10, left: 7, right: 7),
          child: FavouritesList(),
        ));
  }
}

class MyAppTheme {
  // Параметры для светлой темы
  static ThemeData lightTheme = ThemeData.light().copyWith(
    // Межстрочный интервал(после обновления Flutter по умолчанию 1.5 или 2 по ощущениям)
    // Поэтому вручную меняю на 1.2
    textTheme: const TextTheme(
      bodyLarge: TextStyle(height: 1.2, color: Colors.black),
      bodyMedium: TextStyle(height: 1.2, color: Colors.black),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 40.0,
      color: Colors.amber[300],
      shadowColor: Colors.black,
      elevation: 4,
    ),
    // тень AppBar
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // Стили других кнопок если потребуется прописать тут
      ),
    ),
  );

  // Параметры для темной темы
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    textTheme: const TextTheme(
      bodyLarge: TextStyle(height: 1.2),
      bodyMedium: TextStyle(height: 1.2),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 40.0,
      color: Colors.grey[800],
      shadowColor: Colors.black,
      elevation: 4,
    ),
    // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}