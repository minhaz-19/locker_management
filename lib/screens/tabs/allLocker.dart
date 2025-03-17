import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/all_buildings.dart';
import 'package:locker_management/models/getLockers.dart';
import 'package:locker_management/provider/userDetailsProvider.dart';

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
    DateTime? _startDateTime;
    DateTime? _endDateTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Select Start DateTime and End DateTime"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: TextEditingController(
                      text:
                          _startDateTime != null
                              ? "${_startDateTime!.year}-${_startDateTime!.month.toString().padLeft(2, '0')}-${_startDateTime!.day.toString().padLeft(2, '0')} "
                                  "${_startDateTime!.hour.toString().padLeft(2, '0')}:${_startDateTime!.minute.toString().padLeft(2, '0')}"
                              : "",
                    ),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Start Date & Time",
                      hintText: "YYYY-MM-DD HH:MM",
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _startDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(
                      text:
                          _endDateTime != null
                              ? "${_endDateTime!.year}-${_endDateTime!.month.toString().padLeft(2, '0')}-${_endDateTime!.day.toString().padLeft(2, '0')} "
                                  "${_endDateTime!.hour.toString().padLeft(2, '0')}:${_endDateTime!.minute.toString().padLeft(2, '0')}"
                              : "",
                    ),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "End Date & Time",
                      hintText: "YYYY-MM-DD HH:MM",
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _endDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
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
                    if (_startDateTime != null && _endDateTime != null) {
                      int startMilliseconds =
                          _startDateTime!.millisecondsSinceEpoch;
                      int endMilliseconds =
                          _endDateTime!.millisecondsSinceEpoch;
                      // Call your reservation logic here
                      // SHOW DIALOG IF THE DURATION IS GREATER THAN 12 HOURS
                      if (endMilliseconds - startMilliseconds > 43200000 &&
                          UserDetailsProvider().getRole() == "VISITOR") {
                        Fluttertoast.showToast(
                          msg:
                              "Reservation duration cannot be more than 12 hours.",
                        );
                      } else {
                        await reserveLocker(
                          startMilliseconds,
                          endMilliseconds,
                          lockerId,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Please select both start and end date & time.",
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
                                  locker.status != "RESERVED" &&
                                          ((UserDetailsProvider().getRole() ==
                                                      "STUDENT" &&
                                                  locker.type == 'PERMANENT') ||
                                              (UserDetailsProvider()
                                                          .getRole() ==
                                                      "VISITOR" &&
                                                  locker.type == 'TEMPORARY'))
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
