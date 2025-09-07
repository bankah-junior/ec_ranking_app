import 'package:ec_ranking/main_layout.dart';
import 'package:ec_ranking/models/event_ranking_model.dart';
import 'package:ec_ranking/viewmodels/auth_viewmodel.dart';
import 'package:ec_ranking/viewmodels/event_ranking_viewmodel.dart';
import 'package:ec_ranking/viewmodels/overall_ranking_viewmodel.dart';
import 'package:ec_ranking/viewmodels/user_viewmodel.dart';
import 'package:ec_ranking/views/auth_screen.dart';
import 'package:ec_ranking/views/onboarding_screen.dart';
import 'package:ec_ranking/views/provider_detail_screen.dart';
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
        ChangeNotifierProvider(create: (_) => UserViewModel()),
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
          '/main': (context) => const MainLayout(),
          '/profile-detail': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;

            final providerName = args["providerName"] as String;
            final eventRankings =
                args["eventRankings"] as List<EventRankingModel>;

            return ProviderDetailScreen(
              providerName: providerName,
              eventRankings: eventRankings,
            );
          },
        },
      ),
    );
  }
}
