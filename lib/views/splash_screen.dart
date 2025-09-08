import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final pref = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () async {
      if (!mounted) return;
      final userVM = context.read<UserViewModel>();
      final prefs = SharedPreferencesAsync();
      bool? hasOnboarded = await prefs.getBool("hasOnboarded");
      await userVM.fetchUser();
      if (!mounted) return;
      if (hasOnboarded == null || hasOnboarded == false) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else {
        Navigator.pushReplacementNamed(context, '/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Economic Calendar Ranking",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Raleway",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
