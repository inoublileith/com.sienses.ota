class UtilisateurModel {
  final String id;
  final String name;
  final String email;
  final String userID;
  final String createdAt;

  UtilisateurModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.userID,
      required this.createdAt});

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'user': userID,
      'created_at': createdAt
    };
  }

  // Factory method to deserialize data from GraphQL
  factory UtilisateurModel.fromJson(Map<String, dynamic> data) {
    return UtilisateurModel(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        userID: data['user'],
        createdAt: data['created_at']);
  }
}
