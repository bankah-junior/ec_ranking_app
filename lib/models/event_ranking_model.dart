import 'package:ec_ranking/models/provider_model.dart';

class EventRankingModel {
  final String eventName;
  final List<ProviderModel> rankings;

  EventRankingModel({
    required this.eventName,
    required this.rankings,
  });

  factory EventRankingModel.fromJson(String event, List<dynamic> jsonList) {
    return EventRankingModel(
      eventName: event,
      rankings: jsonList.map((e) => ProviderModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "eventName": eventName,
      "rankings": rankings.map((e) => e.toJson()).toList(),
    };
  }
}
