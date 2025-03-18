import 'package:flutter/material.dart';

class FloatingbuttonNote extends StatelessWidget {
  final void Function()? onPressed;
  final Color buttonColor;

  const FloatingbuttonNote({
    super.key,
    required this.onPressed,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Alegem culoarea butonului și a iconiței pe baza temei
    Color buttonBackgroundColor = isDarkMode ? Colors.grey[800]! : buttonColor;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: buttonBackgroundColor,
      child: Icon(
        Icons.add,
        color: iconColor,
      ),
    );
  }
}
