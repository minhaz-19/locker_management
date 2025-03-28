import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/all_buildings.dart';
import 'package:locker_management/screens/editBuilding.dart';
import 'package:locker_management/screens/notification.dart';

class AddTab extends StatefulWidget {
  const AddTab({super.key});

  @override
  State<AddTab> createState() => _AddTabState();
}

class _AddTabState extends State<AddTab> {
  List<Buildings> buildings = [];
  bool _isLoading = false;

  @override
  void initState() {
    getAllBuildings();
    super.initState();
  }

  dynamic getAllBuildings() async {
    setState(() {
      _isLoading = true;
      buildings = [];
    });
    try {
      buildings = await ApiResponse().fetchBuildings();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  dynamic addBuilding(String name, String location, int totalLocker) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ApiResponse().addBuildings(name, location, totalLocker);
      await getAllBuildings();
      Fluttertoast.showToast(msg: "College Added Successfully");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddBuildingDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    TextEditingController lockersController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add College"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "College Name"),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Locker Room"),
              ),
              TextField(
                controller: lockersController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Total Lockers"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await addBuilding(
                  nameController.text,
                  locationController.text,
                  int.parse(lockersController.text),
                );
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteBuildingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete College"),
          content: SizedBox(
            width: double.maxFinite, // Ensures proper width
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    buildings.map((building) {
                      return ListTile(
                        title: Text(building.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await ApiResponse().deleteBuildings(building.id);
                            await getAllBuildings();
                            Fluttertoast.showToast(
                              msg: "College Deleted Successfully",
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showAddLockerDialog(int index) {
    TextEditingController lockerIdController = TextEditingController();
    TextEditingController buildingIdController = TextEditingController();
    TextEditingController locationController = TextEditingController();

    String selectedStatus = "AVAILABLE";
    String selectedType = "PERMANENT";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Locker"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Location Input
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: "Locker Room"),
                ),
                const SizedBox(height: 10),

                // Status Dropdown
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  items:
                      ["AVAILABLE", "RESERVED", "OVERDUE"]
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedStatus = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: "Status"),
                ),
                const SizedBox(height: 10),

                // Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items:
                      ["PERMANENT", "TEMPORARY"]
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedType = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: "Type"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await ApiResponse().addLocker(
                  buildings[index].id,
                  selectedStatus,
                  selectedType,
                  locationController.text,
                );
                await getAllBuildings();
                Fluttertoast.showToast(msg: "Locker Added Successfully");
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteLockerDialog(int index) {
    TextEditingController lockerIdController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Locker"),
          content: TextField(
            controller: lockerIdController,
            decoration: InputDecoration(labelText: "Locker ID"),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isLoading = true;
                });
                await ApiResponse().deleteLocker(
                  int.parse(lockerIdController.text),
                );
                await getAllBuildings();
                setState(() {
                  _isLoading = false;
                });
                Fluttertoast.showToast(msg: "Locker Deleted Successfully");
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading == true)
        ? const ProgressBar()
        : Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              "Manage College",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Add College"),
                        trailing: IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: _showAddBuildingDialog,
                        ),
                      ),
                      ListTile(
                        title: const Text("Delete College"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: _showDeleteBuildingDialog,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: buildings.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(buildings[index].name),
                              subtitle: Text(
                                "Locker Room: ${buildings[index].location}",
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditBuilding(
                                                buildingId: buildings[index].id,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.green),
                                    onPressed:
                                        () => _showAddLockerDialog(index),
                                  ),

                                  // IconButton(
                                  //   icon: Icon(Icons.delete, color: Colors.red),
                                  //   onPressed:
                                  //       () => _showDeleteLockerDialog(index),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          if (buildings.length == index + 1)
                            const SizedBox(height: 70),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
