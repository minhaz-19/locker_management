import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/screens/home.dart';

class EditBuilding extends StatefulWidget {
  EditBuilding({super.key, required this.buildingId});
  int buildingId;

  @override
  State<EditBuilding> createState() => _EditBuildingState();
}

class _EditBuildingState extends State<EditBuilding> {
  bool isLoading = false;

  // controller for text fields
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController totalLockersController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading == true)
        ? const ProgressBar()
        : Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit College',
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body:
          // create 4 text fields with label and hint text
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: buildingNameController,
                    decoration: InputDecoration(
                      labelText: 'College Name',
                      hintText: 'Enter College Name',

                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16.0),
                  TextField(
                    controller: collegeController,
                    decoration: InputDecoration(
                      labelText: 'Locker Room',
                      hintText: 'Enter Locker Room',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: totalLockersController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Total Lockers',
                      hintText: 'Enter Total Lockers',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Handle save action
                      try {
                        await ApiResponse().editBuildings(
                          buildingNameController.text,
                          collegeController.text,
                          int.parse(totalLockersController.text),
                          widget.buildingId,
                        );
                        Fluttertoast.showToast(
                          msg: "College Updated Successfully",
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const Home()),
                          (Route<dynamic> route) => false,
                        );
                      } catch (e) {
                        // Fluttertoast.showToast(msg: e.toString());
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
