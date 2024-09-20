import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
                    'images/maison_esclave.jpeg', // Remplace par l'image de ton choix
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'images/saly.jpeg', // Remplace par l'image de ton choix
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    'images/parc.jpeg', // Remplace par l'image de ton choix
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
