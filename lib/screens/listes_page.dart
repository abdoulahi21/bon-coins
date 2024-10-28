import 'dart:convert';

import 'package:bon_coins/screens/lieu_create.dart';
import 'package:bon_coins/screens/place_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ListesPage extends StatefulWidget {
  @override
  _ListesPageState createState() => _ListesPageState();
}
class _ListesPageState extends State<ListesPage> {
  List<Map<String, dynamic>> _places = [];
  List<Map<String, dynamic>> _filteredPlaces = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPlaces(); // Appeler l'API pour récupérer les lieux
    _searchController.addListener(_filterPlaces);
  }

  Future<void> _fetchPlaces() async {
    final response = await http.get(Uri.parse('http://your-laravel-api-url/api/places'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _places = data.map((place) => place as Map<String, dynamic>).toList();
        _filteredPlaces = _places; // Initialiser les lieux filtrés
      });
    } else {
      // Gérer l'erreur
      throw Exception('Échec de chargement des lieux');
    }
  }

  void _filterPlaces() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isNotEmpty) {
        _filteredPlaces = _places.where((place) {
          final name = place['name'].toLowerCase();
          final category = place['category'].toLowerCase();
          return name.contains(query) || category.contains(query);
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
                    leading: place['image'] != null
                        ? Image.network(
                      place['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : Container(width: 80, height: 80, color: Colors.grey),
                    title: Text(place['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('${place['distance']} • ${place['rating']} ★ (${place['reviews']} avis)'),
                        SizedBox(height: 5),
                        Text(place['category'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailsPage(place: place),
                        ),
                      );
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


