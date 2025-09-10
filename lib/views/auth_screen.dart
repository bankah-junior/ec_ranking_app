import 'package:ec_ranking/models/user_model.dart';
import 'package:ec_ranking/viewmodels/auth_viewmodel.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = context.read<AuthViewModel>();
    final userVM = context.read<UserViewModel>();

    if (isLogin) {
      await authVM.login(
        UserModel(
          email: emailController.text,
          password: passwordController.text,
        ),
      );
      await userVM.fetchUser();
    } else {
      await authVM.register(
        UserModel(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
          address: addressController.text,
          phone: phoneController.text,
        ),
      );
      await userVM.fetchUser();
    }

    if (authVM.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(authVM.errorMessage!)));
    } else if (userVM.user != null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ///
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        size: 50,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ///
                    Text(
                      isLogin ? "Welcome Back 👋" : "Create Your Account 🚀",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      isLogin
                          ? "Login to continue your journey"
                          : "Join us and start exploring insights",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),

                    ///
                    if (!isLogin) ...[
                      _buildInputField(
                        controller: nameController,
                        label: "Full Name",
                        icon: Icons.person_outline,
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter name" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.home_outlined,
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter address" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildInputField(
                        controller: phoneController,
                        label: "Phone",
                        icon: Icons.phone_outlined,
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter phone" : null,
                      ),
                      const SizedBox(height: 16),
                    ],

                    ///
                    _buildInputField(
                      controller: emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      validator: (val) => val == null || !val.contains('@')
                          ? "Enter valid email"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    ///
                    _buildInputField(
                      controller: passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (val) => val == null || val.length < 6
                          ? "Password too short"
                          : null,
                    ),
                    const SizedBox(height: 28),

                    ///
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: authVM.isLoading ? null : _submit,
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade700,
                                Colors.blue.shade400,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              isLogin ? "Login" : "Sign Up",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    ///
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(
                        isLogin
                            ? "Don’t have an account? Sign Up"
                            : "Already have an account? Login",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
      ),
    );
  }
}
