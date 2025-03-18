import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color appBarColor;

  const CustomAppBar(
      {super.key, required this.title, required this.appBarColor});

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Alegem culoarea de fundal și a textului în funcție de temă
    Color appBarBackgroundColor = isDarkMode ? Colors.black : appBarColor;
    Color textColor = isDarkMode ? Colors.white : Colors.white;
    Color iconColor = isDarkMode ? Colors.white : Colors.white;

    return AppBar(
      backgroundColor: appBarBackgroundColor,
      iconTheme: IconThemeData(color: iconColor),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: () {
          Navigator.pop(context); // Navighează înapoi la pagina anterioară
        },
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight); // Înălțimea standard a unui AppBar
}
