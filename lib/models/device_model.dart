class DeviceModel {
<<<<<<< HEAD
  bool isSelected;
=======
>>>>>>> origin/main
  final String id;
  final String idUser;
  final String mac;
  final String tag;
  final String createdAt;

<<<<<<< HEAD
  DeviceModel(
      {this.isSelected = false,
      required this.id,
      required this.idUser,
      required this.mac,
      required this.tag,
      required this.createdAt});
=======

  DeviceModel(
      {required this.id,
      required this.idUser,
      required this.mac,
      required this.tag,
      required this.createdAt
     
      });
>>>>>>> origin/main

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
<<<<<<< HEAD
      'Id_user': idUser,
      'Mac': mac,
      'Tag': tag,
      'created_at': createdAt
    };
  }

=======
      'Id_user':idUser,
      'Mac': mac,
      'Tag': tag,
      'created_at': createdAt
    
    };
  }
>>>>>>> origin/main
  // Factory method to deserialize data from GraphQL
  factory DeviceModel.fromJson(Map<String, dynamic> data) {
    return DeviceModel(
        id: data['id'],
        idUser: data['Id_user'],
        mac: data['Mac'],
        tag: data['Tag'],
<<<<<<< HEAD
        createdAt: data['created_at']);
=======
        createdAt: data['created_at']
       );
>>>>>>> origin/main
  }
}
