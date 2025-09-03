import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // 🔹 Profile
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("Profile"),
            subtitle: const Text("View and edit your details"),
            onTap: () {
              // TODO: Navigate to profile page
            },
          ),

          const Divider(),

          // 🔹 Change Language
          ListTile(
            leading: const Icon(Icons.language, color: Colors.orange),
            title: const Text("Change Language"),
            subtitle: const Text("Select app language"),
            onTap: () {
              // TODO: Open language selection dialog
            },
          ),

          const Divider(),

          // 🔹 Notifications
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.purple),
            title: const Text("Notifications"),
            subtitle: const Text("Manage notification settings"),
            onTap: () {
              // TODO: Notification settings page
            },
          ),

          const Divider(),

          // 🔹 Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout"),
            onTap: () {
              // Example: Firebase logout (if using FirebaseAuth)
              // FirebaseAuth.instance.signOut();
              Navigator.pop(context); // Go back after logout
            },
          ),
        ],
      ),
    );
  }
}
