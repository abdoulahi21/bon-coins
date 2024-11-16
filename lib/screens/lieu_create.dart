import 'dart:io';
import 'package:bon_coins/model/api_response.dart';
import 'package:bon_coins/model/place.dart';
import 'package:bon_coins/screens/listes_page.dart';
import 'package:bon_coins/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:bon_coins/services/user_service.dart';
class LieuCreate extends StatefulWidget {
  const LieuCreate({super.key});

  @override
  _LieuCreateState createState() => _LieuCreateState();
}

class _LieuCreateState extends State<LieuCreate> {
  final GlobalKey<FormState> formkey= GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _image;
  final picker = ImagePicker();

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to submit the form
 void _createPlace()async{
    String? image=_image==null ? null : getStringImage(_image);
    ApiResponse response=await createPlace(_nameController.text, _descriptionController.text, _addressController.text, _categoryController.text, _phoneController.text,_latitudeController.text as double, _longitudeController.text as double,image!);
    if(response.error==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>ListesPage()),(route)=>false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Lieu'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nom du lieu'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom du lieu.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la latitude.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la longitude.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Catégorie'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une catégorie.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Téléphone'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Adresse'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(_image!, height: 150)
                    : Text('Aucune image sélectionnée'),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Sélectionner une image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){
                    if(formkey.currentState!.validate()){
                      _createPlace();
                    }
                  },
                  child: Text('Ajouter le lieu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
