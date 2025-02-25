import 'package:flutter/material.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/all_buildings.dart';

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

  void getAllBuildings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      buildings = await ApiResponse().fetchBuildings();
      print(buildings);
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
          title: const Text("Add Building"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Building Name"),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: "Location"),
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
              onPressed: () {
                setState(() {
                 
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

  void _showDeleteBuildingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Building"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                buildings.map((building) {
                  return ListTile(
                    title: Text(building.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          buildings.remove(building);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                }).toList(),
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
    TextEditingController lockersController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Lockers"),
          content: TextField(
            controller: lockersController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Number of Lockers"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                 
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                 
                });
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
              "Manage Buildings",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
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
                        title: const Text("Add Building"),
                        trailing: IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: _showAddBuildingDialog,
                        ),
                      ),
                      ListTile(
                        title: const Text("Delete Building"),
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
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(buildings[index].name),
                          subtitle: Text(
                            "Lockers: ${buildings[index].totalLocker}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.green),
                                onPressed: () => _showAddLockerDialog(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteLockerDialog(index),
                              ),
                            ],
                          ),
                        ),
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
