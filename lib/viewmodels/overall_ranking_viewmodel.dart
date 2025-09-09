import 'package:ec_ranking/models/overall_ranking_model.dart';
import 'package:ec_ranking/services/ranking_service.dart';
import 'package:flutter/material.dart';

class OverallRankingViewModel extends ChangeNotifier {
  final RankingService _rankingService = RankingService();

  OverallRankingModel? _overallRanking;
  bool _isLoading = false;
  String? _errorMessage;

  OverallRankingModel? get overallRanking => _overallRanking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ///
  Future<void> fetchOverallRanking() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _rankingService.fetchRankings();
      _overallRanking = result["overall"] as OverallRankingModel;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
