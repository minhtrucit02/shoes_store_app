class UserDB {
  UserDB({
    required this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    required this.address,
    required this.createAt,
  });
  final String id;
  final String name;
  final String password;
  final String email;
  final String phone;
  final String address;
  final String createAt;

  factory UserDB.fromJson(Map<String, dynamic> data) {
    return UserDB(
      id: data['id'],
      name: data['name'],
      password: data['password'],
      email: data['email'],
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      createAt: data['createAt'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
    'id':id,
    'name':name,
    'password':password,
    'email':email,
    'phone':phone,
    'address':address,
    'createAt':createAt,
  };
}
