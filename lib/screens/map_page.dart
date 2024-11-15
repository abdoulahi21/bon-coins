import 'dart:async';
import 'package:bon_coins/constant.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? currentLocation; // Pour stocker la position actuelle de l'utilisateur
  static const LatLng destLocation = LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinates = [];
  List<Marker> nearbyPlaces = []; // Liste des lieux proches à afficher sur la carte

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getNearbyPlaces();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Déplacer la caméra vers la position actuelle
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(currentLocation!, 14.0));
  }

  void getNearbyPlaces() {
    // Simuler des lieux proches avec des coordonnées fictives
    // Vous pouvez remplacer cette section par des données provenant d'une API de lieux proches
    List<LatLng> places = [
      LatLng(37.33500926, -122.03272188),
      LatLng(37.33200926, -122.04272188),
      LatLng(37.33000926, -122.05272188),
    ];

    setState(() {
      nearbyPlaces = places.map((place) {
        return Marker(
          markerId: MarkerId(place.toString()),
          position: place,
          infoWindow: InfoWindow(title: "Lieu proche"),
        );
      }).toList();
    });
  }

//   Future<void> getPolyPoints() async {
//     if (currentLocation == null) return;

//     // PolylinePoints polylinePoints = PolylinePoints();
//     // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     //   PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
//     //   PointLatLng(destLocation.latitude, destLocation.longitude),
//     // );

//     if (result.points.isNotEmpty) {
//       setState(() {
//         polylineCoordinates.clear();
//         for (var point in result.points) {
//           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//         }
//       });
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localisation en direct"),
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation!,
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCoordinates,
            width: 5,
            color: Colors.blue,
          ),
        },
        markers: {
          Marker(
            markerId: MarkerId("source"),
            position: currentLocation!,
            infoWindow: InfoWindow(title: "Votre position actuelle"),
          ),
          Marker(
            markerId: MarkerId("destination"),
            position: destLocation,
            infoWindow: InfoWindow(title: "Destination"),
          ),
          ...nearbyPlaces, // Ajouter les lieux proches en tant que marqueurs
        },
      ),
    );
  }
}
