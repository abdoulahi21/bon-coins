
import 'dart:convert';

import 'package:bon_coins/constant.dart';
import 'package:bon_coins/model/api_response.dart';
import 'package:bon_coins/model/place.dart';
import 'package:bon_coins/services/user_service.dart';
import 'package:http/http.dart' as http;

//create place
Future<ApiResponse> createPlace(String name,String description,String address,String category, String phone, double latitude,double longitude,String image) async{
  ApiResponse apiresponse = ApiResponse();
  try{
    String token =await getToken();
    final response= await http.post(Uri.parse(placesUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization':'Bearer $token',
        },
        body: image !=null ?{
          'name':name,
          'address':address,
          'phone':phone,
          'description':description,
          'latitude':latitude,
          'longitude':longitude,
          'category':category,
          'image':image
        }: {
          'name':name,
          'address':address,
          'phone':phone,
          'description':description,
          'latitude':latitude,
          'longitude':longitude,
          'category':category,
        }
    );
    switch(response.statusCode){
      case 200:
        apiresponse.data=Place.fromJson(jsonDecode(response.body));
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
    apiresponse.error= somethingWentWrong;
  }
  return apiresponse;
}

//get all places
Future<ApiResponse> getAllPlace() async{
  ApiResponse apiresponse = ApiResponse();
  try{
    final response= await http.get(Uri.parse(placesUrl),
        headers: {
          'Accept': 'application/json'
        },
    );
    switch(response.statusCode){
      case 200:
        apiresponse.data=jsonDecode(response.body)['pots'].map((p)=>Place.fromJson(p)).toList();
        apiresponse.data as List<dynamic>;
        break;
      case 403:
        apiresponse.error =jsonDecode(response.body)['message'];
        break;
    }
  }catch(e){
    apiresponse.error= somethingWentWrong;
  }
  return apiresponse;
}