import 'package:flutter/material.dart';

class UsersTab extends StatefulWidget {
  const UsersTab({super.key});

  @override
  State<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<UsersTab> {
  // Sample user data
  List<Map<String, String>> users = [
    {
      "name": "John Doe",
      "email": "john.doe@example.com",
      "phone": "+1 234 567 890",
      "role": "Admin",
    },
    {
      "name": "Jane Smith",
      "email": "jane.smith@example.com",
      "phone": "+1 987 654 321",
      "role": "User",
    },
    {
      "name": "Robert Brown",
      "email": "robert.brown@example.com",
      "phone": "+44 7700 900123",
      "role": "Moderator",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return Card(
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
                    _buildUserInfo("Name", user["name"] ?? ""),
                    _buildUserInfo("Email", user["email"] ?? ""),
                    _buildUserInfo("Phone", user["phone"] ?? ""),
                    _buildUserInfo("Role", user["role"] ?? ""),
                  ],
                ),
              ),
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
