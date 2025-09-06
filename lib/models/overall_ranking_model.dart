import 'package:ec_ranking/models/provider_model.dart';

class OverallRankingModel {
  final List<ProviderModel> rankings;

  OverallRankingModel({required this.rankings});

  factory OverallRankingModel.fromJson(List<dynamic> jsonList) {
    return OverallRankingModel(
      rankings: jsonList.map((e) => ProviderModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "overall": rankings.map((e) => e.toJson()).toList(),
    };
  }
}
