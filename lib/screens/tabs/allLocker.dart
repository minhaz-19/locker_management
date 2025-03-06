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
  List<GetAllLockers> lockers = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    allBuildings();
    getLockers();
  }

  dynamic allBuildings() async {
    setState(() => _isLoading = true);
    try {
      buildings = await ApiResponse().fetchBuildings();
      buildings.sort((a, b) => a.id.compareTo(b.id));
    } catch (e) {
      // Handle error
    }
    setState(() => _isLoading = false);
  }

  dynamic reserveLocker(int startDate, int endDate, int lockerId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await ApiResponse().reserveLocker(startDate, endDate, lockerId);
      await getLockers();
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Locker reservation request sent successfully.",
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  dynamic getLockers() async {
    setState(() {
      lockers = [];
    });
    setState(() => _isLoading = true);
    try {
      lockers = await ApiResponse().fetchLockers();
      lockers.sort((a, b) => a.id.compareTo(b.id));
    } catch (e) {
      // Handle error
    }
    setState(() => _isLoading = false);
  }

  void _updateLockerStatus(int lockerId) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Start Date and End Date"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(
                      text:
                          _startDate != null
                              ? "${_startDate!.year}-${_startDate!.month}-${_startDate!.day}"
                              : "",
                    ),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Start Date",
                      hintText: "YYYY-MM-DD",
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _startDate = pickedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(
                      text:
                          _endDate != null
                              ? "${_endDate!.year}-${_endDate!.month}-${_endDate!.day}"
                              : "",
                    ),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "End Date",
                      hintText: "YYYY-MM-DD",
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _endDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    if (_startDate != null && _endDate != null) {
                      int startMilliseconds =
                          _startDate!.millisecondsSinceEpoch;
                      int endMilliseconds = _endDate!.millisecondsSinceEpoch;
                      print("Start Date in ms: $startMilliseconds");
                      print("End Date in ms: $endMilliseconds");
                      // Add your logic to reserve the locker here
                      await reserveLocker(
                        startMilliseconds,
                        endMilliseconds,
                        lockerId,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select both start and end dates.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text("Reserve"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
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
                    setState(() => selectedBuildingId = newValue);
                  },
                  items:
                      buildings.map((building) {
                        return DropdownMenuItem<int>(
                          value: building.id,
                          child: Text(building.name),
                        );
                      }).toList(),
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
                                  locker.status != "RESERVED"
                                      ? ElevatedButton(
                                        onPressed:
                                            () =>
                                                _updateLockerStatus(locker.id),
                                        child: const Text("Reserve"),
                                      )
                                      : null,
                            ),
                          ),
                          if (filteredLockers.length == index + 1)
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
