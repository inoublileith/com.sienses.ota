class FirmModel {
  final String id;
  final String version;
  final String tag;
<<<<<<< HEAD
  final String userID;
  final String createdAt;

  FirmModel(
      {required this.id,
      required this.version,
      required this.tag,
      required this.userID,
      required this.createdAt});
=======
  final int userID;
  final String createdAt;

  FirmModel({
    required this.id,
    required this.version,
    required this.tag,
    required this.userID,
    required this.createdAt
  });
>>>>>>> origin/main

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'Tag': tag,
      'Id_user': userID,
<<<<<<< HEAD
      'created_at': createdAt
=======
      'created_at':createdAt
>>>>>>> origin/main
    };
  }

  // Factory method to deserialize data from GraphQL
  factory FirmModel.fromJson(Map<String, dynamic> data) {
    return FirmModel(
      id: data['id'],
      version: data['version'],
      tag: data['Tag'],
      userID: data['Id_user'],
<<<<<<< HEAD
      createdAt: data['created_at'],
=======
      createdAt: data['created_at']
>>>>>>> origin/main
    );
  }
}
