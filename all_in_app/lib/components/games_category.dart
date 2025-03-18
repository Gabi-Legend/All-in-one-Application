import 'package:flutter/material.dart';

class GamesCategory extends StatelessWidget {
  final String gameName;
  final String gameDescription;
  final Icon gameIcon; // Icon în loc de IconData
  final VoidCallback onPlay;

  const GamesCategory({
    super.key,
    required this.gameName,
    required this.gameDescription,
    required this.gameIcon,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Definirea culorilor pe baza temei active
    Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    Color descriptionColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;
    Color iconBackgroundColor =
        isDarkMode ? Colors.grey[600]! : Colors.red.shade100;
    Color playButtonColor = isDarkMode ? Colors.red.shade800 : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: cardBackgroundColor, // Culoare fundal pe baza temei
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon-ul jocului
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBackgroundColor, // Culoare iconiței pe baza temei
                shape: BoxShape.circle,
              ),
              child: gameIcon, // Afișează direct obiectul Icon
            ),
            const SizedBox(width: 15),
            // Detaliile jocului
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    gameName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor, // Culoare text pe baza temei
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    gameDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          descriptionColor, // Culoare descriere pe baza temei
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Butonul pentru a începe jocul
            ElevatedButton(
              onPressed: onPlay,
              style: ElevatedButton.styleFrom(
                backgroundColor: playButtonColor, // Culoare buton pe baza temei
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Play",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
