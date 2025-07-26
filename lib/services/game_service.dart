import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../models/game_state.dart';

class GameService {
  static const String baseUrl = 'http://10.0.2.2:8081/api/games';
  static const String gameStateUrl = 'http://10.0.2.2:8081/api/gamestate';

  Future<Game> createGame({
    required int player1Id,
    int? player2Id,
    required GameType gameType,
    required GameMode gameMode,
    required int startScore,
    int targetLegs = 0,
    int targetSets = 0,
    bool doubleIn = false,
    bool doubleOut = true,
  }) async {
    try {
      final requestBody = {
        'player1Id': player1Id,
        if (player2Id != null) 'player2Id': player2Id,
        'gameType': gameType.toString().split('.').last,
        'gameMode': gameMode.toString().split('.').last,
        'startScore': startScore,
        'targetLegs': targetLegs,
        'targetSets': targetSets,
        'doubleIn': doubleIn,
        'doubleOut': doubleOut,
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create game: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Game> getGameById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Game not found');
      } else {
        throw Exception('Failed to load game: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<Game>> getAllGames() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load games: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<Game>> getGamesByPlayer(int playerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/player/$playerId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load player games: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<List<Game>> getActiveGames() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/active'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Game.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load active games: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<Game> finishGame(int gameId, {int? winnerId}) async {
    try {
      final requestBody = {
        if (winnerId != null) 'winnerId': winnerId,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/$gameId/finish'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return Game.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Game not found');
      } else {
        throw Exception('Failed to finish game: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<void> deleteGame(int gameId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$gameId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Game not found');
      } else {
        throw Exception('Failed to delete game: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  // Game State methods
  Future<GameState> getGameState(int gameId) async {
    try {
      final response = await http.get(
        Uri.parse('$gameStateUrl/game/$gameId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return GameState.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Game state not found');
      } else {
        throw Exception('Failed to load game state: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }

  Future<GameState> updateGameState(int gameId, {
    int? player1Score,
    int? player2Score,
    int? player1Legs,
    int? player2Legs,
    int? player1Sets,
    int? player2Sets,
    CurrentPlayer? currentPlayer,
    int? roundNumber,
    int? player1DartsThrown,
    int? player2DartsThrown,
  }) async {
    try {
      final requestBody = <String, dynamic>{};
      
      if (player1Score != null) requestBody['player1Score'] = player1Score;
      if (player2Score != null) requestBody['player2Score'] = player2Score;
      if (player1Legs != null) requestBody['player1Legs'] = player1Legs;
      if (player2Legs != null) requestBody['player2Legs'] = player2Legs;
      if (player1Sets != null) requestBody['player1Sets'] = player1Sets;
      if (player2Sets != null) requestBody['player2Sets'] = player2Sets;
      if (currentPlayer != null) requestBody['currentPlayer'] = currentPlayer.toString().split('.').last;
      if (roundNumber != null) requestBody['roundNumber'] = roundNumber;
      if (player1DartsThrown != null) requestBody['player1DartsThrown'] = player1DartsThrown;
      if (player2DartsThrown != null) requestBody['player2DartsThrown'] = player2DartsThrown;

      final response = await http.put(
        Uri.parse('$gameStateUrl/game/$gameId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        return GameState.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Game state not found');
      } else {
        throw Exception('Failed to update game state: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to server: $e');
    }
  }
}