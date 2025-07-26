import 'game.dart';

enum CurrentPlayer { PLAYER1, PLAYER2 }

class GameState {
  final int id;
  final Game game;
  final int player1Score;
  final int player2Score;
  final int player1Legs;
  final int player2Legs;
  final int player1Sets;
  final int player2Sets;
  final CurrentPlayer currentPlayer;
  final int roundNumber;
  final int player1DartsThrown;
  final int player2DartsThrown;
  final DateTime updatedAt;

  GameState({
    required this.id,
    required this.game,
    required this.player1Score,
    required this.player2Score,
    this.player1Legs = 0,
    this.player2Legs = 0,
    this.player1Sets = 0,
    this.player2Sets = 0,
    this.currentPlayer = CurrentPlayer.PLAYER1,
    this.roundNumber = 1,
    this.player1DartsThrown = 0,
    this.player2DartsThrown = 0,
    required this.updatedAt,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      id: json['id'] as int,
      game: Game.fromJson(json['game']),
      player1Score: json['player1Score'] as int,
      player2Score: json['player2Score'] as int,
      player1Legs: json['player1Legs'] as int? ?? 0,
      player2Legs: json['player2Legs'] as int? ?? 0,
      player1Sets: json['player1Sets'] as int? ?? 0,
      player2Sets: json['player2Sets'] as int? ?? 0,
      currentPlayer: CurrentPlayer.values.firstWhere(
        (e) => e.toString() == 'CurrentPlayer.${json['currentPlayer']}',
      ),
      roundNumber: json['roundNumber'] as int? ?? 1,
      player1DartsThrown: json['player1DartsThrown'] as int? ?? 0,
      player2DartsThrown: json['player2DartsThrown'] as int? ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game': game.toJson(),
      'player1Score': player1Score,
      'player2Score': player2Score,
      'player1Legs': player1Legs,
      'player2Legs': player2Legs,
      'player1Sets': player1Sets,
      'player2Sets': player2Sets,
      'currentPlayer': currentPlayer.toString().split('.').last,
      'roundNumber': roundNumber,
      'player1DartsThrown': player1DartsThrown,
      'player2DartsThrown': player2DartsThrown,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  GameState copyWith({
    int? id,
    Game? game,
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
    DateTime? updatedAt,
  }) {
    return GameState(
      id: id ?? this.id,
      game: game ?? this.game,
      player1Score: player1Score ?? this.player1Score,
      player2Score: player2Score ?? this.player2Score,
      player1Legs: player1Legs ?? this.player1Legs,
      player2Legs: player2Legs ?? this.player2Legs,
      player1Sets: player1Sets ?? this.player1Sets,
      player2Sets: player2Sets ?? this.player2Sets,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      roundNumber: roundNumber ?? this.roundNumber,
      player1DartsThrown: player1DartsThrown ?? this.player1DartsThrown,
      player2DartsThrown: player2DartsThrown ?? this.player2DartsThrown,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'GameState{id: $id, player1Score: $player1Score, player2Score: $player2Score, currentPlayer: $currentPlayer}';
  }
}