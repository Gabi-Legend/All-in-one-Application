import 'package:all_in_app/const/const.dart';
import 'package:all_in_app/pages/home_page.dart';
import 'package:all_in_app/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:all_in_app/components/my_button.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Culori pe baza temei active
    Color drawerHeaderColor = isDarkMode ? Colors.grey[850]! : Colors.blue;
    Color buttonTextColor = isDarkMode ? Colors.white : Colors.black;
    Color footerTextColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [drawerHeaderColor, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  appName, //TITLE OF THE APP
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Main options in the Drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                MyButton(
                  icon: Icon(Icons.home, color: buttonTextColor),
                  label: 'Home Page',
                  onPressed: () {
                    ///NAVIGATE TO THE HOME PAGE
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HomePage();
                        },
                      ),
                    );
                  },
                ),
                MyButton(
                  icon: Icon(Icons.settings, color: buttonTextColor),
                  label: 'Settings',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return Settings();
                      }),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              version,
              style: TextStyle(fontSize: 14, color: footerTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
