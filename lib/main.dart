import 'package:bon_coins/layout/controlle_page.dart';
import 'package:bon_coins/layout/theme_provider.dart';
import 'package:bon_coins/screens/home_page.dart';
import 'package:bon_coins/screens/login_page.dart';
import 'package:bon_coins/screens/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main()  {
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geolocalisation App',
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),  // Thème clair
      darkTheme: ThemeData.dark(),  // Thème sombre
      home: LoginPage(),
    );
  }
}
