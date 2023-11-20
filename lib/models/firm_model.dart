class FirmModel {
  final String id;
  final String version;
  final String tag;
  final String userID;
  final String createdAt;

  FirmModel(
      {required this.id,
      required this.version,
      required this.tag,
      required this.userID,
      required this.createdAt});

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'Tag': tag,
      'Id_user': userID,
      'created_at': createdAt
    };
  }

  // Factory method to deserialize data from GraphQL
  factory FirmModel.fromJson(Map<String, dynamic> data) {
    return FirmModel(
      id: data['id'],
      version: data['version'],
      tag: data['Tag'],
      userID: data['Id_user'],
      createdAt: data['created_at'],
    );
  }
}
