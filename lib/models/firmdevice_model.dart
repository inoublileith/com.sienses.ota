class FirmDeviceModel {
  final String id;
  final int firmID;
  final int deviceID;
  final DateTime createdAt;

  FirmDeviceModel(
      {required this.id,
      required this.firmID,
      required this.deviceID,
      required this.createdAt});

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Id_device': deviceID,
      'Id_firm': firmID,
      'created_at': createdAt
    };
  }

  // Factory method to deserialize data from GraphQL
  factory FirmDeviceModel.fromJson(Map<String, dynamic> data) {
    return FirmDeviceModel(
        id: data['id'],
        deviceID: data['Id_device'],
        firmID: data['Id_firm'],
        createdAt: data['created_at']);
  }
}
