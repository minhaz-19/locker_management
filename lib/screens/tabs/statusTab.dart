import 'package:flutter/material.dart';
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
              ElevatedButton(onPressed: () {}, child: const Text("Available")),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
                  Navigator.pop(context);
                },
                child: const Text("Reserved"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {});
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
                      var locker =
                          lockers
                              .where(
                                (locker) =>
                                    locker.buildingId == selectedBuildingId,
                              )
                              .toList()[index];

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
                              trailing: ElevatedButton(
                                onPressed: () => _updateLockerStatus(locker.id),
                                child: const Text("Update"),
                              ),
                            ),
                          ),
                          // Show SizedBox only if it's the last item
                          index ==
                                  lockers
                                          .where(
                                            (locker) =>
                                                locker.buildingId ==
                                                selectedBuildingId,
                                          )
                                          .toList()
                                          .length -
                                      1
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
