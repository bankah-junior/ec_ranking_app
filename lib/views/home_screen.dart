import 'package:ec_ranking/models/provider_model.dart';
import 'package:ec_ranking/viewmodels/overall_ranking_viewmodel.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
                Icons.bar_chart_rounded,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Economic Rankings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontFamily: "Raleway",
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.blue),
              onPressed: () => _refreshData(context),
            ),
          ),
        ],
      ),
      body: Consumer<OverallRankingViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.errorMessage != null) {
            return Column(
              children: [
                Center(
                  child: Text(
                    "❌ ${vm.errorMessage}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _refreshData(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            );
          }

          final ranking = vm.overallRanking;
          if (ranking == null || ranking.toString() == "[]") {
            return Column(
              children: [
                const Center(child: Text("No ranking data available.")),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _refreshData(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            );
          }

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

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        provider.provider.isNotEmpty
                            ? provider.provider[0] // first letter
                            : "?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    title: Text(
                      provider.provider,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    trailing: Text(
                      provider.fmi.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
