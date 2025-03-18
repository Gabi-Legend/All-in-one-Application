import 'package:all_in_app/pages/home_page.dart';
import 'package:all_in_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Importă pachetul AdMob

void main() {
  // Inițializare Google Mobile Ads
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize(); // Inițializarea SDK-ului

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: themeProvider.isDarkMode
              ? ThemeData.dark() // Tema Dark
              : ThemeData.light(), // Tema Light
          home: HomePage(), // Pagina principală
        );
      },
    );
  }
}
