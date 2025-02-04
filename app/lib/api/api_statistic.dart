import 'package:gestionary/utils/server_uri.dart';
import 'package:http/http.dart' as http;

const String url = AppURI.URLSERVER;

class StatisticsApi {
  getStatsByWeek(userId) async {
    var uri = "$url/stats/week_stats/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getStatsByMonth(userId) async {
    var uri = "$url/stats/month_stats/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getStatsByYear(userId) async {
    var uri = "$url/stats/year_stats/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getStatsByMostExpenses(userId) async {
    var uri = "$url/stats/most_expenses/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }

  getAllYearStats(userId) async {
    var uri = "$url/stats/all_year_stats/$userId";
    return await http.get(
      Uri.parse(uri),
      headers: {"Content-Type": "application/json", "Authorization": "Bearer "},
    );
  }
}
