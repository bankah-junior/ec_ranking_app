class UserModel {
  final String name;
  final String email;
  final String password;
  final String address;
  final String phone;

  UserModel({
    this.name = '',
    this.email = '',
    this.password = '',
    this.address = '',
    this.phone = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'phone': phone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
