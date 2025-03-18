import 'package:flutter/material.dart';

class Note extends StatelessWidget {
  final void Function()? onLongPress;
  final String title;

  const Note({super.key, required this.title, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Alegem culorile pe baza temei active
    Color noteColor =
        isDarkMode ? Colors.grey[800]! : Colors.greenAccent.shade100;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color deleteIconColor = isDarkMode ? Colors.redAccent : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: noteColor, // Culoare fundal bazată pe tema activă
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Culoare text pe baza temei
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onLongPress,
                child: Icon(
                  Icons.delete,
                  color: deleteIconColor, // Culoare iconiță pe baza temei
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
