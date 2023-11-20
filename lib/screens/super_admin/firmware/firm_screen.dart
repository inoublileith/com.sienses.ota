import 'package:ota/screens/super_admin/firmware/Edit_Firm.dart';
import 'package:ota/screens/super_admin/firmware/addNewFile.dart';
import 'package:ota/services/DbService.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 100;

class FirmScreen extends StatefulWidget {
  const FirmScreen({Key? key}) : super(key: key);

  @override
  _FirmScreenState createState() => _FirmScreenState();
}

class _FirmScreenState extends State<FirmScreen> {
  @override
  void initState() {
    super.initState();
    // Call the function to fetch employee data from the database when the screen is initialized
    Provider.of<DbService>(context, listen: false).fetchFirmes();
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
                      builder: (context) => UploadScreen(),
                    ),
                  ).then((refresh) {
                    if (refresh == true) {
                      // Reload the list of firmware (you can do this by fetching data again or using some other method)
                      // You can call a function to fetch updated data here or use a state management approach to refresh the list.
                      // For example, if you are using Provider, you can notify your Provider to rebuild.
                      Provider.of<DbService>(context, listen: false)
                          .fetchFirmes();
                    }
                  });
                },
                child: Text('ADD'),
              ),
              Expanded(
                child: Consumer<DbService>(
                  builder: (context, dbService, child) {
                    // Check if the data has been fetched and loaded

                    // Data has been successfully fetched
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
                                child: const Icon(
                                    Icons.computer,
                                    color: Colors.white),
                              ),
                              title: Text(
                                employee
                                    .version, // Use employee name from your data
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
                                        EditFirm(employee: employee),
                                  ),
                                ).then((refresh) {
                                  if (refresh == true) {
                                    // Reload the list of firmware (you can do this by fetching data again or using some other method)
                                    // You can call a function to fetch updated data here or use a state management approach to refresh the list.
                                    // For example, if you are using Provider, you can notify your Provider to rebuild.
                                    Provider.of<DbService>(context,
                                            listen: false)
                                        .fetchFirmes();
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
