class DeviceModel {
  final String id;
  final String idUser;
  final String mac;
  final String tag;
  final String createdAt;


  DeviceModel(
      {required this.id,
      required this.idUser,
      required this.mac,
      required this.tag,
      required this.createdAt
     
      });

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Id_user':idUser,
      'Mac': mac,
      'Tag': tag,
      'created_at': createdAt
    
    };
  }
  // Factory method to deserialize data from GraphQL
  factory DeviceModel.fromJson(Map<String, dynamic> data) {
    return DeviceModel(
        id: data['id'],
        idUser: data['Id_user'],
        mac: data['Mac'],
        tag: data['Tag'],
        createdAt: data['created_at']
       );
  }
}
