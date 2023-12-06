class Validation {
  static bool isValidEmail(String email) {
    final RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$");
    return emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Проверка длины пароля и состоит ли он только из символов английского алфавита
    final RegExp passwordRegExp = RegExp(r"^[a-zA-Z0-9]{8,}$");
    return passwordRegExp.hasMatch(password);
  }
}
