import 'package:flutter/material.dart';
import 'package:locker_management/api/apimethods.dart';
import 'package:locker_management/component/progressbar.dart';
import 'package:locker_management/component/shared_preference.dart';
import 'package:locker_management/models/user.dart';
import 'package:locker_management/provider/userDetailsProvider.dart';
import 'package:locker_management/screens/login.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String name =
      UserDetailsProvider.userName != ""
          ? UserDetailsProvider.userName
          : "Your Name";
  String email =
      UserDetailsProvider.userEmail != ""
          ? UserDetailsProvider.userEmail
          : "Your Email";
  String phone =
      UserDetailsProvider.userMobile != ""
          ? UserDetailsProvider.userMobile
          : "Your Phone";
  String role =
      UserDetailsProvider.userRole != ""
          ? UserDetailsProvider.userRole
          : "Your Status";

  void _showEditDialog(
    String field,
    String currentValue,
    Function(String) onSave,
  ) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Enter new $field",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value, Function() onEdit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.purple),
          onPressed: onEdit,
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController oldPasswordController =
            TextEditingController();
        final TextEditingController newPasswordController =
            TextEditingController();
        final TextEditingController confirmPasswordController =
            TextEditingController();

        return AlertDialog(
          title: const Text("Change Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement password change logic here
                Navigator.pop(context);
              },
              child: const Text("Change"),
            ),
          ],
        );
      },
    );
  }

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  void getProfileData() async {
    setState(() {
      isLoading = true;
    });
    try {
      UserModel user = await ApiResponse().getUserDetails();
      setState(() {
        UserDetailsProvider.userName = user.name;
        UserDetailsProvider.userEmail = user.email;
        UserDetailsProvider.userMobile = user.phone;
        UserDetailsProvider.userRole = user.roles;
        UserDetailsProvider.userStatus = user.status ?? "";
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
            title: const Text("Profile", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            // place a logout button in the appbar
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: Colors.red),
                onPressed: () {
                  // show a dialog to confirm logout
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement logout logic here
                              removeDataFromDevice('email');
                              removeDataFromDevice('password');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                                (route) =>
                                    false, // This removes all previous routes
                              );
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildInfoCard(
                  "Name",
                  UserDetailsProvider.userName,
                  () => _showEditDialog(
                    "Name",
                    UserDetailsProvider.userName,
                    (newValue) => setState(() => name = newValue),
                  ),
                ),
                _buildInfoCard(
                  "Email",
                  UserDetailsProvider.userEmail,
                  () => _showEditDialog(
                    "Email",
                    UserDetailsProvider.userEmail,
                    (newValue) => setState(() => email = newValue),
                  ),
                ),
                _buildInfoCard(
                  "Phone No",
                  UserDetailsProvider.userMobile,
                  () => _showEditDialog(
                    "Phone No",
                    UserDetailsProvider.userMobile,
                    (newValue) => setState(() => phone = newValue),
                  ),
                ),
                _buildInfoCard(
                  "Status",
                  UserDetailsProvider.userStatus,
                  () => _showEditDialog(
                    "Status",
                    UserDetailsProvider.userStatus,
                    (newValue) => setState(() => role = newValue),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showChangePasswordDialog,
                  child: const Text("Change Password"),
                ),
              ],
            ),
          ),
        );
  }
}
