// Импорт необходимых библиотек
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/services/auth_service.dart';
import 'package:travel_app/utils/validation.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// Основной виджет для редактирования профиля пользователя
class EditProfileScreen extends StatefulWidget {
  final User currentUser; // Текущий пользователь

  const EditProfileScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

// Состояние виджета редактирования профиля пользователя
class _EditProfileScreenState extends State<EditProfileScreen> {
  final _displayNameController = TextEditingController(); // Контроллер для поля ввода имени
  final _emailController = TextEditingController(); // Контроллер для поля ввода e-mail
  final _oldPasswordController = TextEditingController(); // Контроллер для поля ввода старого пароля
  final _newPasswordController = TextEditingController(); // Контроллер для поля ввода нового пароля
  final AuthService _authService = AuthService(); // Сервис аутентификации

  @override
  void initState() {
    super.initState();
    // Устанавливаем начальные значения полей из данных текущего пользователя
    _displayNameController.text = widget.currentUser.displayName ?? '';
    _emailController.text = widget.currentUser.email ?? '';
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Всплывающий диалог с сообщением об ошибке
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(child: Text('Ошибка')),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Ок'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Запрос разрешения на доступ к галерее и выбор изображения
  Future<void> _requestGalleryPermission() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      // Разрешение получено, можно использовать ImagePicker
      _pickAndUploadImage();
    } else if (status.isDenied) {
      // Пользователь отказал в доступе, показываем сообщение
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      // Пользователь навсегда запретил доступ, перенаправляем его к настройкам устройства
      openAppSettings();
    }
  }

  // Всплывающий диалог с сообщением о запрете доступа к галерее
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(child: Text('Ошибка')),
        content: const Text(
            'Для загрузки изображения разрешение на доступ к галерее не предоставлено.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ок'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Выбор изображения из галереи и его загрузка
  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final File imageFile = File(image.path);
    try {
      // Создание ссылки на хранилище Firebase
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(widget.currentUser.uid + '.jpg');

      // Загрузка изображения
      await ref.putFile(imageFile);

      // Получение URL изображения
      final url = await ref.getDownloadURL();

      // Обновление профиля пользователя с новой фотографией
      await widget.currentUser.updatePhotoURL(url);
    } catch (error) {
      _showErrorDialog("Ошибка при загрузке изображения: ${error.toString()}");
    }
  }

  // Сохранение изменений профиля пользователя
  Future<void> _saveProfile() async {
    if (!Validation.isValidEmail(_emailController.text)) {
      _showErrorDialog("Введите корректный e-mail");
      return;
    }

    try {
      await widget.currentUser.updateDisplayName(_displayNameController.text);
      // Опционально: обновите адрес электронной почты
      // await widget.currentUser.updateEmail(_emailController.text);

      if (_oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty) {
        // Возможно, потребуется повторная аутентификация пользователя перед сменой пароля
        await _authService.reauthenticateUser(
          widget.currentUser.email!,
          _oldPasswordController.text,
        );
        await widget.currentUser.updatePassword(_newPasswordController.text);
      }
      Navigator.of(context).pop(); // Возвращаемся назад с обновленными данными
    } catch (error) {
      _showErrorDialog("Ошибка при обновлении профиля: ${error.toString()}");
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
            // Кнопка для выбора изображения
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text('Загрузить фото'),
              onPressed: _requestGalleryPermission,
            ),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
