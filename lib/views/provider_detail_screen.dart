import 'package:ec_ranking/models/event_ranking_model.dart';
import 'package:ec_ranking/models/provider_model.dart';
import 'package:ec_ranking/widgets/provider_detail_screen/stat_widget.dart';
import 'package:flutter/material.dart';

class ProviderDetailScreen extends StatefulWidget {
  final String providerName;
  final List<EventRankingModel> eventRankings;

  const ProviderDetailScreen({
    super.key,
    required this.providerName,
    required this.eventRankings,
  });

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final providerPerformances = widget.eventRankings.map((event) {
      final match = event.rankings.firstWhere(
        (p) => p.provider == widget.providerName,
        orElse: () => ProviderModel(provider: widget.providerName, fmi: 0),
      );
      return {"event": event.eventName, "fmi": match.fmi};
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 26,
          ),
          tooltip: "Back",
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.providerName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: _isFavorite ? Colors.amber.shade600 : Colors.grey.shade500,
              size: 26,
            ),
            tooltip: _isFavorite ? "Unfavorite" : "Add to Favorites",
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.blue.shade700,
                  content: Text(
                    _isFavorite
                        ? "${widget.providerName} added to favorites ⭐"
                        : "${widget.providerName} removed from favorites",
                    style: const TextStyle(color: Colors.white),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ///
          Text(
            "Provider Overview",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),

          ///
          Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: const Color.fromRGBO(187, 222, 251, 0.5),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatWidget(
                        icon: Icons.event_available,
                        value: "${providerPerformances.length}",
                        label: "Events Tracked",
                        color: const Color.fromRGBO(30, 136, 229, 1),
                        bgColor: const Color.fromRGBO(30, 136, 229, 0.15),
                      ),
                      StatWidget(
                        icon: Icons.insights_rounded,
                        value:
                            "${providerPerformances.isNotEmpty ? (providerPerformances.map((e) => e["fmi"] as double).reduce((a, b) => a + b) / providerPerformances.length).toStringAsFixed(2) : "0"}%",
                        label: "Avg FMI",
                        color: const Color.fromRGBO(67, 160, 71, 1),
                        bgColor: const Color.fromRGBO(67, 160, 71, 0.15),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          ///
          Text(
            "Performance Across Events",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),

          ///
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.blue.shade50),
              columns: const [
                DataColumn(
                  label: Text(
                    "Event",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),

                DataColumn(
                  numeric: true,
                  label: Text(
                    "FMI Score",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
              rows: providerPerformances.map((performance) {
                final score = performance["fmi"] as double;
                Color scoreColor;
                IconData trendIcon;
                if (score >= 80) {
                  scoreColor = Colors.green;
                  trendIcon = Icons.trending_up;
                } else if (score >= 50) {
                  scoreColor = Colors.orange;
                  trendIcon = Icons.trending_flat;
                } else {
                  scoreColor = Colors.red;
                  trendIcon = Icons.trending_down;
                }
                return DataRow(
                  cells: [
                    DataCell(Text(performance["event"].toString())),

                    DataCell(
                      Row(
                        children: [
                          Icon(trendIcon, color: scoreColor, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "${score.toStringAsFixed(2)}%",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: scoreColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
