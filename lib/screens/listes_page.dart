import 'package:bon_coins/screens/place_details_page.dart';
import 'package:flutter/material.dart';

class ListesPage extends StatefulWidget {
  @override
  _ListesPageState createState() => _ListesPageState();
}

class _ListesPageState extends State<ListesPage> {
  // Exemple de données de lieux
  final List<Map<String, dynamic>> _places = [
    {
      'name': 'Restaurant Le Gourmet',
      'category': 'Restaurants',
      'distance': '2.5 km',
      'rating': 4.5,
      'reviews': 120,
      'image': 'images/saly.jpeg'
    },
    {
      'name': 'Parc Naturel',
      'category': 'Parcs',
      'distance': '3.2 km',
      'rating': 4.7,
      'reviews': 75,
      'image': 'images/parc.jpeg'
    },
    {
      'name': 'Musée d\'Art Moderne',
      'category': 'Musées',
      'distance': '1.8 km',
      'rating': 4.8,
      'reviews': 98,
      'image': 'images/maison_esclave.jpeg'
    },
  ];

  // Liste des résultats de recherche filtrés
  List<Map<String, dynamic>> _filteredPlaces = [];

  // Contrôleur pour le champ de recherche
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPlaces = _places; // Initialement, afficher tous les lieux
    _searchController.addListener(_filterPlaces); // Ajout du listener
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPlaces);
    _searchController.dispose();
    super.dispose();
  }

  // Méthode pour filtrer les lieux en fonction de la recherche
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
        _filteredPlaces = _places; // Si la recherche est vide, afficher tous les lieux
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Lieux par catégories'),
      ),
      body: Column(
        children: [
          // Barre de recherche
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

          // Liste des lieux
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPlaces.length,
              itemBuilder: (context, index) {
                final place = _filteredPlaces[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5,
                  //color: Colors.white,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Image.asset(
                      place['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      place['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
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
                      // Logique pour afficher plus de détails ou naviguer vers une page spécifique
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
