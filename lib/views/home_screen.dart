import 'package:ec_ranking/models/provider_model.dart';
import 'package:ec_ranking/viewmodels/overall_ranking_viewmodel.dart';
import 'package:ec_ranking/widgets/warning_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<OverallRankingViewModel>(context, listen: false);
      vm.fetchOverallRanking();
    });
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<OverallRankingViewModel>(
      context,
      listen: false,
    ).fetchOverallRanking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                ///
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/economic-calendar.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                ///
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromRGBO(0, 0, 0, 0.1),
                        const Color.fromRGBO(0, 0, 0, 0.5),
                      ],
                    ),
                  ),
                ),

                ///
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Economic Calendar",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.4),
                              offset: const Offset(1, 1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Stay updated with global financial events",
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: Consumer<OverallRankingViewModel>(
              builder: (context, vm, child) {
                if (vm.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (vm.errorMessage != null) {
                  return WarningMessageWidget(
                    text: vm.errorMessage!,
                    refreshData: () => _refreshData(context),
                  );
                }

                final ranking = vm.overallRanking;
                if (ranking == null || ranking.toString() == "[]") {
                  return WarningMessageWidget(
                    text: "No ranking data available.",
                    refreshData: () => _refreshData(context),
                  );
                }

                ///
                return RefreshIndicator(
                  onRefresh: () => _refreshData(context),
                  child: ListView.separated(
                    physics:
                        const AlwaysScrollableScrollPhysics(), // ensures pull works even if list is short
                    padding: const EdgeInsets.all(16),
                    itemCount: ranking.rankings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final ProviderModel provider = ranking.rankings[index];

                      ///
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(0, 0, 0, 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            // Provider Avatar
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                provider.provider.isNotEmpty
                                    ? provider.provider[0]
                                    : "?",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Provider Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.provider,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Provider Rank",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // FMI Score Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                provider.fmi.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
