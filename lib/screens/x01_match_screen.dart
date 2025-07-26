import 'package:flutter/material.dart';
import '../models/x01_play_mode.dart';
import '../models/main_user_model.dart';
import '../models/game.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../services/game_service.dart';
import '../components/custom_button.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_theme.dart';

class X01MatchScreen extends StatefulWidget {
  final int startScore;
  final X01PlayMode playMode;
  final int legCount;
  final int setCount;
  final MainUserModel? user1;
  final MainUserModel? user2;
  final bool doubleIn;
  final Player? selectedPlayer1;
  final Player? selectedPlayer2;

  const X01MatchScreen({
    super.key,
    required this.startScore,
    required this.playMode,
    required this.legCount,
    required this.setCount,
    this.user1,
    this.user2,
    required this.doubleIn,
    this.selectedPlayer1,
    this.selectedPlayer2,
  });

  @override
  State<X01MatchScreen> createState() => _X01MatchScreenState();
}

class _X01MatchScreenState extends State<X01MatchScreen> {
  final ScrollController _scrollControllerPlayerOne = ScrollController();
  final ScrollController _scrollControllerPlayerTwo = ScrollController();
  final GameService _gameService = GameService();

  int playerOneScore = 0;
  int playerTwoScore = 0;
  
  Game? _currentGame;
  GameState? _currentGameState;

  List<String> numberArray = [];
  String currentAufnahme = "0";
  String playersTurn = "Player1";
  bool gameStarted = false;

  // Statistics
  int playerOneOver100Score = 0;
  int playerOneOver140Score = 0;
  int playerOneOver180Score = 0;
  int playerTwoOver100Score = 0;
  int playerTwoOver140Score = 0;
  int playerTwoOver180Score = 0;

  double playerOneAverage = 0.0;
  double playerTwoAverage = 0.0;
  int roundNumber = 0;

  List<String> _itemsPlayerOne = [];
  List<String> _itemsPlayerTwo = [];
  List<String> _itemsPlayerOneRestScore = [];
  List<String> _itemsPlayerTwoRestScore = [];

  final List<String> numpadItems = [
    '1', '2', '3',
    '4', '5', '6', 
    '7', '8', '9',
    '⌫', '0', '#'
  ];

  @override
  void initState() {
    super.initState();
    playerOneScore = widget.startScore;
    playerTwoScore = widget.startScore;
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    if (widget.selectedPlayer1 != null && widget.playMode == X01PlayMode.withEnemy) {
      try {
        final game = await _gameService.createGame(
          player1Id: widget.selectedPlayer1!.id,
          player2Id: widget.selectedPlayer2?.id,
          gameType: GameType.X01,
          gameMode: _getGameModeFromPlayMode(widget.playMode),
          startScore: widget.startScore,
          targetLegs: widget.legCount,
          targetSets: widget.setCount,
          doubleIn: widget.doubleIn,
          doubleOut: true,
        );
        
        final gameState = await _gameService.getGameState(game.id);
        
        setState(() {
          _currentGame = game;
          _currentGameState = gameState;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Erstellen des Spiels: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  GameMode _getGameModeFromPlayMode(X01PlayMode playMode) {
    switch (playMode) {
      case X01PlayMode.withEnemy:
        return GameMode.WITH_ENEMY;
      case X01PlayMode.withOutEnemy:
        return GameMode.WITHOUT_ENEMY;
      case X01PlayMode.vsBot:
        return GameMode.VS_BOT;
    }
  }

  Future<void> _saveGameState() async {
    if (_currentGame == null) return;

    try {
      final updatedGameState = await _gameService.updateGameState(
        _currentGame!.id,
        player1Score: playerOneScore,
        player2Score: playerTwoScore,
        currentPlayer: playersTurn == "Player1" ? CurrentPlayer.PLAYER1 : CurrentPlayer.PLAYER2,
        roundNumber: roundNumber,
      );
      
      setState(() {
        _currentGameState = updatedGameState;
      });
    } catch (e) {
      // Silent fail for now - could add error logging
      print('Failed to save game state: $e');
    }
  }

  void _scrollToBottom(ScrollController controller) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      _itemsPlayerOneRestScore.add(widget.startScore.toString());
      _itemsPlayerOne.add("");
      _itemsPlayerTwoRestScore.add(widget.startScore.toString());
      _itemsPlayerTwo.add("");
    });
  }

  void swapPlayers() {
    setState(() {
      playersTurn = playersTurn == "Player1" ? "Player2" : "Player1";
    });
  }

  void setCurrentAufnahme(String input) {
    setState(() {
      if (input == "⌫") {
        if (numberArray.isNotEmpty) {
          numberArray.removeLast();
        }
      } else if (input == "#") {
        // Clear all
        numberArray.clear();
      } else {
        try {
          String tempAufnahme = numberArray.join() + input;
          int total = int.parse(tempAufnahme);
          
          if (total <= 180) {
            numberArray.add(input);
          }
        } catch (e) {
          // Invalid input, ignore
        }
      }
      
      currentAufnahme = numberArray.isEmpty ? "0" : numberArray.join();
    });
  }

  void countPoints() {
    if (!gameStarted || currentAufnahme == "0") return;

    int points = int.parse(currentAufnahme);
    
    setState(() {
      if (playersTurn == "Player1") {
        int newScore = playerOneScore - points;
        if (newScore < 0 || (widget.doubleIn && newScore == 1)) {
          // Bust - no change to score
          _showBustDialog();
        } else {
          playerOneScore = newScore;
          _updateStatistics("Player1", points);
          _itemsPlayerOne.add(currentAufnahme);
          _itemsPlayerOneRestScore.add(playerOneScore.toString());
          
          if (playerOneScore == 0) {
            _showWinDialog("Player1");
            return;
          }
        }
        playersTurn = "Player2";
      } else {
        int newScore = playerTwoScore - points;
        if (newScore < 0 || (widget.doubleIn && newScore == 1)) {
          // Bust - no change to score
          _showBustDialog();
        } else {
          playerTwoScore = newScore;
          _updateStatistics("Player2", points);
          _itemsPlayerTwo.add(currentAufnahme);
          _itemsPlayerTwoRestScore.add(playerTwoScore.toString());
          
          if (playerTwoScore == 0) {
            _showWinDialog("Player2");
            return;
          }
        }
        playersTurn = "Player1";
      }

      // Reset input
      currentAufnahme = "0";
      numberArray.clear();
      
      // Update round and averages
      roundNumber++;
      _updateAverages();
      
      // Save game state to database
      _saveGameState();
      
      // Scroll to bottom
      _scrollToBottom(_scrollControllerPlayerOne);
      _scrollToBottom(_scrollControllerPlayerTwo);
    });
  }

  void _updateStatistics(String player, int points) {
    if (player == "Player1") {
      if (points >= 100 && points < 140) {
        playerOneOver100Score++;
      } else if (points >= 140 && points < 180) {
        playerOneOver140Score++;
      } else if (points == 180) {
        playerOneOver180Score++;
      }
    } else {
      if (points >= 100 && points < 140) {
        playerTwoOver100Score++;
      } else if (points >= 140 && points < 180) {
        playerTwoOver140Score++;
      } else if (points == 180) {
        playerTwoOver180Score++;
      }
    }
  }

  void _updateAverages() {
    if (roundNumber > 0) {
      int player1TotalPoints = widget.startScore - playerOneScore;
      int player2TotalPoints = widget.startScore - playerTwoScore;
      
      playerOneAverage = (player1TotalPoints / (roundNumber * 3)) * 3;
      playerTwoAverage = (player2TotalPoints / (roundNumber * 3)) * 3;
    }
  }

  void _showBustDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundDark,
          title: Text(
            "BUST!",
            style: TextStyle(
              color: Colors.red,
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
            ),
          ),
          content: Text(
            "Ungültiger Wurf! Der Spieler ist an der Reihe geblieben.",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.body),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog(String winner) {
    String winnerName = winner == "Player1" 
      ? (widget.user1?.name ?? "Spieler 1")
      : (widget.user2?.name ?? "Spieler 2");
      
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundDark,
          title: Text(
            "🎉 GEWONNEN! 🎉",
            style: TextStyle(
              color: Colors.green,
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "$winnerName hat das Spiel gewonnen!",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.body),
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to settings
              },
              child: Text(
                "Neues Spiel",
                style: TextStyle(color: AppTheme.primaryBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  void deleteLastRound() {
    if (!gameStarted) return;
    
    setState(() {
      if (playersTurn == "Player1") {
        // Undo Player 2's last move
        if (_itemsPlayerTwo.isNotEmpty && _itemsPlayerTwo.last.isNotEmpty) {
          int lastPoints = int.parse(_itemsPlayerTwo.last);
          playerTwoScore += lastPoints;
          _itemsPlayerTwo.removeLast();
          _itemsPlayerTwoRestScore.removeLast();
          playersTurn = "Player2";
        }
      } else {
        // Undo Player 1's last move
        if (_itemsPlayerOne.isNotEmpty && _itemsPlayerOne.last.isNotEmpty) {
          int lastPoints = int.parse(_itemsPlayerOne.last);
          playerOneScore += lastPoints;
          _itemsPlayerOne.removeLast();
          _itemsPlayerOneRestScore.removeLast();
          playersTurn = "Player1";
        }
      }
      
      if (roundNumber > 0) {
        roundNumber--;
        _updateAverages();
      }
    });
  }

  Widget _buildPlayerSection(String playerName, int score, double average, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: ResponsiveUtils.isMobile(context) ? 6 : 8,
          color: isActive ? AppTheme.primaryBlue : AppTheme.backgroundDark,
        ),
        color: AppTheme.backgroundDark,
      ),
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, SpacingType.sm)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playerName,
            style: TextStyle(
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xs)),
          Text(
            score.toString(),
            style: TextStyle(
              fontSize: ResponsiveUtils.isMobile(context) ? 80 : 130,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xs)),
          Text(
            "Average: ${average.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.body),
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection() {
    return Container(
      color: AppTheme.surfaceDark,
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, SpacingType.sm)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Punkte",
            style: TextStyle(
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.sm)),
          Text(
            "$playerOneScore : $playerTwoScore",
            style: TextStyle(
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.headline),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.md)),
          if (!gameStarted) ...[
            CustomButton(
              text: "Swap",
              type: ButtonType.secondary,
              size: ButtonSize.small,
              onPressed: swapPlayers,
            ),
            SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.sm)),
            CustomButton(
              text: "Start",
              type: ButtonType.primary,
              size: ButtonSize.medium,
              onPressed: startGame,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.getSpacing(context, SpacingType.xs),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem("100+", playerOneOver100Score),
          _buildStatItem("140+", playerOneOver140Score),
          _buildStatItem("180", playerOneOver180Score),
          _buildStatItem("100+", playerTwoOver100Score),
          _buildStatItem("140+", playerTwoOver140Score),
          _buildStatItem("180", playerTwoOver180Score),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
      ),
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, SpacingType.xs)),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.small),
            ),
          ),
          Text(
            value.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.body),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreList(List<String> scores, List<String> remainingScores, ScrollController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundDark,
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: ListView.builder(
        controller: controller,
        itemCount: scores.length,
        itemBuilder: (context, index) {
          if (index >= scores.length || index >= remainingScores.length) {
            return const SizedBox.shrink();
          }
          
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveUtils.getSpacing(context, SpacingType.xs),
              horizontal: ResponsiveUtils.getSpacing(context, SpacingType.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    scores[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: Text(
                    remainingScores[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNumpad() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, SpacingType.md)),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 2,
        ),
        itemCount: numpadItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setCurrentAufnahme(numpadItems[index]),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  numpadItems[index],
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppTheme.backgroundDark,
            title: Text(
              "Spiel beenden?",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Möchten Sie das laufende Spiel wirklich beenden?",
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("Abbrechen", style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Beenden", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        
        if (shouldPop == true) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // Player Scores Section
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPlayerSection(
                        widget.user1?.name ?? "Spieler 1",
                        playerOneScore,
                        playerOneAverage,
                        playersTurn == "Player1",
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getScreenWidth(context) * 0.25,
                      child: _buildScoreSection(),
                    ),
                    Expanded(
                      child: _buildPlayerSection(
                        widget.user2?.name ?? "Spieler 2",
                        playerTwoScore,
                        playerTwoAverage,
                        playersTurn == "Player2",
                      ),
                    ),
                  ],
                ),
              ),

              // Statistics Row
              _buildStatisticsRow(),

              // Score History
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildScoreList(
                        _itemsPlayerOne,
                        _itemsPlayerOneRestScore,
                        _scrollControllerPlayerOne,
                      ),
                    ),
                    Expanded(
                      child: _buildScoreList(
                        _itemsPlayerTwo,
                        _itemsPlayerTwoRestScore,
                        _scrollControllerPlayerTwo,
                      ),
                    ),
                  ],
                ),
              ),

              // Control Section
              Container(
                color: Colors.black,
                padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, SpacingType.sm)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: "Rückgängig",
                        type: ButtonType.danger,
                        size: ButtonSize.medium,
                        onPressed: deleteLastRound,
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveUtils.getSpacing(context, SpacingType.md)),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Aufnahme",
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.body),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              currentAufnahme,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.headline),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                    Expanded(
                      child: CustomButton(
                        text: "OK",
                        type: ButtonType.success,
                        size: ButtonSize.medium,
                        onPressed: countPoints,
                      ),
                    ),
                  ],
                ),
              ),

              // Numpad
              SizedBox(
                height: ResponsiveUtils.isMobile(context) ? 300 : 400,
                child: _buildNumpad(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}