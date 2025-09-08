import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/viewmodels/auth_viewmodel.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final authVM = context.read<AuthViewModel>();
    await authVM.getToken();
  }

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
                      },
                    )
                  : Container(
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.lock, color: Colors.blue),
                        onPressed: () => {
                          Navigator.pushNamed(context, '/auth'),
                        },
                      ),
                    );
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
          // 👤 Profile Card
          Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Consumer<UserViewModel>(
              builder: (context, userVM, child) {
                final user = userVM.user;
                if (user == null) {
                  return const SizedBox();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: const CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(
                              "assets/images/avatar.jpg",
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showUpdateInfoDialog(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),

          // ⚙️ Account Section
          Consumer<UserViewModel>(
            builder: (context, userVM, child) {
              // userVM.fetchUser();
              final user = userVM.user;
              if (user == null) {
                return const SizedBox();
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("ACCOUNT"),
                    _buildTile(
                      "Update Info",
                      icon: Icons.person,
                      onTap: () => _showUpdateInfoDialog(context),
                    ),
                    _buildTile(
                      "Change Password",
                      icon: Icons.lock,
                      onTap: () => _showChangePasswordDialog(context),
                    ),
                  ],
                );
              }
            },
          ),

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

  void _showUpdateInfoDialog(BuildContext context) {
    final userVM = context.read<UserViewModel>();
    final nameController = TextEditingController(text: userVM.user?.name ?? "");
    final addressController = TextEditingController(
      text: userVM.user?.address ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Update Info",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Save"),
            onPressed: () async {
              await userVM.updateUser(
                UserModel(
                  name: nameController.text,
                  address: addressController.text,
                ),
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final userVM = context.read<UserViewModel>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Change Password",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              decoration: const InputDecoration(labelText: "Current Password"),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: "Confirm New Password",
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Update"),
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Passwords do not match")),
                );
                return;
              }

              await userVM.changePassword(
                oldPasswordController.text,
                newPasswordController.text,
              );

              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
