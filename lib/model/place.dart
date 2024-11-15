class Place {
  int? id;
  String? name;
  String? description;
  String? image;
  String? address;
  String? category;
  String? phone;
  double? latitude;
  double? longitude;
  

Place({
this.id,
this.name,
this.description,
this.image,
this.address,
this.category,
this.phone,
this.latitude,
this.longitude,
});

factory Place.fromJson(Map<String, dynamic> json){

  return Place(
     id:json['id'],
     name:json['name'],
     description:json['description'],
     image:json['image'],
     category:json['category'],
     address:json['address'],
     phone:json['phone'],
     latitude:json['latitude'],
     longitude:json['longitude'],
  );
}
}