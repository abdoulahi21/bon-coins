import 'package:bon_coins/layout/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isLocationEnabled = true;
  bool _isNotificationEnabled = true;
  String _selectedLanguage = 'Français';

  // Method to toggle location service
  void _toggleLocation(bool value) {
    setState(() {
      _isLocationEnabled = value;
    });
  }

  // Method to toggle theme


  // Method to toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationEnabled = value;
    });
  }

  // Method to select language
  void _selectLanguage(String? language) {
    setState(() {
      _selectedLanguage = language!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          // Section: Profil
          ListTile(
            leading: Icon(Icons.person, color: Colors.blue),
            title: Text('Modifier le profil'),
            onTap: () {
              // Navigate to profile edit page
            },
          ),
          Divider(),

          // Section: Location Service
          SwitchListTile(
            secondary: Icon(Icons.location_on, color: Colors.blue),
            title: Text('Activer la localisation'),
            value: _isLocationEnabled,
            onChanged: _toggleLocation,
          ),
          Divider(),

          // Section: Notifications
          SwitchListTile(
            secondary: Icon(Icons.notifications, color: Colors.blue),
            title: Text('Activer les notifications'),
            value: _isNotificationEnabled,
            onChanged: _toggleNotifications,
          ),
          Divider(),

          // Section: Language
          ListTile(
            leading: Icon(Icons.language, color: Colors.blue),
            title: Text('Langue'),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: _selectLanguage,
              items:const [
                DropdownMenuItem(
                  value: 'Français',
                  child: Text('Français'),
                ),
                DropdownMenuItem(
                  value: 'English',
                  child: Text('English'),
                ),
              ],
            ),
          ),
          Divider(),

          // Section: Theme
           ListTile(
            leading: Icon(Icons.brightness_6, color: Colors.blue),
            title: Text('Mode sombre'),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          Divider(),

          // Section: About the App
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text('À propos de l\'application'),
            onTap: () {
              // Show app information
            },
          ),
        ],
      ),
    );
  }
}
