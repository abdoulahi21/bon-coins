class User{
  int? id;
  String? full_name;
  String? email;
  String? phone;
  String? address;
  String? image;
  String? token;
  User({
    this.id,
    this.full_name,
    this.email,
    this.phone,
    this.address,
    this.image,
    this.token
});
  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['user']['id'],
      full_name: json['user']['full_name'],
      email: json['user']['email'],
      phone: json['user']['phone'],
      address: json['user']['address'],
      image: json['user']['image'],
      token: json['user']['token']

    );
  }
}