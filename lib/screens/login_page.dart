import 'dart:convert';

import 'package:bon_coins/layout/controlle_page.dart';
import 'package:bon_coins/model/api_response.dart';
import 'package:bon_coins/model/user.dart';
import 'package:bon_coins/screens/home_page.dart';
import 'package:bon_coins/screens/sign_up_page.dart';
import 'package:bon_coins/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  static Map<String, dynamic>? _loggedInUser;

  const LoginPage({super.key});
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey= GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  // Fonction pour se connecter
void loginUser() async{
  ApiResponse response= await login(_emailController.text,_passwordController.text);
  if(response.error==null){
    _saveAndRedirectToHome(response.data as User);
  }else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
  }

}
void _saveAndRedirectToHome(User user) async{
  SharedPreferences pref=await SharedPreferences.getInstance();
  await pref.setString('token', user.token ?? '');
  await pref.setInt('userId', user.id ?? 0);
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>ControllePage()),(route)=>false);
}
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey, // Associez la clé au formulaire
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 60),

                // Logo ou image
                Image.asset(
                  'images/Bons.png',
                  height: 200,
                ),

                SizedBox(height: 40),

                // Texte d'accueil
                const Text(
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

                // Champ Email
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Champ Mot de passe
                TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),

                // Bouton Mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Ajouter la fonctionnalité "Mot de passe oublié"
                    },
                    child: const Text(
                      'Mot de passe oublié ?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Bouton Connexion
                ElevatedButton(
                  onPressed:(){
                    if(formkey.currentState!.validate()) {
                      loginUser();
                    }
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50), // Bouton pleine largeur
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Connexion',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),

                SizedBox(height: 20),

                // Option Créer un compte
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Pas encore de compte ?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
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
      ),
    );
  }
  }