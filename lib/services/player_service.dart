import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player.dart';

class PlayerService {
  static const String baseUrl = 'http://10.0.2.2:8081/api/players';

  Future<List<Player>> getAllPlayers() async {
    try {
      print('DEBUG PlayerService: Making GET request to $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('DEBUG PlayerService: Response status: ${response.statusCode}');
      print('DEBUG PlayerService: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        print('DEBUG PlayerService: Parsed ${jsonList.length} players from JSON');
        return jsonList.map((json) => Player.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load players: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG PlayerService: Exception occurred: $e');
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Player> getPlayerById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Player.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Player not found');
      } else {
        throw Exception('Failed to load player: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<Player>> searchPlayers(String name) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?name=${Uri.encodeComponent(name)}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Player.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search players: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Player> createPlayer(String name, String? email) async {
    try {
      final requestBody = {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return Player.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        throw Exception('Player with this name already exists');
      } else {
        throw Exception('Failed to create player: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Player> updatePlayer(int id, String name, String? email) async {
    try {
      final requestBody = {
        'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return Player.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Player not found');
      } else if (response.statusCode == 400) {
        throw Exception('Player with this name already exists');
      } else {
        throw Exception('Failed to update player: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<void> deletePlayer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Player not found');
      } else {
        throw Exception('Failed to delete player: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<int> getActivePlayerCount() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/count'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as int;
      } else {
        throw Exception('Failed to get player count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}