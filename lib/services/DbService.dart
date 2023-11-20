import 'dart:math';

<<<<<<< HEAD
import 'package:OTA/models/device_model.dart';
import 'package:OTA/models/firm_model.dart';
import 'package:OTA/models/intermdiare_model.dart';
import 'package:OTA/models/users_model.dart';
import 'package:OTA/utilis/utilis.dart';

=======
import 'package:com_sinses_ota/models/device_model.dart';
import 'package:com_sinses_ota/models/firm_model.dart';
import 'package:com_sinses_ota/models/intermdiare_model.dart';
import 'package:com_sinses_ota/models/user_model.dart';
import 'package:com_sinses_ota/models/users_model.dart';
import 'package:com_sinses_ota/utilis/utilis.dart';
>>>>>>> origin/main

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
<<<<<<< HEAD
    ValueNotifier<String?> userchips = ValueNotifier<String?>(null);
=======
  String? UserChips;
>>>>>>> origin/main
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

<<<<<<< HEAD
 Future<void> fetchEmployees() async {
    final currentUser = _supabase.auth.currentUser;
    final currentUserId = currentUser?.id;

=======
  Future<void> fetchEmployees() async {
>>>>>>> origin/main
    final QueryOptions options = QueryOptions(
      document: gql('''
      {
        usersCollection(
<<<<<<< HEAD
          first: 100) {
=======
          first:100) {
>>>>>>> origin/main
          edges {
            node {
              id
              name
              email
              user
              created_at
<<<<<<< HEAD
              role
              Id_user
=======

>>>>>>> origin/main
            }
          }
        }
      }
    '''),
      fetchPolicy: FetchPolicy.networkOnly,
    );
<<<<<<< HEAD

    final QueryResult result = await client.query(options);

=======
    final QueryResult result = await client.query(options);
>>>>>>> origin/main
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      final data = result.data?['usersCollection']['edges'] ?? [];
      List<UtilisateurModel> UtilisateurList = [];
<<<<<<< HEAD

      for (var edge in data) {
        final id = edge['node']['Id_user'];
        // Check if the current user's ID matches the fetched user's ID
        if (id == currentUserId) {
          continue; // Skip the current user's data
        }
        final iduser = edge['node']['id'];

=======
      for (var edge in data) {
        final id = edge['node']['id'];
>>>>>>> origin/main
        final name = edge['node']['name'];
        final email = edge['node']['email'];
        final userId = edge['node']['user'];
        final createdAt = edge['node']['created_at'];
<<<<<<< HEAD
        final role = edge['node']['role'];

        UtilisateurModel utilisateur = UtilisateurModel(
          id: iduser,
          name: name,
          email: email,
          userID: id,
          createdAt: createdAt,
          role: role,
        );
=======

        UtilisateurModel utilisateur = UtilisateurModel(
            id: id,
            name: name,
            email: email,
            userID: userId,
            createdAt: createdAt);
>>>>>>> origin/main
        UtilisateurList.add(utilisateur);

        print(
            'Employee ID: $id, Name: $name, Email: $email, user : $userId, createdAt : $createdAt');
      }

      allUsers = UtilisateurList;

      final length = allUsers.length;
      print("allEmployees: $allUsers, Length: $length");
    }
<<<<<<< HEAD

    notifyListeners();
  }


=======
    notifyListeners();
  }

>>>>>>> origin/main
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
<<<<<<< HEAD
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
=======
        final mac = edge['node']['Mac'];
        final tag = edge['node']['Tag'];
        final createdAt = edge['node']['created_at'];

        DeviceModel device = DeviceModel(
            id: id, mac: mac, tag: tag, createdAt: createdAt, idUser: '');
        DeviceList.add(device);
        '';

        print('Employee ID: $id, Mac: $mac, Tag: $tag, createdAt : $createdAt');
>>>>>>> origin/main
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
<<<<<<< HEAD
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
=======
        final createdAt = edge['node']['created_at'];
        const userID = 123;
>>>>>>> origin/main

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
<<<<<<< HEAD
      String id, String name,  BuildContext context) async {
    Map<String, dynamic> variables = {
      'userId': id,
      'newUsername': name,

    };

    if (role != null) {
      variables['newRole'] = role.toString();
    }

    final MutationOptions options = MutationOptions(
      document: gql("""
      mutation updateProfile(
        \$userId:  BigIntFilter!
        \$newUsername: String!
     
        \$newRole : String
      ) {
        updateUsersCollection(
          filter: { id: { eq: \$userId } }
          set: { name: \$newUsername,  role: \$newRole }
        ) {
          affectedCount
          records {
            id
            name
            email
          }
        }
      }
    """),
      fetchPolicy: FetchPolicy.networkOnly,
      variables: variables,
    );

    final QueryResult result = await client.mutate(options);

=======
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
>>>>>>> origin/main
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('user $id modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
    }
  }

  Future<void> updateProfil(
<<<<<<< HEAD
      String name,BuildContext context) async {
=======
      String name, String email, BuildContext context) async {
>>>>>>> origin/main
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateProfile(
    \$userId:  UUID!
    \$newUsername: String!
<<<<<<< HEAD

=======
    \$newEmail: String!
>>>>>>> origin/main


  ) {
    updateUsersCollection(
      filter: { Id_user: { eq: \$userId } }
<<<<<<< HEAD
      set: { name: \$newUsername,}
=======
      set: { name: \$newUsername, email: \$newEmail}
>>>>>>> origin/main
    ) {
      affectedCount
      records {
        id
        name
<<<<<<< HEAD
    
=======
        email
>>>>>>> origin/main


      }
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': _supabase.auth.currentUser!.id,
      'newUsername': name,
<<<<<<< HEAD
  
=======
      'newEmail': email,
>>>>>>> origin/main
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
<<<<<<< HEAD
  Future<void> deleteUser(String id,String uuid ,  BuildContext context) async {
=======
  Future<void> deleteUser(String id, BuildContext context) async {
>>>>>>> origin/main
    final MutationOptions options = MutationOptions(document: gql('''
 mutation DeleteEmployee(\$employeeID: UUIDFilter!) {
    deleteFromUsersCollection(atMost: 1, filter: { id: { eq: \$employeeID } }) {
      affectedCount
    }
  }
'''), fetchPolicy: FetchPolicy.networkOnly, variables: {'employeeID': id});
    final QueryResult result = await client.mutate(options);
<<<<<<< HEAD


=======
>>>>>>> origin/main
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
<<<<<<< HEAD
      'newUser': userchips
=======
      'newUser': UserChips
>>>>>>> origin/main
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
<<<<<<< HEAD
      String id,String tag, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateDevice(
    \$userId:  BigIntFilter!
=======
      String id, String mac, String tag, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateDevice(
    \$userId:  BigIntFilter!
    \$newMac: String!
>>>>>>> origin/main
    \$newTag: String!
    \$newUser: String!


  ) {
    updateDevicesCollection(
      filter: { id: { eq: \$userId } }
<<<<<<< HEAD
      set: { Tag: \$newTag,Id_user:\$newUser}
=======
      set: { Mac: \$newMac, Tag: \$newTag,Id_user:\$newUser}
>>>>>>> origin/main
    ) {
      affectedCount
      records {
        id
<<<<<<< HEAD
=======
        Mac
>>>>>>> origin/main
        Tag
        Id_user

      }
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'userId': id,
<<<<<<< HEAD
        'newTag': tag,
=======
      'newMac': mac,
      'newTag': tag,
>>>>>>> origin/main
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
<<<<<<< HEAD
    final List result = await _supabase.from("Users").select();
=======
    final List result = await _supabase.from("users").select();
>>>>>>> origin/main
    usersDevice = result
        .map((department) => UtilisateurModel.fromJson(department))
        .toList();
    notifyListeners();
  }

  Future<String> isAdmin() async {
    if (_supabase.auth.currentUser == null) {
      // Handle the case where the user is not authenticated
<<<<<<< HEAD
      return "3"; // Or any appropriate value for non-admin
=======
      return "1"; // Or any appropriate value for non-admin
>>>>>>> origin/main
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
<<<<<<< HEAD
      return "3"; // Or any appropriate value for non-admin
=======
      return "1"; // Or any appropriate value for non-admin
>>>>>>> origin/main
    } else {
      final data = result.data?['usersCollection']['edges'] ?? [];

      if (data.isEmpty) {
        // Return 0 if no user data is found (non-admin)
<<<<<<< HEAD
        return "3"; // Or any appropriate value for non-admin
=======
        return "1"; // Or any appropriate value for non-admin
>>>>>>> origin/main
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
<<<<<<< HEAD
      return "0";
=======
      return "1";
>>>>>>> origin/main
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
<<<<<<< HEAD

            final createdat = DateTime.parse(firmwareData['created_at']);
=======
            final createdat = firmwareData['created_at'];

>>>>>>> origin/main
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
<<<<<<< HEAD
              role
              user
=======
>>>>>>> origin/main
           
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
<<<<<<< HEAD
          createdAt: '', id: '', email: '', name: '', userID: '', role : '');
=======
          createdAt: '', id: '', email: '', name: '', userID: '');
>>>>>>> origin/main
    } else {
      final data = result.data?['usersCollection']['edges'] ?? [];

      if (data.isEmpty) {
        return UtilisateurModel(
<<<<<<< HEAD
            createdAt: '', id: '', email: '', name: '', userID: '',role : '');
=======
            createdAt: '', id: '', email: '', name: '', userID: '');
>>>>>>> origin/main
      }

      final edge = data[0];
      final id = edge['node']['id'];

      final name = edge['node']['name'];
      final email = edge['node']['email'];
      final createdAt = edge['node']['created_at'];
<<<<<<< HEAD
      final role = edge['node']['role'];
=======
>>>>>>> origin/main
      UtilisateurModel userModel = UtilisateurModel(
          id: id,
          email: email,
          name: name,
          userID: _supabase.auth.currentUser!.id,
<<<<<<< HEAD
          createdAt: createdAt,
          role : role );
=======
          createdAt: createdAt);
>>>>>>> origin/main
      print('$id, leith : $name,$email,');
      return userModel;
    }
  }

<<<<<<< HEAD
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
=======
  Future<void> updateIntermediare(String id, BuildContext context) async {
    final MutationOptions options = MutationOptions(document: gql("""
 mutation updateFirm(
    \$newDevice:  String!


  ) {
    updateintermidaryCollection(
      filter: { device: { eq: \$newDevice } }
      set: { device: null}
    ) {
      affectedCount
  
    }
  }
"""), fetchPolicy: FetchPolicy.networkOnly, variables: {
      'newDevice': id,
    });
    final QueryResult result = await client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
    } else {
      print('FirmWare modified');
      Utils.showSnackBar("Successfully modify !", context, color: Colors.green);
>>>>>>> origin/main
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
<<<<<<< HEAD

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
Future<bool> isDeviceInCloud(String deviceMac) async {

    final response = await _supabase
        .from("Devices")
        .select()
        .eq('Mac', deviceMac)
        .execute();

    if (response.data != null && response.data!.length > 0) {
      
      return true;
          } else {
    
      return false;
    }
  }

=======
>>>>>>> origin/main
}
