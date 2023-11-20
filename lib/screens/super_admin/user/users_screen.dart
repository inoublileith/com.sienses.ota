import 'package:OTA/screens/super_admin/user/Edit_User.dart';
import 'package:OTA/services/DbService.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Widget divider = SizedBox(height: 10);

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
                    final employeeList = dbService.allUsers;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: employeeList.length,
                      itemBuilder: (context, index) {
                        final employee = employeeList[index];
                        late String newadmin;
                        if (employee.role == "1") {
                          newadmin = "Super Admin";
                        } else if (employee.role == "2") {
                          newadmin = "Admin";
                        } else {
                          newadmin = "User";
                        }

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
                                employee.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        newadmin,
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
                                        DetailPage(employee: employee),
                                  ),
                                ).then((refresh) {
                                  if (refresh == true) {
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
