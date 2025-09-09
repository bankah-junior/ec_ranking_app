import 'package:ec_ranking/models/event_ranking_model.dart';
import 'package:ec_ranking/services/ranking_service.dart';
import 'package:flutter/material.dart';

class EventRankingViewModel extends ChangeNotifier {
  final RankingService _rankingService = RankingService();

  List<EventRankingModel> _eventRankings = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<EventRankingModel> get eventRankings => _eventRankings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ///
  Future<void> fetchEventRankings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _rankingService.fetchRankings();
      _eventRankings = result["events"] as List<EventRankingModel>;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
