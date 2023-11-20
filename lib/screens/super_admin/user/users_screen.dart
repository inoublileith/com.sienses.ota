<<<<<<< HEAD
import 'package:OTA/screens/super_admin/user/Edit_User.dart';
import 'package:OTA/services/DbService.dart';
=======
import 'package:com_sinses_ota/screens/super_admin/user/Edit_User.dart';
import 'package:com_sinses_ota/screens/super_admin/user/showDilaog.dart';
import 'package:com_sinses_ota/services/DbService.dart';
>>>>>>> origin/main

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD
const Widget divider = SizedBox(height: 10);

=======

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
>>>>>>> origin/main
const double narrowScreenWidthThreshold = 100;

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
=======
    // Call the function to fetch employee data from the database when the screen is initialized
>>>>>>> origin/main
    Provider.of<DbService>(context, listen: false).fetchEmployees();
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
                  "Users ",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Expanded(
                child: Consumer<DbService>(
                  builder: (context, dbService, child) {
<<<<<<< HEAD
=======
                    // Check if the data has been fetched and loaded

                    // Data has been successfully fetched
>>>>>>> origin/main
                    final employeeList = dbService.allUsers;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: employeeList.length,
                      itemBuilder: (context, index) {
                        final employee = employeeList[index];
<<<<<<< HEAD
                        late String newadmin;
                        if (employee.role == "1") {
                          newadmin = "Super Admin";
                        } else if (employee.role == "2") {
                          newadmin = "Admin";
                        } else {
                          newadmin = "User";
                        }

=======
>>>>>>> origin/main
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
                                child: const Icon(
                                    Icons.supervised_user_circle_rounded,
                                    color: Colors.white),
                              ),
                              title: Text(
<<<<<<< HEAD
                                employee.name,
=======
                                employee
                                    .name, // Use employee name from your data
>>>>>>> origin/main
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
<<<<<<< HEAD
                              subtitle: Row(
=======
                              subtitle: const Row(
>>>>>>> origin/main
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
<<<<<<< HEAD
                                        newadmin,
=======
                                        "employee",
>>>>>>> origin/main
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.keyboard_arrow_right,
                                  color: Colors.white, size: 30.0),
                              onTap: () {
<<<<<<< HEAD
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(employee: employee),
                                  ),
                                ).then((refresh) {
                                  if (refresh == true) {
=======
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(employee: employee,),
                                  ),
                                ).then((refresh) {
                                  if (refresh == true) {
                                    // Reload the list of firmware (you can do this by fetching data again or using some other method)
                                    // You can call a function to fetch updated data here or use a state management approach to refresh the list.
                                    // For example, if you are using Provider, you can notify your Provider to rebuild.
>>>>>>> origin/main
                                    Provider.of<DbService>(context,
                                            listen: false)
                                        .fetchEmployees();
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
