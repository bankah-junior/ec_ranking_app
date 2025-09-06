import 'package:ec_ranking/models/event_ranking_model.dart';

class ProviderDetailArgs {
  final String providerName;
  final List<EventRankingModel> eventRankings;

  ProviderDetailArgs({
    required this.providerName,
    required this.eventRankings,
  });
}
