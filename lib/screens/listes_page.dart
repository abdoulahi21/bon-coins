import 'package:flutter/material.dart';

class ListesPage extends StatefulWidget {
  const ListesPage({super.key});

  @override
  State<ListesPage> createState() => _ListesPageState();
}

class _ListesPageState extends State<ListesPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Listes'),
        ),
        body: const Center(
          child: Text('Listes Page'),
        ),
      ),
    );
  }
}
