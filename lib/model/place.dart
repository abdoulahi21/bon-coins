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
  int? likes_count;
  int? opinions_count;
  bool? selfLiked;

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
  this.likes_count,
  this.opinions_count,
  this.selfLiked,
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
     selfLiked: json['likes'].length>0,

  );
}
}