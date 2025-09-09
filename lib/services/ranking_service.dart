import 'dart:convert';
import 'package:ec_ranking/models/event_ranking_model.dart';
import 'package:ec_ranking/models/overall_ranking_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const _baseUrl =
    "https://ec-rankings-webapp-server-new.onrender.com/api/cleanedData/getCalculatedFairRanking";

class RankingService {
  final String _cacheKey = "ranking_data";
  final String _cacheTimeKey = "ranking_last_fetch";

  /// Fetch all rankings (overall + byEvent), cached weekly
  Future<Map<String, dynamic>> fetchRankings() async {
    final prefs = await SharedPreferences.getInstance();

    // Check cache validity
    final lastFetch = prefs.getString(_cacheTimeKey);
    if (lastFetch != null) {
      final lastFetchDate = DateTime.parse(lastFetch);
      final now = DateTime.now();

      if (now.difference(lastFetchDate).inDays < 7) {
        final cached = prefs.getString(_cacheKey);
        if (cached != null) {
          final data = jsonDecode(cached);

          final overall = OverallRankingModel.fromJson(data["overall"]);
          final events = (data["events"] as List)
              .map((e) => EventRankingModel.fromJson(e["event"], e["list"]))
              .toList();

          return {"overall": overall, "events": events};
        }
      }
    }

    // No valid cache -> Fetch fresh data
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to load rankings: ${response.body}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final overall = OverallRankingModel.fromJson(data["overall"]);

    final events = <EventRankingModel>[];
    final byEvent = data["byEvent"] as Map<String, dynamic>;
    byEvent.forEach((event, list) {
      events.add(EventRankingModel.fromJson(event, list));
    });

    // Cache new data + timestamp
    final cachePayload = {
      "overall": data["overall"],
      "events": byEvent.entries
          .map((e) => {"event": e.key, "list": e.value})
          .toList(),
    };
    await prefs.setString(_cacheKey, jsonEncode(cachePayload));
    await prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());

    return {"overall": overall, "events": events};
  }
}
