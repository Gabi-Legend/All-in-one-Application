import 'package:all_in_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:all_in_app/components/my_drawer.dart';
import 'package:all_in_app/const/const.dart'; // Constante precum `version` și `support`.
import 'package:all_in_app/pages/home_page.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Provider.of<ThemeProvider>(context).isDarkMode
            ? Colors.black
            : Colors.lightBlueAccent, // Culoare în funcție de temă
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return HomePage();
              }));
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('About'),
                  trailing: const Icon(Icons.info),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('MultiTask'),
                          content: Text(
                            'MultiTask is a multifunctional application that provides you with useful tools '
                            'such as task management, theme customization, and more.\n\n$version\n\n'
                            'Our goal is to simplify your life through a compact and efficient app.\n\n'
                            'For feedback or support, contact us at: $support',
                          ),
                        );
                      },
                    );
                  },
                ),
                // Setare temă (Light / Dark)
                ListTile(
                  title: const Text('Change Theme'),
                  trailing: Switch(
                    value: Provider.of<ThemeProvider>(context).isDarkMode,
                    onChanged: (value) {
                      // Schimbăm tema apelând toggleTheme
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              version,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
