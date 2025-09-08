import 'package:ec_ranking/models/provider_model.dart';
import 'package:ec_ranking/viewmodels/event_ranking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  String _selectedSort = "Score (High → Low)";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<EventRankingViewModel>(context, listen: false);
      vm.fetchEventRankings();
    });
  }

  Future<void> _refreshData(BuildContext context) async {
    final vm = Provider.of<EventRankingViewModel>(context, listen: false);
    vm.fetchEventRankings();
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
                Icons.calendar_today_rounded,
                color: Colors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Event Rankings",
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
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: PopupMenuButton<String>(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) => setState(() => _selectedSort = value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "Score (High → Low)",
                  child: Text("📈 Score (High → Low)"),
                ),
                const PopupMenuItem(
                  value: "Score (Low → High)",
                  child: Text("📉 Score (Low → High)"),
                ),
                const PopupMenuItem(
                  value: "Provider (A → Z)",
                  child: Text("🔤 Provider (A → Z)"),
                ),
              ],
              icon: const Icon(Icons.filter_list, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Consumer<EventRankingViewModel>(
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

          final events = vm.eventRankings;
          if (events.isEmpty) {
            return Column(
              children: [
                const Center(child: Text("No event ranking data available.")),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _refreshData(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            );
          }

          // 👉 Tab controller for events (NFP, CPI, PMI, etc.)
          return DefaultTabController(
            length: events.length,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 📌 Tabs for events
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.blue.shade700,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue.shade700,
                  tabs: events
                      .map((event) => Tab(text: event.eventName))
                      .toList(),
                ),

                // 📊 Providers per event
                Expanded(
                  child: TabBarView(
                    children: events.map((event) {
                      final providers = _sortProviders(event.rankings);

                      return ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: providers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final provider = providers[index];

                          // trend color & arrow
                          Color scoreColor;
                          IconData trendIcon;
                          if (provider.fmi >= 80) {
                            scoreColor = Colors.green;
                            trendIcon = Icons.trending_up;
                          } else if (provider.fmi >= 50) {
                            scoreColor = Colors.orange;
                            trendIcon = Icons.trending_flat;
                          } else {
                            scoreColor = Colors.red;
                            trendIcon = Icons.trending_down;
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/profile-detail',
                                arguments: {
                                  "providerName": provider.provider,
                                  "eventRankings":
                                      events, // pass the whole event rankings list
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // rank number
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue.shade50,
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // provider details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          provider.provider,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Accuracy: ${provider.fmi.toStringAsFixed(0)}%",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // score + trend
                                  Row(
                                    children: [
                                      Icon(
                                        trendIcon,
                                        color: scoreColor,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${provider.fmi.toStringAsFixed(0)}%",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: scoreColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Sorting logic for providers under each event
  List<ProviderModel> _sortProviders(List<ProviderModel> providers) {
    switch (_selectedSort) {
      case "Score (Low → High)":
        return [...providers]..sort((a, b) => a.fmi.compareTo(b.fmi));
      case "Provider (A → Z)":
        return [...providers]..sort((a, b) => a.provider.compareTo(b.provider));
      case "Score (High → Low)":
      default:
        return [...providers]..sort((a, b) => b.fmi.compareTo(a.fmi));
    }
  }
}
