import 'dart:convert';


import 'package:bon_coins/screens/lieu_create.dart';
import 'package:bon_coins/screens/login_page.dart';
import 'package:bon_coins/screens/place_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ListesPage extends StatefulWidget {
  @override
  _ListesPageState createState() => _ListesPageState();
}
class _ListesPageState extends State<ListesPage> {
  List<Map<String, dynamic>> _places = [];
  List<Map<String, dynamic>> _filteredPlaces = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;
 // String? _userRole;
  @override
  void initState() {
    super.initState();
    _fetchPlaces(); // Appeler l'API pour récupérer les lieux
    _checkLoginStatus(); // Vérifier si l'utilisateur est connecté
    _searchController.addListener(_filterPlaces);
  }
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
     // _userRole = prefs.getString('userRole');
    });
  }

  void _fetchPlaces() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/places'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      setState(() {
        // Assurez-vous d'utiliser la clé "places" pour extraire la liste
        _places = List<Map<String, dynamic>>.from(jsonData['places']);
        _filteredPlaces = _places;
      });
    } else {
      throw Exception('Failed to load places');
    }
  }




  void _filterPlaces() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isNotEmpty) {
        _filteredPlaces = _places.where((place) {
          final name = place['name'].toLowerCase();
          final description = place['description'].toLowerCase();
          final phone = place['phone'].toLowerCase();
          final address = place['address'].toLowerCase();
          final category = place['category'].toLowerCase();
          return name.contains(query) || category.contains(query) || description.contains(query) || phone.contains(query) || address.contains(query);
        }).toList();
      } else {
        _filteredPlaces = _places;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lieux par catégories')),
      body: Column(
        children: [
          if (_isLoggedIn)
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LieuCreate()));
              },
              child: Text('Ajouter un lieu', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou catégorie...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredPlaces.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: place['image'] != null && place['image'].isNotEmpty
                        ? Container(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        place['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                      child: Icon(Icons.image, color: Colors.white), // Icône par défaut si aucune image n'est fournie
                    ),
                    title: Text(
                      place['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('Catégorie: ${place['category']}'),
                        Text('Adresse: ${place['address']}'),
                        Text('Téléphone: ${place['phone']}'),
                        Text('Description: ${place['description']}'),
                        SizedBox(height: 5),
                        if (place['latitude'] != null && place['longitude'] != null)
                          Text('Localisation: ${place['latitude']}, ${place['longitude']}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


