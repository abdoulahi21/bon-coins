import 'package:bon_coins/screens/home_page.dart';
import 'package:bon_coins/screens/listes_page.dart';
import 'package:bon_coins/screens/map_page.dart';
import 'package:bon_coins/screens/profile_page.dart';
import 'package:bon_coins/screens/setting_page.dart';
import 'package:flutter/material.dart';

class ControllePage extends StatefulWidget {
  @override
  _ControllePage createState() => _ControllePage();
}

class _ControllePage extends State<ControllePage> {
  int _selectedIndex = 0;

  SetCurrentIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomePage(), // Contenu de la page d'accueil
        ListesPage(), // Liste des lieux
        MapPage(), // Page Carte géographique
        ProfilePage(), // Page Profil
        SettingPage(), // Page Paramètres
      ][_selectedIndex],
      // Using padding to simulate centering effect
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0), // Adjust this padding as needed
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Lieux',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Paramètres',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: SetCurrentIndex,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
