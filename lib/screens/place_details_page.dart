import 'package:flutter/material.dart';


class PlaceDetailsPage extends StatelessWidget {
  final Map<String, dynamic> place;

  const PlaceDetailsPage({required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              place['image'],
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            SizedBox(height: 20),
            Text(
              place['name'],
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Catégorie : ${place['category']}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Distance : ${place['distance']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Note : ${place['rating']} ★ (${place['reviews']} avis)',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Description :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Ce lieu est un des meilleurs de la catégorie ${place['category']}. Il est apprécié pour sa proximité (${place['distance']}) et ses excellentes évaluations (${place['rating']} étoiles, ${place['reviews']} avis).',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}