import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/viewmodels/auth_viewmodel.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:ec_ranking/widgets/app_bar_widget.dart';
import 'package:ec_ranking/widgets/setting_screen/section_title_widget.dart';
import 'package:ec_ranking/widgets/setting_screen/tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> openLink(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: "Settings",
        actions: [
          Consumer<AuthViewModel>(
            builder: (context, authVM, child) {
              ///
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: ListView(
          children: [
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
                    return Column(
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
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

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
                      SectionTitleWidget(title: "ACCOUNT"),
                      TileWidget(
                        title: "Update Info",
                        icon: Icons.person,
                        onTap: () => _showUpdateInfoDialog(context),
                      ),
                      TileWidget(
                        title: "Change Password",
                        icon: Icons.lock,
                        onTap: () => _showChangePasswordDialog(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }
              },
            ),

            SectionTitleWidget(title: "ABOUT"),
            TileWidget(title: "Version", trailing: const Text("1.0.0")),
            TileWidget(title: "Terms of Service", onTap: () {}),
            TileWidget(title: "Privacy Policy", onTap: () {}),
            const SizedBox(height: 16),

            SectionTitleWidget(title: "SUPPORT"),
            TileWidget(
              title: "Provide Feedback",
              icon: Icons.feedback,
              onTap: () {},
            ),
            const SizedBox(height: 16),

            SectionTitleWidget(title: "API"),
            TileWidget(
              title: "Provider",
              trailing: Text(
                "FinData",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TileWidget(
              title: "API Version",
              trailing: const Text(
                "v2",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),

            SectionTitleWidget(title: "Developer"),
            TileWidget(
              title: "Portfolio",
              icon: Icons.link,
              onTap: () => openLink('https://anthonybekoebankah.netlify.app'),
            ),
            const SizedBox(height: 24),
          ],
        ),
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
            child: const Text("Save", style: TextStyle(color: Colors.white)),
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
            child: const Text("Update", style: TextStyle(color: Colors.white)),
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
