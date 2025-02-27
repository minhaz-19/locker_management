import 'package:flutter/material.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/models/allUsers.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  List<User> users = [];
  bool _isLoading = false;

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  dynamic getUsers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      users = await ApiResponse().allUsers();
      users.sort((a, b) => a.id.compareTo(b.id)); // Sort users by ID
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showStatusChangeDialog(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Status Change"),
          content: Text(
            "Are you sure you want to change the status of ${user.name}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                changeUserStatus(user);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void changeUserStatus(User user) {
    // TODO: Implement the API call to change user status
    setState(() {
      // user.status = (user.status == "Active") ? "Inactive" : "Active";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User ${user.name} status changed to ${user.status}"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading == true)
        ? const ProgressBar()
        : Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text("Users", style: TextStyle(color: Colors.white)),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUserInfo("Name", user.name),
                            _buildUserInfo("ID", user.id.toString()),
                            _buildUserInfo("Email", user.email),
                            _buildUserInfo("Phone", user.phone),
                            _buildUserInfo("Role", user.roles),
                            _buildUserInfo("Status", user.status),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => _showStatusChangeDialog(user),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (user.status == "Active")
                                        ? Colors.red
                                        : Colors.green,
                              ),
                              child: Text(
                                (user.status == "ACTIVE")
                                    ? "Block"
                                    : "Activate",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (index == users.length - 1) const SizedBox(height: 70),
                  ],
                );
              },
            ),
          ),
        );
  }

  Widget _buildUserInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
