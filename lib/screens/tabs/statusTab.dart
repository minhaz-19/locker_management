import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/all_buildings.dart';
import 'package:locker_management/models/getLockers.dart';

class StatusTab extends StatefulWidget {
  const StatusTab({super.key});

  @override
  State<StatusTab> createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  bool _isLoading = false;
  int? selectedBuildingId;
  List<Buildings> buildings = [];

  @override
  void initState() {
    super.initState();
    allBuildings();
    getLockers();
  }

  dynamic allBuildings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      buildings = await ApiResponse().fetchBuildings();
      // sort buildings by id
      buildings.sort((a, b) => a.id.compareTo(b.id));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  dynamic getLockers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      lockers = await ApiResponse().fetchLockers();
      // sort lockers by id
      lockers.sort((a, b) => a.id.compareTo(b.id));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // declare lockers
  dynamic deleteLocker(int lockerId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await ApiResponse().deleteLocker(lockerId);
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Locker deleted successfully!");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // declare lockers
  List<GetAllLockers> lockers = [];

  void _updateLockerStatus(int lockerId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Locker Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await ApiResponse().updateLockerStatus(lockerId, "Available");
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Available"),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await ApiResponse().updateLockerStatus(lockerId, "Reserved");
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Reserved"),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await ApiResponse().updateLockerStatus(lockerId, "Overdue");
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pop(context);
                },
                child: const Text("Overdue"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
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
            title: const Text("Lockers", style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButton<int>(
                  isExpanded: true,
                  value: selectedBuildingId,
                  hint: const Text("Select Building"),
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedBuildingId = newValue;
                    });
                  },
                  items:
                      buildings
                          .map(
                            (building) => DropdownMenuItem<int>(
                              value: building.id,
                              child: Text(building.name),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        lockers
                            .where(
                              (locker) =>
                                  locker.buildingId == selectedBuildingId,
                            )
                            .toList()
                            .length,
                    itemBuilder: (context, index) {
                      var filteredLockers =
                          lockers
                              .where(
                                (locker) =>
                                    locker.buildingId == selectedBuildingId,
                              )
                              .toList();
                      var locker = filteredLockers[index];

                      return Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Locker Details (First Part)
                                  Text(
                                    "Locker ID: ${locker.id}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Status: ${locker.status}"),
                                  Text("Type: ${locker.type}"),
                                  Text("Location: ${locker.location}"),
                                  const SizedBox(
                                    height: 12,
                                  ), // Space before buttons
                                  // Buttons Section (Second Part)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center, // Center the buttons
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed:
                                              () => _updateLockerStatus(
                                                locker.id,
                                              ),
                                          child: const Text("Update"),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ), // Space between buttons
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await deleteLocker(locker.id);
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text("Delete"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Show SizedBox only if it's the last item
                          index == filteredLockers.length - 1
                              ? const SizedBox(height: 70)
                              : Container(),
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
