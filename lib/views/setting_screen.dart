import 'package:ec_ranking/viewmodels/auth_viewmodel.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: "Raleway",
              ),
            ),
          ],
        ),
        actions: [
          Consumer<AuthViewModel>(
            builder: (context, authVM, child) {
              return authVM.accessToken != null &&
                      authVM.accessToken!.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent,
                      ),
                      tooltip: "Logout",
                      onPressed: () {
                        authVM.logout();
                        Navigator.popAndPushNamed(context, "/auth");
                      },
                    )
                  : const SizedBox();
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),

          // 👤 Profile Card
          Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Consumer<UserViewModel>(
              builder: (context, userVM, child) {
                // userVM.fetchUser();
                final user = userVM.user;
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  title: Text(
                    user?.name ?? "Guest",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    user?.email ?? "guest@example.com",
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ⚙️ Account Section
          _buildSectionTitle("ACCOUNT"),
          _buildTile("Update Info", icon: Icons.person, onTap: () {}),
          _buildTile("Change Password", icon: Icons.lock, onTap: () {}),

          const SizedBox(height: 16),

          // 📌 About
          _buildSectionTitle("ABOUT"),
          _buildTile("Version", trailing: const Text("1.0.0")),
          _buildTile("Terms of Service", onTap: () {}),
          _buildTile("Privacy Policy", onTap: () {}),

          const SizedBox(height: 16),

          // 💬 Support
          _buildSectionTitle("SUPPORT"),
          _buildTile("Provide Feedback", icon: Icons.feedback, onTap: () {}),

          const SizedBox(height: 16),

          // 🌐 API
          _buildSectionTitle("API"),
          _buildTile(
            "Provider",
            trailing: Text(
              "FinData",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _buildTile(
            "API Version",
            trailing: const Text(
              "v2",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Section Header
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  /// Modern Tile
  Widget _buildTile(
    String title, {
    IconData? icon,
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: icon != null
            ? Icon(icon, color: iconColor ?? Colors.blue.shade700)
            : null,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.black,
          ),
        ),
        trailing:
            trailing ??
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}
