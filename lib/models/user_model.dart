class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;

<<<<<<< HEAD
=======

>>>>>>> origin/main
  UserModel({
    required this.id,
    required this.email,
    required this.name,
<<<<<<< HEAD
    required this.role,
  });

=======
    required this.role, 

  });


>>>>>>> origin/main
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
<<<<<<< HEAD
    };
  }

=======

    };
  }


>>>>>>> origin/main
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'],
      email: data['email'],
      name: data['name'],
      role: data['role'],
<<<<<<< HEAD
=======

>>>>>>> origin/main
    );
  }
}
