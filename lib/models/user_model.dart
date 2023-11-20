class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;


  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role, 

  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,

    };
  }


  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      role: data['role'],

    );
  }
}
