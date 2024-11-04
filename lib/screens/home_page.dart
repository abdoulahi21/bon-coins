import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _topRatedPlaces = [];

  @override
  void initState() {
    super.initState();
    _fetchTopRatedPlaces(); // Fetch top-rated places on initialization
  }

  Future<void> _fetchTopRatedPlaces() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/places'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _topRatedPlaces = List<Map<String, dynamic>>.from(jsonData['places']);
      });
    } else {
      throw Exception('Erreur lors du chargement des lieux');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrousel d'images
            Container(
              height: 200,
              child: PageView(
                children: [
                  Image.asset(
                    'images/maison_esclave.jpeg',
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'images/saly.jpeg',
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'images/parc.jpeg',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher des lieux...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Catégories de lieux
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catégories',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCategoryCard('Restaurants', Icons.restaurant),
                      _buildCategoryCard('Parcs', Icons.park),
                      _buildCategoryCard('Musées', Icons.museum),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Les lieux les mieux notés
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Les lieux les mieux notés',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _topRatedPlaces.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _topRatedPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _topRatedPlaces[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: place['image'] != null
                              ? Image.network(
                            place['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 80),
                          )
                              : Icon(Icons.place, size: 80),
                          title: Text(
                            place['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Note: ${place['likes_count']}'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer une carte de catégorie
  Widget _buildCategoryCard(String title, IconData icon) {
    return Card(
      elevation: 5,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 5),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
