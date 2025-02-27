import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/all_buildings.dart';
import 'package:locker_management/models/getLockers.dart';

class AllLocker extends StatefulWidget {
  const AllLocker({super.key});

  @override
  State<AllLocker> createState() => _AllLockerState();
}

class _AllLockerState extends State<AllLocker> {
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
          title: const Text("Select Start Date and End Date"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Start Date",
                  hintText: "YYYY-MM-DD",
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "End Date",
                  hintText: "YYYY-MM-DD",
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Reserve"),
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
              "Locker Status",
              style: TextStyle(color: Colors.white),
            ),
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
                            child: ListTile(
                              title: Text("Locker ID: ${locker.id}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Status: ${locker.status}"),
                                  Text("Type: ${locker.type}"),
                                  Text("Location: ${locker.location}"),
                                ],
                              ),
                              trailing:
                                  locker.status != "Reserved"
                                      ? SizedBox(
                                        width:
                                            100, // Set a fixed width to prevent overflow
                                        child: Column(
                                          mainAxisSize:
                                              MainAxisSize
                                                  .min, // Take only required space
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .end, // Align buttons to the right
                                          children: [
                                            ElevatedButton(
                                              onPressed:
                                                  () => _updateLockerStatus(
                                                    locker.id,
                                                  ),
                                              child: const Text("Reserve"),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ), // Space between buttons
                                          ],
                                        ),
                                      )
                                      : null,
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
