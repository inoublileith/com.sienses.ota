import 'dart:math';


import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ota/models/device_model.dart';
import 'package:ota/models/firm_model.dart';
import 'package:ota/models/intermdiare_model.dart';
import 'package:ota/models/users_model.dart';
import 'package:ota/utilis/utilis.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DbService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  UtilisateurModel? userModel;
  DeviceModel? deviceModel;
  FirmModel? firmModel;
  IntermModel? interModel;
  List<UtilisateurModel> allUsers = [];
  List<DeviceModel> allDevices = [];
  List<FirmModel> allFirms = [];
  List<UtilisateurModel> usersDevice = [];
  String? employeeDepartment;
  String? UserChips;
  late GraphQLClient client;

  int? role;

  DbService() {
    // Initialize the GraphQLClient here
    final HttpLink httpLink = HttpLink(
      'https://acrzmrxzbbsiwhmovljb.supabase.co/graphql/v1',
      defaultHeaders: <String, String>{
        'apikey':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFjcnptcnh6YmJzaXdobW92bGpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg3NDY0MDksImV4cCI6MjAxNDMyMjQwOX0.Z6sPCxVEEFv8lX8L_hVKs9ui9rzjt4A5BeAt0DBwPLw',
      },
    );

    client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }
  String generateRandomEmployeeId() {
    final random = Random();
    const allChars = "faangFAANG0123456789";
    final randomString =
        List.generate(8, (index) => allChars[random.nextInt(allChars.length)])
            .join();
    return randomString;
  }

  // Future insertNewUser(String email, var id) async {
  //   await _supabase.from(Constants.employeeTable).insert({
  //     'id': id,
  //     'name': '',
  //     'email': email,
  //     'employee_id': generateRandomEmployeeId(),
  //     'departement': null,
  //     'numero':0,
  //     'Admin':false
  //   });
  // }
  Future insertNewUser(String email, String name, var id) async {
    MutationOptions options = MutationOptions(document: gql('''
mutation insetNewUser (\$UserEmail : String ,\$UserName: String \$UserId : UUID , \$User :String, \$Value :BigInt){
  insertIntoUsersCollection(
    objects:[
      {
      Id_user:\$UserId,
      name:\$UserName,
      email:\$UserEmail,
      user:\$User,
      role : \$value
      }
    ]
  )
  {
    affectedCount
  }
}
'''), fetchPolicy: FetchPolicy.networkOnly, variables: <String, dynamic>{
      'UserId': id,
      'UserName': name,
      'UserEmail': email,
      'User': generateRandomEmployeeId(),
      'value': 3
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('user insert success');
    }
  }

  Future<void> fetchEmployees( ) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
      {
        usersCollection(
          first: 100) {
          edges {
            node {
              id
              name
              email
              Id_user
              created_at
              role
              user
            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['usersCollection']['edges'] ?? [];
      List<UtilisateurModel> utilisateurList = [];

      for (var edge in data) {
        final id = edge['node']['id'];
        final name = edge['node']['name'];
        final email = edge['node']['email'];
        final userId = edge['node']['Id_user'];
        final createdAt = edge['node']['created_at'];
        final role = edge['node']['role'];
        final user =edge['node']['user'];

        if (userId != _supabase.auth.currentUser!.id) {
          UtilisateurModel utilisateur = UtilisateurModel(
            id: id,
            name: name,
            email: email,
            userID: userId,
            createdAt: createdAt,
            role: role,
            user:user
          );
          utilisateurList.add(utilisateur);

          print(
              'Employee ID: $id, Name: $name, Email: $email, user : $userId, createdAt : $createdAt');
        }
      }

      allUsers = utilisateurList;

      final length = allUsers.length;
      print("allEmployees: $allUsers, Length: $length");
    }
    notifyListeners();
  }


  Future<void> fetchDevices() async {
    final QueryOptions options = QueryOptions(
      document: gql('''
      {
        devicesCollection(
          first:100) {
          edges {
            node {
              id
              Mac
              Tag
              created_at

            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['devicesCollection']['edges'] ?? [];
      List<DeviceModel> DeviceList = [];
      for (var edge in data) {
        final id = edge['node']['id'];
        final mac = edge['node']['Mac'] ?? ''; // Add a null check
        final tag = edge['node']['Tag'] ?? ''; // Add a null check
        final createdAt = edge['node']['created_at'];

        DeviceModel device = DeviceModel(
          id: id,
          mac: mac,
          tag: tag,
          createdAt: createdAt,
          idUser: '',
        );
        DeviceList.add(device);

        print('Employee ID: $id, Mac: $mac, Tag: $tag, createdAt: $createdAt');
      }

      allDevices = DeviceList;

      final length = allDevices.length;
      print("alldevices: $allDevices, Length: $length");
    }
    notifyListeners();
  }

  Future<void> fetchFirmes() async {
    final QueryOptions options = QueryOptions(
      document: gql('''
      {
        firmwareCollection(
          first:100) {
          edges {
            node {
              id
              version
              Tag
              created_at

            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['firmwareCollection']['edges'] ?? [];
      List<FirmModel> FirmsList = [];
      for (var edge in data) {
        final id = edge['node']['id'];
        final version = edge['node']['version'];
        final tag = edge['node']['Tag'];
        final createdAt = DateTime.parse(edge['node']['created_at']);
        const userID = '';

        FirmModel firm = FirmModel(
            id: id,
            version: version,
            tag: tag,
            userID: userID,
            createdAt: createdAt);
        FirmsList.add(firm);

        print(
            'FirmWare ID: $id, Version: $version, Tag: $tag, user : $userID, createdAt : $createdAt');
      }

      allFirms = FirmsList;

      final length = allFirms.length;
      print("allfirmvs: $allFirms, Length: $length");
    }
    notifyListeners();
  }

  Future<void> fetchFirmesByUser(String id) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
      query SelcetUser(
    \$Iduser:  String!
 


  )  {
        firmwareCollection(
          filter: {Id_user : {eq:\$Iduser}}) {
          edges {
            node {
              id
              version
              Tag
              created_at

            }
          }
        }
      }
    '''),
      variables: {'Iduser': id},
      fetchPolicy: FetchPolicy.networkOnly,
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['firmwareCollection']['edges'] ?? [];
      List<FirmModel> FirmsList = [];
      for (var edge in data) {
        final id = edge['node']['id'];
        final version = edge['node']['version'];
        final tag = edge['node']['Tag'];
        final createdAt = edge['node']['created_at'];
        const userID = '';

        FirmModel firm = FirmModel(
            id: id,
            version: version,
            tag: tag,
            userID: userID,
            createdAt: createdAt);
        FirmsList.add(firm);

        print(
            'FirmWare ID: $id, Version: $version, Tag: $tag, user : $userID, createdAt : $createdAt');
      }

      allFirms = FirmsList;

      final length = allFirms.length;
      print("allfirmvs: $allFirms, Length: $length");
    }
    notifyListeners();
  }

  Future<void> updateUser(
      String id, String name, String email, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateProfile(
    \$userId:  BigIntFilter!
    \$newUsername: String!
    \$newEmail: String!
    \$newRole : String!


  ) {
    updateUsersCollection(
      filter: { id: { eq: \$userId } }
      set: { name: \$newUsername, email: \$newEmail,role: \$newRole}
    ) {
      affectedCount
      records {
        id
        name
        email

      }
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': id,
      'newUsername': name,
      'newEmail': email,
      'newRole': role.toString(),
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('user $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  Future<void> updateProfil(
      String name, String email, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateProfile(
    \$userId:  UUID!
    \$newUsername: String!
    \$newEmail: String!


  ) {
    updateUsersCollection(
      filter: { Id_user: { eq: \$userId } }
      set: { name: \$newUsername, email: \$newEmail}
    ) {
      affectedCount
      records {
        id
        name
        email


      }
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': _supabase.auth.currentUser!.id,
      'newUsername': name,
      'newEmail': email,
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      String id = _supabase.auth.currentUser!.id;
      print('user $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  //
  // delete employee using graphql
  Future<void> deleteUser(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql('''
 mutation DeleteEmployee(\$employeeID: UUIDFilter!) {
    deleteFromUsersCollection(atMost: 1, filter: { id: { eq: \$employeeID } }) {
      affectedCount
    }
  }
'''), fetchPolicy: FetchPolicy.networkOnly, variables: {'employeeID': id});
    final QueryResult result = await client.mutate(options);
    notifyListeners();
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print("employee : $id deleted");
    }
  }

  Future<void> updateFirm(
      String id, String version, String tag, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateFirm(
    \$userId:  BigIntFilter!
    \$newVersion: String!
    \$newTag: String!
    \$NewUser: String!
  ) {
    updateFirmwareCollection(
      filter: { id: { eq: \$userId } }
      set: { version: \$newVersion, Tag: \$newTag,Id_user: \$newUser}
    ) {
      affectedCount
      records {
        id
        version
        Tag
        Id_user
      }
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': id,
      'newVersion': version,
      'newTag': tag,
      'newUser': UserChips
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('FirmWare $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  // delete employee using graphql
  Future<void> deleteFirm(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(
      document: gql('''
      mutation DeleteFirm(\$employeeID: UUIDFilter!) {
        deleteFromFirmwareCollection(atMost: 1, filter: { id: { eq: \$employeeID } }) {
          affectedCount
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'employeeID': id},
    );

    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print("firm : $id deleted");

      // Show the snackbar
      showSnackBar(context);
    }
  }

  void showSnackBar(BuildContext? context) {
    if (context != null) {
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(SnackBar(
        content: Text("Successfully deleted !"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ));
    }
  }

  Future<void> updateDevice(
      String id,  String tag, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateDevice(
    \$userId:  BigIntFilter!
    \$newMac: String!
    \$newTag: String!
    \$newUser: String!


  ) {
    updateDevicesCollection(
      filter: { id: { eq: \$userId } }
      set: {  Tag: \$newTag,Id_user:\$newUser}
    ) {
      affectedCount
      records {
        id
        Mac
        Tag
        Id_user

      }
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': id,
   
      'newTag': tag,
      'newUser': employeeDepartment
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('Device $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  // delete employee using graphql
  Future<void> deleteDevice(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql('''
 mutation DeleteDevice(\$employeeID: UUIDFilter!) {
    deleteFromDevicesCollection(atMost: 1, filter: { id: { eq: \$employeeID } }) {
      affectedCount
    }
  }
'''), variables: {'employeeID': id});
    final QueryResult result = await client.mutate(options);
    notifyListeners();
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print("firm : $id deleted");

      Utils.showSnackBar("Successfully deleted !", context,
          color: Colors.green);
    }
  }

  Future<void> getAllusers() async {
    final List result = await _supabase.from("Users").select();
    usersDevice = result
        .map((department) => UtilisateurModel.fromJson(department))
        .toList();
    notifyListeners();
  }

  Future<String> isAdmin() async {
    if (_supabase.auth.currentUser == null) {
      // Handle the case where the user is not authenticated
      return "1"; // Or any appropriate value for non-admin
    }

    final QueryOptions options = QueryOptions(document: gql('''
    query selectRole(\$userId: UUID) {
      usersCollection(
        first: 1
        filter: { Id_user: { eq: \$userId } }
      ) {
        edges {
          node {
            id
            role
          }
        }
      }
    }
  '''), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': _supabase.auth.currentUser!.id,
    });

    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      // Return 0 in case of an exception
      return "1"; // Or any appropriate value for non-admin
    } else {
      final data = result.data?['usersCollection']['edges'] ?? [];

      if (data.isEmpty) {
        // Return 0 if no user data is found (non-admin)
        return "1"; // Or any appropriate value for non-admin
      }

      final edge = data[0];
      final admin = edge['node']['role'];
      print(admin);

      // Assuming 'admin' means admin and any other value means non-admin
      return admin;
    }
  }

  Future<String> checkAdminStatus() async {
    final admin = await isAdmin();
    print('user is $admin');
    if (admin == "1") {
      return "1";
    } else if (admin == "2") {
      return "2";
    } else if (admin == "3") {
      return "3";
    } else {
      return "1";
    }
  }

  Future<List<IntermModel>> fetchFirmsByDevice({required String mac}) async {
    final List<IntermModel> intermModels =
        []; // Initialize an empty list to hold the models.

    final QueryOptions options = QueryOptions(
      document: gql('''
      query fetchfirms(\$mac: String) {
        devicesCollection(filter: { Mac: { eq: \$mac } }) {
          edges {
            node {
              intermidaryCollection {
                edges {
                  node {
                    firmware {
                      version
                      created_at
                    }
                  }
                }
              }
            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'mac': mac,
      },
    );

    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['devicesCollection']['edges'];
      if (data is List && data.isNotEmpty) {
        final intermidaryCollection =
            data[0]['node']['intermidaryCollection']['edges'];
        if (intermidaryCollection is List && intermidaryCollection.isNotEmpty) {
          for (var edge in intermidaryCollection) {
            final firmwareData = edge['node']['firmware'];
            final version = firmwareData['version'];

            final createdat = DateTime.parse(firmwareData['created_at']);
            final interModel = IntermModel(
              id: 3, // Set 'id' to a default value if it's not present in the response.
              version: version,
              createdAt: createdat,
            );

            intermModels.add(interModel); // Add the model to the list.
          }

          print("Data retrieved successfully");
          print('function 2 : $intermModels');
        } else {
          print("No firmware data found for the given device.");
        }
      } else {
        print("No device data found for the given MAC address.$mac");
      }
    }

    return intermModels; // Return the list of IntermModel objects.
  }

  Future<void> fetchDevicesByTag(String tag) async {
    final QueryOptions options = QueryOptions(
      document: gql('''
     query filterDevices ( \$Tag : String)  {
        devicesCollection(
          filter: {Tag:{eq:\$Tag}}) {
          edges {
            node {
              id
              Mac
              Tag
              created_at

            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {'Tag': tag},
    );
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['devicesCollection']['edges'] ?? [];
      List<DeviceModel> DeviceList = [];
      for (var edge in data) {
        final id = edge['node']['id'];
        final mac = edge['node']['Mac'];
        final tag = edge['node']['Tag'];
        final createdAt = edge['node']['created_at'];

        DeviceModel device = DeviceModel(
            id: id, mac: mac, tag: tag, createdAt: createdAt, idUser: '');
        DeviceList.add(device);

        print('Employee ID: $id, Mac: $mac, Tag: $tag, createdAt : $createdAt');
      }

      allDevices = DeviceList;

      final length = allDevices.length;
      print("alldevices: $allDevices, Length: $length");
    }
    notifyListeners();
  }

  Future<UtilisateurModel> getUserData() async {
    final QueryOptions options = QueryOptions(
      document: gql('''
      query SelectUser (\$UserId: UUID) {
        usersCollection(
          filter: {Id_user: {eq: \$UserId}}
        ) {
          edges {
            node {
              id
              name
              email
              created_at
              role
              user
           
            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: {
        'UserId': _supabase.auth.currentUser!.id,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      // Handle the exception here if needed
      return UtilisateurModel(
          createdAt: '', id: '', email: '', name: '', userID: '', role: '',user:'');
    } else {
      final data = result.data?['usersCollection']['edges'] ?? [];

      if (data.isEmpty) {
        return UtilisateurModel(
            createdAt: '', id: '', email: '', name: '', userID: '', role: '',user:'');
      }

      final edge = data[0];
      final id = edge['node']['id'];

      final name = edge['node']['name'];
      final email = edge['node']['email'];
      final createdAt = edge['node']['created_at'];
      final role = edge['node']['role'];
      final user = edge['node']['user'];
      UtilisateurModel userModel = UtilisateurModel(
          id: id,
          email: email,
          name: name,
          userID: _supabase.auth.currentUser!.id,
          createdAt: createdAt,
          role: role,
          user:user);
      print('$id, leith : $name,$email,');
      return userModel;
    }
  }

//   Future<void> updateIntermediare(String id, BuildContext context) async {
//     final MutationOptions options = MutationOptions(document: gql("""
//  mutation updateFirm(
//     \$newDevice:  String!

//   ) {
//     updateintermidaryCollection(
//       filter: { device: { eq: \$newDevice } }
//       set: { device: null}
//     ) {
//       affectedCount
//       records {
//         id
//         device
//         firms

//       }
//     }
//   }
// """), fetchPolicy: FetchPolicy.networkOnly, variables: {
//       'newDevice': id,
//     });
//     final QueryResult result = await client.mutate(options);
//     if (result.hasException) {
//       print(result.exception.toString());
//     } else {
//       print('FirmWare modified');
//       Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
//     }

//   }
  Future<void> deleteIntermediar(
      String id, int type, BuildContext context) async {
    if (type == 1) {
      await _supabase.from('intermidary').delete().eq('device', id).execute();
    } else {
      await _supabase.from('intermidary').delete().eq('firms', id).execute();
    }
  }

  Future<void> updateIntermediarefirms(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateFirm(
    \$newFirms:  String!


  ) {
    updateintermidaryCollection(
      filter: { firms: { eq: \$newFirms } }
      set: { firms: null}
    ) {
      affectedCount
  
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'newFirms': id,
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('FirmWare modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  Future<void> updateFirmByUser(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateFirm(
    \$userId:  BigIntFilter!

  ) {
    updateFirmwareCollection(
      filter: { Id_user: { eq: \$userId } }
      set: { Id_user: null}
    ) {
      affectedCount
    
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': id,
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('FirmWare $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  Future<void> updateDeviceByUser(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateDevice(
    \$userId:  BigIntFilter!



  ) {
    updateDevicesCollection(
      filter: { Id_user: { eq: \$userId } }
      set: { Id_user : null}
    ) {
      affectedCount
  
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': id,
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('Device $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  Future<void> updateFirmsWithIdUser(String id, BuildContext context) async {
    const tableName = 'Firmware';
    int intNumber = int.parse(id);
    // Perform the update
// ignore: deprecated_member_use
    await _supabase
        .from(tableName)
        .update({'Id_user': null})
        .eq('Id_user', intNumber)
        .execute();
  }

  Future<void> updateDeviceWithIdUser(String id, BuildContext context) async {
    const tableName = 'Devices';
    int intNumber = int.parse(id);
    // Perform the update
// ignore: deprecated_member_use
    await _supabase
        .from(tableName)
        .update({'Id_user': null})
        .eq('Id_user', intNumber)
        .execute();
  }

  Future<void> createFirmsDevices(
      List<String> deviceIds, String firmId, BuildContext context) async {
    final table = 'intermidary';

    final List<Map<String, dynamic>> records = deviceIds
        .map((deviceId) => {'device': deviceId, 'firms': firmId})
        .toList();

    await _supabase.from(table).upsert(records).execute();
    Utils.showSnackBar("Successfully Add !", context, color: Colors.green);
  }

  Future<void> delteuser(String id, BuildContext context) async {
    await _supabase.auth.admin.deleteUser(id);
    Utils.showSnackBar("Successfully Delete from auth !", context,
        color: Colors.green);
  }
}
