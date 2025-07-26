import 'player.dart';

enum GameType { X01, CRICKET, BOBS27 }
enum GameMode { WITH_ENEMY, WITHOUT_ENEMY, VS_BOT }
enum GameStatus { IN_PROGRESS, FINISHED, ABORTED }

class Game {
  final int id;
  final Player player1;
  final Player? player2;
  final GameType gameType;
  final GameMode gameMode;
  final int startScore;
  final int targetLegs;
  final int targetSets;
  final bool doubleIn;
  final bool doubleOut;
  final GameStatus status;
  final Player? winner;
  final DateTime createdAt;
  final DateTime? finishedAt;

  Game({
    required this.id,
    required this.player1,
    this.player2,
    required this.gameType,
    required this.gameMode,
    required this.startScore,
    this.targetLegs = 0,
    this.targetSets = 0,
    this.doubleIn = false,
    this.doubleOut = true,
    this.status = GameStatus.IN_PROGRESS,
    this.winner,
    required this.createdAt,
    this.finishedAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      player1: Player.fromJson(json['player1']),
      player2: json['player2'] != null ? Player.fromJson(json['player2']) : null,
      gameType: GameType.values.firstWhere((e) => e.toString() == 'GameType.${json['gameType']}'),
      gameMode: GameMode.values.firstWhere((e) => e.toString() == 'GameMode.${json['gameMode']}'),
      startScore: json['startScore'] as int,
      targetLegs: json['targetLegs'] as int? ?? 0,
      targetSets: json['targetSets'] as int? ?? 0,
      doubleIn: json['doubleIn'] as bool? ?? false,
      doubleOut: json['doubleOut'] as bool? ?? true,
      status: GameStatus.values.firstWhere((e) => e.toString() == 'GameStatus.${json['status']}'),
      winner: json['winner'] != null ? Player.fromJson(json['winner']) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      finishedAt: json['finishedAt'] != null ? DateTime.parse(json['finishedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player1': player1.toJson(),
      'player2': player2?.toJson(),
      'gameType': gameType.toString().split('.').last,
      'gameMode': gameMode.toString().split('.').last,
      'startScore': startScore,
      'targetLegs': targetLegs,
      'targetSets': targetSets,
      'doubleIn': doubleIn,
      'doubleOut': doubleOut,
      'status': status.toString().split('.').last,
      'winner': winner?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'finishedAt': finishedAt?.toIso8601String(),
    };
  }

  Game copyWith({
    int? id,
    Player? player1,
    Player? player2,
    GameType? gameType,
    GameMode? gameMode,
    int? startScore,
    int? targetLegs,
    int? targetSets,
    bool? doubleIn,
    bool? doubleOut,
    GameStatus? status,
    Player? winner,
    DateTime? createdAt,
    DateTime? finishedAt,
  }) {
    return Game(
      id: id ?? this.id,
      player1: player1 ?? this.player1,
      player2: player2 ?? this.player2,
      gameType: gameType ?? this.gameType,
      gameMode: gameMode ?? this.gameMode,
      startScore: startScore ?? this.startScore,
      targetLegs: targetLegs ?? this.targetLegs,
      targetSets: targetSets ?? this.targetSets,
      doubleIn: doubleIn ?? this.doubleIn,
      doubleOut: doubleOut ?? this.doubleOut,
      status: status ?? this.status,
      winner: winner ?? this.winner,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  @override
  String toString() {
    return 'Game{id: $id, player1: ${player1.name}, player2: ${player2?.name}, gameType: $gameType, status: $status}';
  }
}