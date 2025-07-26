import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/statistics.dart';

class StatisticsService {
  static const String baseUrl = 'http://10.0.2.2:8081/api/statistics';

  Future<List<PlayerStatisticsSummary>> getAllPlayerStatistics() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => PlayerStatisticsSummary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<PlayerStatisticsSummary> getPlayerStatistics(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/player/$playerId/summary'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return PlayerStatisticsSummary.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Player statistics not found');
      } else {
        throw Exception('Failed to load player statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<PlayerStatisticsSummary>> getTopPlayers({
    String sortBy = 'winRate',
    int limit = 10,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/top?sortBy=$sortBy&limit=$limit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => PlayerStatisticsSummary.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top players: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}