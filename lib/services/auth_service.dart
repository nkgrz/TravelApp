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

  // Метод для повторной аутентификации пользователя
  Future<void> reauthenticateUser(String email, String oldPassword) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null && email.isNotEmpty && oldPassword.isNotEmpty) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: oldPassword,
      );

      try {
        // Повторная аутентификация
        await currentUser.reauthenticateWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        // Здесь можно добавить обработку различных ошибок аутентификации
        throw FirebaseAuthException(code: e.code, message: e.message);
      }
    }
  }
}
