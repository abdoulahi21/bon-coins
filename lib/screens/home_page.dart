import 'dart:convert';
import 'package:bon_coins/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bon_coins/screens/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _topRatedPlaces = [];
  List<Map<String, dynamic>> _filteredPlaces = []; // Liste filtrée
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Vérifier si l'utilisateur est connecté
    _fetchTopRatedPlaces(); // Récupérer les lieux les mieux notés
    _searchController.addListener(() {
      _filterPlaces(_searchController.text.toLowerCase());
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> _fetchTopRatedPlaces() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/places'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        _topRatedPlaces = List<Map<String, dynamic>>.from(jsonData['places']);
        _filteredPlaces = _topRatedPlaces; // Initialiser la liste filtrée
      });
    } else {
      throw Exception('Erreur lors du chargement des lieux');
    }
  }

  void _filterPlaces(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = _topRatedPlaces; // Réinitialiser la liste filtrée
      } else {
        _filteredPlaces = _topRatedPlaces.where((place) {
          final name = place['name']?.toLowerCase() ?? '';
          final category = place['category']?.toLowerCase() ?? '';
          return name.contains(query) || category.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.person),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Text('Déconnexion'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Carrousel d'images
            SizedBox(
              height: 200,
              child: PageView(
                children: [
                  Image.asset('images/maison_esclave.jpeg', fit: BoxFit.cover),
                  Image.asset('images/saly.jpeg', fit: BoxFit.cover),
                  Image.asset('images/parc.jpeg', fit: BoxFit.cover),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Barre de recherche
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
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
                  _filteredPlaces.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: place['image'] != null
                              ? Image.network(
                            place['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image, size: 80),
                          )
                              : Icon(Icons.place, size: 80),
                          title: Text(
                            place['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Catégorie: ${place['category']}'),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: () {
                                      if (_isLoggedIn) {
                                        _likePlace(place['id']);
                                      } else {
                                        _showSnackBar(
                                            "Vous devez être connecté pour aimer.");
                                      }
                                    },
                                    icon: Icon(Icons.favorite,
                                        color: Colors.blue),
                                    label: Text('${place['likes_count']}'),
                                  ),
                                  SizedBox(width: 10),
                                  TextButton.icon(
                                    onPressed: () {
                                      _openComments(place['id']);
                                    },
                                    icon: Icon(Icons.comment,
                                        color: Colors.grey),
                                    label:
                                    Text('${place['opinions_count']}'),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _likePlace(int placeId) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/places/$placeId/likes');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _showSnackBar('Lieu aimé avec succès!');

        setState(() {
          final place =
          _topRatedPlaces.firstWhere((p) => p['id'] == placeId);
          place['likes_count'] = (place['likes_count'] ?? 0) + 1;
        });
      } else {
        final errorMessage =
            json.decode(response.body)['error'] ?? 'Erreur inconnue';
        _showSnackBar('Erreur : $errorMessage');
      }
    } catch (error) {
      _showSnackBar('Erreur réseau. Vérifiez votre connexion.');
    }
  }

  void _openComments(int placeId) {
    print('Ouvrir les commentaires pour le lieu $placeId');
  }
}
