import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/lockerStatus.dart';

class LockerStatus extends StatefulWidget {
  const LockerStatus({super.key});

  @override
  State<LockerStatus> createState() => _LockerStatusState();
}

class _LockerStatusState extends State<LockerStatus>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  List<LockerStatusModel> lockerStatuses = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getLockerStatus();
  }

  Future<void> getLockerStatus() async {
    setState(() {
      _isLoading = true;
    });
    try {
      lockerStatuses = await ApiResponse().lockerStatus();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<LockerStatusModel> requested =
        lockerStatuses
            .where((item) => item.status.toUpperCase() == "REQUESTED")
            .toList();
    List<LockerStatusModel> approved =
        lockerStatuses
            .where((item) => item.status.toUpperCase() == "APPROVED")
            .toList();

    return _isLoading
        ? const ProgressBar()
        : Scaffold(
          appBar: AppBar(
            title: const Text(
              'Locker Status',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: "REQUESTED"), Tab(text: "APPROVED")],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildStatusList(requested, isRequested: true),
              _buildStatusList(approved, isRequested: false),
            ],
          ),
        );
  }

  Widget _buildStatusList(
    List<LockerStatusModel> items, {
    required bool isRequested,
  }) {
    if (items.isEmpty) {
      return const Center(child: Text("No Data Available"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: items.length + 1, // Add 1 to account for the SizedBox
      itemBuilder: (context, index) {
        if (index == items.length) {
          // Return the SizedBox after the last item
          return const SizedBox(height: 70);
        }

        var item = items[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 3,
          child: ListTile(
            title: Text("Locker ID: ${item.lockerID}"),
            subtitle: Text("User ID: ${item.userId}\nStatus: ${item.status}"),
            trailing:
                isRequested
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () => _showApproveDialog(item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _showRejectDialog(item),
                        ),
                      ],
                    )
                    : IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _showRejectDialog(item),
                    ),
          ),
        );
      },
    );
  }

  void _showApproveDialog(LockerStatusModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Approve Locker"),
          content: Text("Do you want to approve Locker ID: ${item.lockerID}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _approveLocker(item);
                Navigator.pop(context);
              },
              child: const Text(
                "Approve",
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRejectDialog(LockerStatusModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject Locker"),
          content: Text("Do you want to reject Locker ID: ${item.lockerID}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _rejectLocker(item);
                Navigator.pop(context);
              },
              child: const Text("Reject", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _approveLocker(LockerStatusModel item) async {
    await ApiResponse().updateReservationStatus(item.id, "APPROVED");
    await getLockerStatus();
    Fluttertoast.showToast(msg: "Locker request approved successfully");

    setState(() {
      lockerStatuses =
          lockerStatuses.map((status) {
            if (status.id == item.id) {
              return LockerStatusModel(
                id: status.id,
                userId: status.userId,
                startDate: status.startDate,
                endDate: status.endDate,
                lockerID: status.lockerID,
                status: "APPROVED",
              );
            }
            return status;
          }).toList();
    });
  }

  Future<void> _rejectLocker(LockerStatusModel item) async {
    try {
      await ApiResponse().updateReservationStatus(item.id, "REJECTED");
      await getLockerStatus();
      Fluttertoast.showToast(msg: "Locker request rejected successfully");
      setState(() {
        lockerStatuses =
            lockerStatuses.map((status) {
              if (status.id == item.id) {
                return LockerStatusModel(
                  id: status.id,
                  userId: status.userId,
                  startDate: status.startDate,
                  endDate: status.endDate,
                  lockerID: status.lockerID,
                  status: "REJECTED", // Reject the locker
                );
              }
              return status;
            }).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to reject locker");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
