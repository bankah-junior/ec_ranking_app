import 'dart:convert';
import 'package:ec_ranking/models/event_ranking_model.dart';
import 'package:ec_ranking/models/overall_ranking_model.dart';
import 'package:http/http.dart' as http;

const _baseUrl =
    "https://ec-rankings-webapp-server-new.onrender.com/api/cleanedData/getCalculatedFairRanking";

class RankingService {
  /// Fetch all rankings (overall + byEvent)
  Future<Map<String, dynamic>> fetchRankings() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods':
          'GET,PUT,POST,DELETE'
        });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to load rankings: ${response.body}");
    }

    final Map<String, dynamic> data = jsonDecode(response.body);

    // Parse Overall
    final overall = OverallRankingModel.fromJson(data["overall"]);

    // Parse Events
    final events = <EventRankingModel>[];
    final byEvent = data["byEvent"] as Map<String, dynamic>;
    byEvent.forEach((event, list) {
      events.add(EventRankingModel.fromJson(event, list));
    });

    return {"overall": overall, "events": events};
  }

  /// Fetch only overall rankings
  Future<OverallRankingModel> fetchOverall() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods':
          'GET,PUT,POST,DELETE'
        });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to load overall rankings");
    }

    final data = jsonDecode(response.body);
    return OverallRankingModel.fromJson(data["overall"]);
  }

  /// Fetch rankings by event
  Future<List<EventRankingModel>> fetchByEvents() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Credentials': 'true',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods':
          'GET,PUT,POST,DELETE'
        });

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to load event rankings");
    }

    final data = jsonDecode(response.body);
    final byEvent = data["byEvent"] as Map<String, dynamic>;

    return byEvent.entries
        .map((entry) => EventRankingModel.fromJson(entry.key, entry.value))
        .toList();
  }
}
