import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final void Function()? onPressed;

  const MyButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Alegem culorile pe baza temei active
    Color buttonTextColor = isDarkMode ? Colors.white : Colors.black;
    Color iconColor = isDarkMode ? Colors.white : Colors.black;
    Color buttonBorderColor = isDarkMode ? Colors.white : Colors.black;

    return TextButton.icon(
      onPressed: onPressed,
      label: Text(
        label,
        style: TextStyle(color: buttonTextColor), // Culoare text pe baza temei
      ),
      icon: Icon(
        icon.icon,
        color: iconColor, // Culoare iconiță pe baza temei
      ),
      style: TextButton.styleFrom(
        side: BorderSide(
            color: buttonBorderColor), // Culoare border pe baza temei
      ),
    );
  }
}
