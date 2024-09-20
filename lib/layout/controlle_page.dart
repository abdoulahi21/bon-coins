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
  @override
  SetCurrentIndex(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Geolocalisation - Bons Coins'),
        ),
      body: [
        HomePage(),   // Contenu de la page d'accueil
        ProfilePage(),       // Page Profil
        MapPage(),           // Page Carte
        ListesPage(),        // Liste des lieux
        SettingPage(),
      ][_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Lieux',
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
            onTap: SetCurrentIndex,
            ),
        );
  }
}
