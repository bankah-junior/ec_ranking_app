import 'package:flutter/material.dart';
import '../models/event_ranking_model.dart';
import '../models/provider_model.dart';

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
    // Collect performance data for this provider across all events
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
        elevation: 0.5,
        centerTitle: true,
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
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card with summary info
          Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Provider Overview",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        "Events Tracked",
                        "${providerPerformances.length}",
                      ),
                      _buildStat(
                        "Avg FMI",
                        "${providerPerformances.isNotEmpty ? (providerPerformances.map((e) => e["fmi"] as double).reduce((a, b) => a + b) / providerPerformances.length).toStringAsFixed(1) : "0"}%",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Performance table
          Text(
            "Performance Across Events",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
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
                if (score >= 80) {
                  scoreColor = Colors.green;
                } else if (score >= 50) {
                  scoreColor = Colors.orange;
                } else {
                  scoreColor = Colors.red;
                }
                return DataRow(
                  cells: [
                    DataCell(Text(performance["event"].toString())),
                    DataCell(
                      Text(
                        "${score.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: scoreColor,
                        ),
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

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
