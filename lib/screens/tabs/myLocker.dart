import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/myLocker.dart';

final GlobalKey<_MyLockerState> myLockerKey = GlobalKey<_MyLockerState>();

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

  /// Fetch the locker list from API
  Future<void> _fetchLockers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      lockerRequests = await ApiResponse().myLocker();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error loading lockers: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Reset the UI completely (force full rebuild)
  void resetState() {
    setState(() {
      lockerRequests = [];
    });
    _fetchLockers();
  }

  /// Release locker and reset UI
  Future<void> releaseLocker(int lockerID) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ApiResponse().releaseLocker(lockerID);
      Fluttertoast.showToast(msg: "Locker released successfully");

      // **Reset the full UI using GlobalKey**
      myLockerKey.currentState?.resetState();
    } catch (e) {
      Fluttertoast.showToast(msg: "Error releasing locker: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Show confirmation dialog before releasing the locker
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
                Navigator.of(context).pop();
                await releaseLocker(lockerID);
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
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body:
              lockerRequests.isEmpty
                  ? const Center(child: Text('No Lockers Available'))
                  : ListView.builder(
                    itemCount: lockerRequests.length,
                    itemBuilder: (context, index) {
                      final locker = lockerRequests[index];

                      // Convert the date to a readable format
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
