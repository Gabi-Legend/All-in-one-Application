import 'package:all_in_app/components/app_tile.dart';
import 'package:all_in_app/components/my_drawer.dart';
import 'package:all_in_app/pages/apps/calendar.dart';
import 'package:all_in_app/pages/apps/games/games_main.dart';
import 'package:all_in_app/pages/apps/notes.dart';
import 'package:all_in_app/pages/apps/timer_page.dart';
import 'package:all_in_app/pages/apps/to_do.dart';
import 'package:all_in_app/pages/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Widget> _apps = [
    TimerPage(),
    Calendar(),
    Notes(),
    ToDo(),
    GamesMain(),
  ]; // APLICATIILE
  final List<String> _appsName = [
    // NUMELE DE LA APLICATII
    'Timer',
    'Calendar',
    'Notes',
    'To-Do List',
    'Games'
  ];
  final List<IconData> _icons = [
    // ICONITELE PENTRU APLICATII
    Icons.timer,
    Icons.calendar_month,
    Icons.notes,
    Icons.list,
    Icons.games,
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obținem tema curentă
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Ajustăm culorile în funcție de temă
    Color appBarColor = isDarkMode ? Colors.black87 : Colors.lightBlueAccent;
    Color iconColor = isDarkMode ? Colors.white : Colors.white;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: iconColor),
        backgroundColor: appBarColor,
        title: Text(
          "Home Page",
          style: TextStyle(color: iconColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          // BUTON SETTINGS DREAPTA SUS
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return Settings();
                }),
              );
            },
            icon: Icon(
              Icons.settings,
              color: iconColor,
            ),
          ),
        ],
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: ListView.builder(
        itemCount: _apps.length,
        itemBuilder: (BuildContext context, int index) {
          return AppTile(
            name: _appsName[index], // TITLUL
            icon: _icons[index], // ICONITA
            onTap: () {
              // NAVIGATORUL CATRE PAGINA
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return _apps[index];
                }),
              );
            },
          );
        },
      ),
    );
  }
}
