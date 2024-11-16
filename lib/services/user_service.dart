
import 'dart:convert';
import 'dart:io';

import 'package:bon_coins/constant.dart';
import 'package:bon_coins/model/api_response.dart';
import 'package:bon_coins/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//login
Future<ApiResponse> login(String email, String password) async{
  ApiResponse apiresponse = ApiResponse();
  try{
    final response= await http.post(Uri.parse(loginUrl),
        headers: {
         'Accept': 'application/json'
        },
      body: {
        'email':email,
        'password':password
      }
    );
    switch(response.statusCode){
      case 200:
        apiresponse.data=User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors=jsonDecode(response.body)['errors'];
        apiresponse.error=errors[errors.keys.elementAt()][0];
        break;
      case 403:
        apiresponse.error =jsonDecode(response.body)['message'];
        break;
    }
  }catch(e){
    e.toString();
  }
  return apiresponse;
}

//register
Future<ApiResponse> register(String full_name,String address,String phone,String email, String password) async{
  ApiResponse apiresponse = ApiResponse();
  try{
    final response= await http.post(Uri.parse(registerUrl),
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'full_name':full_name,
          'address':address,
          'phone':phone,
          'email':email,
          'password':password,
          'password_confirmation':password
        }
    );
    switch(response.statusCode){
      case 200:
        apiresponse.data=User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors=jsonDecode(response.body)['errors'];
        apiresponse.error=errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiresponse.error =jsonDecode(response.body)['message'];
        break;
    }
  }catch(e){
    e.toString();
  }
  return apiresponse;
}
Future<ApiResponse> getUserDetails() async{
  ApiResponse apiresponse = ApiResponse();
  try{
    String token= await getToken();
    final response= await http.get(Uri.parse(userUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization':'Bearer $token'
        },
    );
    switch(response.statusCode){
      case 200:
        apiresponse.data=User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors=jsonDecode(response.body)['errors'];
        apiresponse.error=errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiresponse.error =jsonDecode(response.body)['message'];
        break;
    }
  }catch(e){
    e.toString();
  }
  return apiresponse;
}
// Fonction pour faire une requête à une route protégée après connexion
Future<String> getToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token')?? '';
}
// Fonction pour obtenir l'ID de l'utilisateur connecté
Future<int> getUserId() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('id');
  return id!;
}
//logout
Future<bool> logout() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.remove('token');
}

String? getStringImage(File? file){
  if(file==null)return null;
  return base64Encode(file.readAsBytesSync());
}