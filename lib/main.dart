import 'package:ec_ranking/viewmodels/auth_viewmodel.dart';
import 'package:ec_ranking/viewmodels/event_ranking_viewmodel.dart';
import 'package:ec_ranking/viewmodels/overall_ranking_viewmodel.dart';
import 'package:ec_ranking/views/auth_screen.dart';
import 'package:ec_ranking/views/events_screen.dart';
import 'package:ec_ranking/views/home_screen.dart';
import 'package:ec_ranking/views/onboarding_screen.dart';
import 'package:ec_ranking/views/provider_detail_screen.dart';
import 'package:ec_ranking/views/setting_screen.dart';
import 'package:ec_ranking/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OverallRankingViewModel()),
        ChangeNotifierProvider(create: (_) => EventRankingViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Economic Calendar Ranking',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          fontFamily: "Raleway",
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/auth': (context) => const AuthScreen(),
          '/home': (context) => const HomeScreen(),
          '/events': (context) => const EventsScreen(),
          '/setting': (context) => SettingScreen(),
          '/provider-detail': (context) => ProviderDetailScreen(),
        },
      ),
    );
  }
}
