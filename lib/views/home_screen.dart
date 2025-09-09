import 'package:ec_ranking/models/provider_model.dart';
import 'package:ec_ranking/viewmodels/overall_ranking_viewmodel.dart';
import 'package:ec_ranking/widgets/app_bar_widget.dart';
import 'package:ec_ranking/widgets/warning_message_widget.dart';
import 'package:ec_ranking/widgets/text_widget.dart';
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
      appBar: AppBarWidget(
        title: "Economic Calendar Rankings",
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
                      child: TextWidget(
                        text: provider.provider.isNotEmpty
                            ? provider.provider[0]
                            : "?",
                      ),
                    ),
                    title: TextWidget(text: provider.provider),
                    trailing: TextWidget(text: provider.fmi.toString()),
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
