import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final void Function()? onTap;

  const AppTile({
    super.key,
    required this.name,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Alegem culoarea de fundal pe baza temei
    Color tileColor = isDarkMode ? Colors.grey[800]! : Colors.blue;
    Color textColor = isDarkMode ? Colors.white : Colors.white;
    Color iconColor = isDarkMode ? Colors.white : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
