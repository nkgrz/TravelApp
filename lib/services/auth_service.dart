import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Вход
  Future<User?> loginUser(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Регистрация
  Future<User?> registerUser(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  // Выход
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;
}
