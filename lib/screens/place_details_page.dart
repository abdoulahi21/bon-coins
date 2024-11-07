import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class PlaceDetailsPage extends StatefulWidget {
  String placeId;

  PlaceDetailsPage({required this.placeId});

  @override
  _PlaceDetailsPageState createState() => _PlaceDetailsPageState();
}

class _PlaceDetailsPageState extends State<PlaceDetailsPage> {
  Map<String, dynamic>? place;

  @override
  void initState() {
    super.initState();
    loadPlaceDetails();
  }
  Future<Map<String, dynamic>?> fetchPlaceDetails(int id) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/places/$id'); // Adjust base URL if necessary

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body); // Parse and return JSON data
      } else {
        print('Failed to load place details');
        return null;
      }
    } catch (e) {
      print('Error fetching place details: $e');
      return null;
    }
  }

  Future<void> loadPlaceDetails() async {
    final data = await fetchPlaceDetails(widget.placeId as int);
    setState(() {
      place = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place?['name'] ?? 'Détails du Lieu'),
      ),
      body: place == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image if available
            place?['image'] != null && place!['image'].isNotEmpty
                ? Image.network(
              place!['image'], // URL or path to the image
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 80),
            )
                : Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey[300],
              child: Icon(Icons.image, size: 100, color: Colors.white),
            ),
            SizedBox(height: 20),

            // Place Name
            Text(
              place?['name'] ?? 'Nom non disponible',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 10),

            // Category
            Text(
              'Catégorie: ${place?['category'] ?? 'Non spécifiée'}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),

            // Description
            Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              place?['description'] ?? 'Aucune description disponible',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Address
            Text(
              'Adresse',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              place?['address'] ?? 'Adresse non disponible',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Phone
            Text(
              'Téléphone',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              place?['phone'] ?? 'Téléphone non disponible',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Location
            Text(
              'Localisation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 5),
            Text(
              'Latitude: ${place?['latitude'] ?? 'N/A'}, Longitude: ${place?['longitude'] ?? 'N/A'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Action button (example, can be customized or removed as needed)
            ElevatedButton(
              onPressed: () {
                // Action to perform on button press, if needed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Voir sur la carte',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
