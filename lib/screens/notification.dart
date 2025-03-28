import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/notificationModel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = false;

  // Sample notification data
  List<NotificationModel> notifications = [];

  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  dynamic getNotifications() async {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    setState(() {
      isLoading = true;
      notifications = [];
    });
    try {
      print("@@@@@start");
      notifications = await ApiResponse().notification();
      print("@@@@@@@@done");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading == true)
        ? const ProgressBar()
        : Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notifications',
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
              notifications.isEmpty
                  ? const Center(child: Text('No notifications available'))
                  : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          title: Text(notification.message),
                          subtitle: Text(
                            DateFormat('MMM dd, yyyy - hh:mm a').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                notification.timestamp,
                              ).toLocal(),
                            ),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          leading: const Icon(
                            Icons.notifications,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    },
                  ),
        );
  }
}
