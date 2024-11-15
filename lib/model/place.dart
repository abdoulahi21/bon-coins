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
     id:json['place']['id'],
     name:json['place']['name'],
     description:json['place']['description'],
     image:json['place']['image'],
     category:json['place']['category'],
     address:json['place']['address'],
     phone:json['place']['phone'],
     latitude:json['place']['latitude'],
     longitude:json['place']['longitude'],
     selfLiked: json['likes'].length>0,

  );
}
}