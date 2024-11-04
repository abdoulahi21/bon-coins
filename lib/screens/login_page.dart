import 'dart:convert';

import 'package:bon_coins/layout/controlle_page.dart';
import 'package:bon_coins/screens/home_page.dart';
import 'package:bon_coins/screens/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  static Map<String, dynamic>? _loggedInUser;
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  // Fonction pour se connecter
  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      // Préparer les données pour la requête POST
      var data = {
        'email': email,
        'password': password,
      };

      // Envoyer une requête POST à l'API de connexion Laravel
      var response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/login'), // URL de votre API Laravel
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Vérifier la réponse du serveur
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        // Vérifier si la connexion est réussie
        if (jsonResponse['token'] != null) {
          // Stockez les informations de l'utilisateur dans SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Connexion réussie!')),
          );
          // Naviguer vers la page principale après connexion
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ControllePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Échec de la connexion : ${jsonResponse['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de serveur : ${response.statusCode}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  // Fonction pour faire une requête à une route protégée après connexion
  Future<void> _fetchProtectedData(String token) async {
    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/protected-route'), // URL de la route protégée
      headers: {
        'Authorization': 'Bearer $token', // Inclure le token dans les headers
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Données protégées récupérées : $data');
    } else {
      print('Erreur lors de la récupération des données protégées : ${response.statusCode}');
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),

                // Logo or image
                Image.asset(
                  'images/Bons.png',
                  // Replace with your logo or use Image.network() for an online image
                  height: 200,
                ),

                SizedBox(height: 40),

                // Welcome text
                Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Connectez-vous à votre compte',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30),

                // Email TextField
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Password TextField
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Mot de passe',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                // Forgot password text button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Add "forgot password" functionality
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: _login,

                  child: Text('Connexion',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24
                    ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50), // Full width button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Sign Up option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pas encore de compte ?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up page
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) => SignUpPage()));
                      },
                      child: Text(
                        'Créer un compte',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }