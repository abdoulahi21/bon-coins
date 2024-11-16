import 'package:flutter/material.dart';
import 'package:bon_coins/screens/lieu_create.dart';
import 'package:bon_coins/model/api_response.dart';
import 'package:bon_coins/model/place.dart';
import 'package:bon_coins/services/post_service.dart';

class ListesPage extends StatefulWidget {
  const ListesPage({super.key});

  @override
  _ListesPageState createState() => _ListesPageState();
}

class _ListesPageState extends State<ListesPage> {
  List<dynamic> _allPlaces = []; // Liste complète des lieux
  List<dynamic> _filteredPlaces = []; // Liste filtrée pour la recherche
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  Future<void> _fetchPlaces() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponse response = await getAllPlace();

    if (response.error == null) {

      setState(() {
        _allPlaces = response.data as List<dynamic>? ?? [];// Assurez une liste vide
        _filteredPlaces = _allPlaces; // Met à jour la liste filtrée
      });
    } else {
      // Gérez l'erreur si besoin (par exemple, afficher une alerte)
      debugPrint('Erreur API: ${response.error}');
    }
    setState(() {
      _isLoading = false;
    });
  }


  void _filterPlaces(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredPlaces = _allPlaces; // Affiche tous les lieux
      } else {
        _filteredPlaces = _allPlaces.where((place) {
          final name = place.name?.toLowerCase();
          final category = place.category?.toLowerCase();
          return name!.contains(query) ||
              category!.contains(query);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
    _searchController.addListener(() {
      _filterPlaces(_searchController.text.toLowerCase());
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
      appBar: AppBar(title: Text('Lieux par catégories')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LieuCreate()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Ajouter un lieu', style: TextStyle(color: Colors.white)),
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
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredPlaces.isEmpty
                ? Center(
              child: Text(
                'Aucun lieu disponible.',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _filteredPlaces.length,
              itemBuilder: (BuildContext context, int index) {
                final place = _filteredPlaces[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: place.image != null && place.image!.isNotEmpty
                        ? SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.network(
                        place.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                        : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                      child: Icon(Icons.image, color: Colors.white),
                    ),
                    title: Text(
                      '${place.name ?? "Nom inconnu"}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('Catégorie: ${place.category ?? "Non spécifiée"}'),
                        Text('Adresse: ${place.address ?? "Non spécifiée"}'),
                        Text('Téléphone: ${place.phone ?? "Non disponible"}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Logique pour afficher les détails du lieu
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
