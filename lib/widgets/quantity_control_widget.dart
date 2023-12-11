import 'package:flutter/material.dart';

class QuantityControlWidget extends StatelessWidget {
  final int quantity;
  final Function onAdd;
  final Function onRemove;

  const QuantityControlWidget({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Кнопка "-" для уменьшения количества
        GestureDetector(
          onTap: () => onRemove(),
          // Кнопка удалить
          child: const IconContainerWidget(icon: Icons.remove),
        ),

        const SizedBox(width: 4),

        // Отображение количества товара
        Text('$quantity'),

        const SizedBox(width: 4),
        
        // Кнопка "+" для увеличения количества
        GestureDetector(
          onTap: () => onAdd(),
          child: const IconContainerWidget(icon: Icons.add),
        ),
      ],
    );
  }
}

// Установка ширины, высоты и цвета кнопки удалить/добавить
class IconContainerWidget extends StatelessWidget {
  final IconData icon;

  const IconContainerWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
