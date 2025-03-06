import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/myLocker.dart';
import 'package:locker_management/screens/notification.dart';

class MyLocker extends StatefulWidget {
  const MyLocker({super.key});

  @override
  State<MyLocker> createState() => _MyLockerState();
}

class _MyLockerState extends State<MyLocker> {
  bool _isLoading = false;
  List<LockerRequest> lockerRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchLockers();
  }

  dynamic _fetchLockers() async {
    setState(() {
      _isLoading = true;
      lockerRequests = [];
    });
    try {
      lockerRequests = await ApiResponse().myLocker();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  dynamic releaseLocker(int lockerID) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await ApiResponse().releaseLocker(lockerID);
      await _fetchLockers();
      Fluttertoast.showToast(msg: "Locker released successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to release locker");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showReleaseDialog(int lockerID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Release Locker"),
          content: Text("Are you sure you want to release locker #$lockerID?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await releaseLocker(lockerID);
                Navigator.of(context).pop();
              },
              child: const Text("Release"),
            ),
          ],
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
              "My Lockers",
              style: TextStyle(color: Colors.white),
            ),
            // add a notification icon in the app bar
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
            

            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body:
              lockerRequests.isEmpty
                  ? const Center(child: Text('No Lockers Available'))
                  : ListView.builder(
                    itemCount:
                        lockerRequests.length + 1, // Add 1 for the SizedBox
                    itemBuilder: (context, index) {
                      if (index == lockerRequests.length) {
                        return const SizedBox(
                          height: 80,
                        ); // Adds spacing after the last item
                      }
                      final locker = lockerRequests[index];
                      final startDate =
                          DateTime.fromMillisecondsSinceEpoch(
                            locker.startDate,
                          ).toLocal().toIso8601String().split('T').first;
                      final endDate =
                          DateTime.fromMillisecondsSinceEpoch(
                            locker.endDate,
                          ).toLocal().toIso8601String().split('T').first;
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Locker ID: ${locker.lockerID}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status: ${locker.status}'),
                              Text('Start Date: $startDate'),
                              Text('End Date: $endDate'),
                            ],
                          ),
                          trailing:
                              locker.status != "APPROVED"
                                  ? null
                                  : ElevatedButton(
                                    onPressed:
                                        () =>
                                            _showReleaseDialog(locker.lockerID),
                                    child: const Text("Release"),
                                  ),
                        ),
                      );
                    },
                  ),
        );
  }
}
