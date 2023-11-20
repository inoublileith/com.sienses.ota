import 'package:ota/models/users_model.dart';
import 'package:ota/screens/admin/firmware/Admin_add_firm.dart';
import 'package:ota/screens/admin/firmware/Edit_Admin_Fire.dart';
import 'package:ota/services/DbService.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

const double narrowScreenWidthThreshold = 100;

class AdminFirmScreen extends StatefulWidget {


  const AdminFirmScreen({ Key? key}) : super(key: key);

  @override
  _AdminFirmScreenState createState() => _AdminFirmScreenState();
}

class _AdminFirmScreenState extends State<AdminFirmScreen> {
  late UtilisateurModel userModel ; 
 Future<void> fetchData() async {
    final userModel =
        await Provider.of<DbService>(context, listen: false).getUserData();

    await Provider.of<DbService>(context, listen: false)
        .fetchFirmesByUser(userModel.id);

    setState(() {
      this.userModel = userModel; // Store the userModel in the state
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < narrowScreenWidthThreshold) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20, top: 60, bottom: 10),
                  child: const Text(
                    "Screen User Web ",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: const Text(
                  "FirmWare ",
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdminUploadScreen(userId: userModel.id),
                    ),
                  ).then((refresh) {
                    if (refresh == true) {
                      fetchData(); // Refresh data here
                    }
                  });
                },
                child: Text('ADD'),
              ),
              Expanded(
                child: Consumer<DbService>(
                  builder: (context, dbService, child) {
                    final employeeList = dbService.allFirms;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: employeeList.length,
                      itemBuilder: (context, index) {
                        final employee = employeeList[index];
                        return Card(
                          elevation: 8.2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(64, 75, 96, 0.9),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              leading: Container(
                                padding: const EdgeInsets.only(right: 12.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                        width: 1.0, color: Colors.white24),
                                  ),
                                ),
                                child: const Icon(Icons.computer,
                                    color: Colors.white),
                              ),
                              title: Text(
                                employee.version,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: const Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "FirmWare",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.keyboard_arrow_right,
                                  color: Colors.white, size: 30.0),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminEditFirm(employee: employee),
                                  ),
                                ).then((refresh) {
                                  if (refresh == true) {
                                    fetchData(); // Refresh data here
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
