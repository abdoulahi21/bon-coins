import 'package:flutter/material.dart';
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Page'),
        ),
        body: const Center(
          child: Text('Map Page'),
        ),
      ),
    );
  }
}
