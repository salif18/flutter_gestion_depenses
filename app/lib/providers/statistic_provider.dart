import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestionary/api/api_budget.dart';
import 'package:gestionary/api/api_statistic.dart';
import 'package:gestionary/models/all_year_stats.dart';
import 'package:gestionary/models/raportcurrentbudget.dart';
import 'package:gestionary/models/mostexpenses.dart';
import 'package:gestionary/models/month_stats.dart';
import 'package:gestionary/models/week_stats.dart';
import 'package:gestionary/models/year_stats.dart';
import 'package:gestionary/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StatisticsProvider extends ChangeNotifier {
  List<ModelWeekStats>? _receivedDataWeek = [];
  final StreamController<String?> _totalMonthStream =
      StreamController<String?>.broadcast();
  final StreamController<String?> _totalWeekStream =
      StreamController<String?>.broadcast();
  final StreamController<List<ModelMonthStats>?> _receivedDataMonthStream =
      StreamController<List<ModelMonthStats>?>.broadcast();
  final StreamController<ModelYearStats?> _statsYearStream =
      StreamController<ModelYearStats?>.broadcast();
  final StreamController<ModelTheMostExpense?> _theMostExpense =
      StreamController<ModelTheMostExpense?>.broadcast();
  final StreamController<ModelRapportCurrentBudgets?> _statsBudgets = StreamController<ModelRapportCurrentBudgets?>.broadcast();
  ModelAllYearStats? _statsAllyear;
  
  List<ModelWeekStats>? get receivedDataWeekNoStream => _receivedDataWeek;
  ModelAllYearStats? get statAllYear => _statsAllyear;
 

  final StatisticsApi _statsApi = StatisticsApi();
  final BudgetApi _budgetApi = BudgetApi();

  Future<void> fetchStatisticsWeek(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _statsApi.getStatsByWeek(userId);
      if (res.statusCode == 200) {
        dynamic decodedData = jsonDecode(res.body);
        _receivedDataWeek = (decodedData["stats"] as List)
            .map((json) => ModelWeekStats.fromJson(json))
            .toList();
        _totalWeekStream.add(decodedData["weekTotal"].toString());
        notifyListeners();
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> fetchStatisticsMonth(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _statsApi.getStatsByMonth(userId);
      if (res.statusCode == 200) {
        dynamic decodedData = jsonDecode(res.body);
        _receivedDataMonthStream.add((decodedData["stats"] as List)
            .map((json) => ModelMonthStats.fromJson(json))
            .toList());
        _totalMonthStream.add(decodedData["monthTotal"].toString());
        notifyListeners();
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> fetchStatisticsYear(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _statsApi.getStatsByYear(userId);
      if (res.statusCode == 200) {
        dynamic decodedData = jsonDecode(res.body);
        _statsYearStream.add(ModelYearStats?.fromJson(decodedData));
        notifyListeners();
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<void> fetchStatisticsTheMost(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _statsApi.getStatsByMostExpenses(userId);
      dynamic decodedData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        ModelTheMostExpense? expenses =
            ModelTheMostExpense.fromJson(decodedData["expenses"]);
        _theMostExpense.add(expenses);
        notifyListeners();
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }


  Future<void> fetchStatisticsCurrentBudget(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _budgetApi.getRapportsBudgetCurrent(userId);
       dynamic decodedData = jsonDecode(res.body);
      if (res.statusCode == 200) {
       ModelRapportCurrentBudgets? budget = ModelRapportCurrentBudgets?.fromJson(decodedData["resultat"]);
        _statsBudgets.add(budget);
        notifyListeners();
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

   Future<void> fetchStatisticsAllYear(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await provider.userId();
    try {
      final res = await _statsApi.getAllYearStats(userId);
       dynamic decodedData = jsonDecode(res.body);
      if (res.statusCode == 200) {
       _statsAllyear = ModelAllYearStats.fromJson(decodedData);
        notifyListeners();
      } else {
        return;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Stream<String?> loadTotalMonth() {
    return _totalMonthStream.stream;
  }

  Stream<String?> loadTotalWeekStream() {
    return _totalWeekStream.stream;
  }

  Stream<ModelYearStats?> loadStatsYearStream() {
    return _statsYearStream.stream;
  }

  Stream<List<ModelMonthStats>?> loadDataMonthStream() {
    return _receivedDataMonthStream.stream;
  }

  Stream<ModelTheMostExpense?> loadTheMostExpenseStream() {
    return _theMostExpense.stream;
  }

   Stream<ModelRapportCurrentBudgets?> loadTheStatsBudgetStream() {
    return _statsBudgets.stream;
  }

 
}
