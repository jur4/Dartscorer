class PlayerStatisticsSummary {
  final int playerId;
  final String playerName;
  final int total180s;
  final int total140Plus;
  final int total100Plus;
  final int totalLegsWon;
  final int totalLegsLost;
  final int highestCheckout;
  final double overallAverage;
  final int gamesWon;
  final int totalGames;

  PlayerStatisticsSummary({
    required this.playerId,
    required this.playerName,
    this.total180s = 0,
    this.total140Plus = 0,
    this.total100Plus = 0,
    this.totalLegsWon = 0,
    this.totalLegsLost = 0,
    this.highestCheckout = 0,
    this.overallAverage = 0.0,
    this.gamesWon = 0,
    this.totalGames = 0,
  });

  factory PlayerStatisticsSummary.fromJson(Map<String, dynamic> json) {
    return PlayerStatisticsSummary(
      playerId: json['playerId'] as int,
      playerName: json['playerName'] as String,
      total180s: json['total180s'] as int? ?? 0,
      total140Plus: json['total140Plus'] as int? ?? 0,
      total100Plus: json['total100Plus'] as int? ?? 0,
      totalLegsWon: json['totalLegsWon'] as int? ?? 0,
      totalLegsLost: json['totalLegsLost'] as int? ?? 0,
      highestCheckout: json['highestCheckout'] as int? ?? 0,
      overallAverage: (json['overallAverage'] as num?)?.toDouble() ?? 0.0,
      gamesWon: json['gamesWon'] as int? ?? 0,
      totalGames: json['totalGames'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'total180s': total180s,
      'total140Plus': total140Plus,
      'total100Plus': total100Plus,
      'totalLegsWon': totalLegsWon,
      'totalLegsLost': totalLegsLost,
      'highestCheckout': highestCheckout,
      'overallAverage': overallAverage,
      'gamesWon': gamesWon,
      'totalGames': totalGames,
    };
  }

  double get winRate {
    if (totalGames == 0) return 0.0;
    return (gamesWon / totalGames) * 100;
  }

  double get legWinRate {
    final totalLegs = totalLegsWon + totalLegsLost;
    if (totalLegs == 0) return 0.0;
    return (totalLegsWon / totalLegs) * 100;
  }

  @override
  String toString() {
    return 'PlayerStatisticsSummary{playerName: $playerName, gamesWon: $gamesWon, totalGames: $totalGames, winRate: ${winRate.toStringAsFixed(1)}%}';
  }
}