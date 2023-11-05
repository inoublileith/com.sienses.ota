class IntermModel {
  final int id;
  final String version;
  final String createdAt;

  IntermModel(
      {required this.id,
      required this.version,
      required this.createdAt});

  // GraphQL serialization
  Map<String, dynamic> toJson() {
    return {'id': id, 'Mac': version,'created_at': createdAt};
  }

factory IntermModel.fromJson(Map<String, dynamic> data) {
    final firmware = data['firmware']; // Access the 'firmware' map
    return IntermModel(
      id: data['id'],
      version: firmware['version'], // Access 'version' from the 'firmware' map
      createdAt:
          firmware['created_at'], // Access 'created_at' from the 'firmware' map
    );
  }

}
