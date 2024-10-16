import 'package:bon_coins/layout/controlle_page.dart';
import 'package:bon_coins/layout/theme_provider.dart';
import 'package:bon_coins/screens/home_page.dart';
import 'package:bon_coins/screens/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main()  {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Geolocalisation App',
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),  // Thème clair
      darkTheme: ThemeData.dark(),  // Thème sombre
      home: ControllePage(),
    );
  }
}
