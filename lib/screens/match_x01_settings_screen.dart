import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_theme.dart';
import '../models/x01_play_mode.dart';
import '../models/main_user_model.dart';
import '../models/player.dart';
import '../services/player_service.dart';
import 'x01_match_screen.dart';

class MatchX01SettingsScreen extends StatefulWidget {
  const MatchX01SettingsScreen({super.key});

  @override
  State<MatchX01SettingsScreen> createState() => _MatchX01SettingsScreenState();
}

class _MatchX01SettingsScreenState extends State<MatchX01SettingsScreen> {
  int selectedButtonStartScore = 501;
  X01PlayMode selectedButtonSpielModus = X01PlayMode.withEnemy;

  String player1 = "Spieler 1";
  String player2 = "Spieler 2";

  int setCounter = 0;
  int legCounter = 0;

  MainUserModel? user1;
  MainUserModel? user2;
  
  Player? selectedPlayer1;
  Player? selectedPlayer2;
  final PlayerService _playerService = PlayerService();
  List<Player> _availablePlayers = [];

  bool doubleIn = false;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    try {
      final players = await _playerService.getAllPlayers();
      setState(() {
        _availablePlayers = players;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Laden der Spieler: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void handleLegCounterPlus() {
    setState(() {
      legCounter++;
    });
  }

  void handleSetCounterPlus() {
    setState(() {
      setCounter++;
    });
  }

  void handleLegCounterMinus() {
    setState(() {
      if (legCounter > 0) legCounter--;
    });
  }

  void handleSetCounterMinus() {
    setState(() {
      if (setCounter > 0) setCounter--;
    });
  }

  void startGame() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => X01MatchScreen(
          startScore: selectedButtonStartScore,
          playMode: selectedButtonSpielModus,
          legCount: legCounter,
          setCount: setCounter,
          user1: user1,
          user2: user2,
          doubleIn: doubleIn,
          selectedPlayer1: selectedPlayer1,
          selectedPlayer2: selectedPlayer2,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildScoreButton(int score) {
    final isSelected = selectedButtonStartScore == score;
    
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getSpacing(context, SpacingType.xs),
        ),
        child: CustomButton(
          text: score.toString(),
          type: isSelected ? ButtonType.primary : ButtonType.secondary,
          size: ResponsiveUtils.isMobile(context) ? ButtonSize.medium : ButtonSize.large,
          onPressed: () {
            setState(() {
              selectedButtonStartScore = score;
            });
          },
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, X01PlayMode mode) {
    final isSelected = selectedButtonSpielModus == mode;
    
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getSpacing(context, SpacingType.xs),
        ),
        child: CustomButton(
          text: text,
          type: isSelected ? ButtonType.primary : ButtonType.secondary,
          size: ResponsiveUtils.isMobile(context) ? ButtonSize.small : ButtonSize.medium,
          onPressed: () {
            setState(() {
              selectedButtonSpielModus = mode;
            });
          },
        ),
      ),
    );
  }

  void _showPlayerSelectionDialog(bool isPlayer1) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isPlayer1 ? "Spieler 1" : "Spieler 2"} auswählen'),
        content: Container(
          width: double.maxFinite,
          height: 300,
          child: _availablePlayers.isEmpty
            ? const Center(
                child: Text('Keine Spieler verfügbar. Bitte fügen Sie erst Spieler hinzu.'),
              )
            : ListView.builder(
                itemCount: _availablePlayers.length,
                itemBuilder: (context, index) {
                  final player = _availablePlayers[index];
                  final isSelected = isPlayer1 
                    ? selectedPlayer1?.id == player.id
                    : selectedPlayer2?.id == player.id;
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? Colors.green : Colors.blue,
                      child: Text(
                        player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(player.name),
                    subtitle: player.email != null && player.email!.isNotEmpty 
                      ? Text(player.email!) 
                      : null,
                    trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () {
                      setState(() {
                        if (isPlayer1) {
                          selectedPlayer1 = player;
                          player1 = player.name;
                          user1 = MainUserModel(
                            id: player.id.toString(),
                            name: player.name,
                            email: player.email ?? '',
                          );
                        } else {
                          selectedPlayer2 = player;
                          player2 = player.name;
                          user2 = MainUserModel(
                            id: player.id.toString(),
                            name: player.name,
                            email: player.email ?? '',
                          );
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          if (_availablePlayers.isEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/player-management');
              },
              child: const Text('Spieler hinzufügen'),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerButton(String playerText, bool isPlayer1) {
    final isSelected = isPlayer1 
      ? selectedPlayer1 != null
      : selectedPlayer2 != null;
    
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getSpacing(context, SpacingType.xs),
        ),
        child: CustomButton(
          text: playerText,
          type: isSelected ? ButtonType.success : ButtonType.secondary,
          size: ResponsiveUtils.isMobile(context) ? ButtonSize.small : ButtonSize.medium,
          onPressed: () => _showPlayerSelectionDialog(isPlayer1),
        ),
      ),
    );
  }

  Widget _buildCounterButton(String text, VoidCallback onPressed) {
    return Container(
      width: ResponsiveUtils.isMobile(context) ? 50 : 60,
      height: ResponsiveUtils.isMobile(context) ? 50 : 60,
      child: CustomButton(
        text: text,
        type: ButtonType.secondary,
        size: ButtonSize.small,
        onPressed: onPressed,
        customHeight: ResponsiveUtils.isMobile(context) ? 50 : 60,
        customWidth: ResponsiveUtils.isMobile(context) ? 50 : 60,
      ),
    );
  }

  Widget _buildCounterSection(String title, int count, VoidCallback onPlus, VoidCallback onMinus) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.sm)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCounterButton("-", onMinus),
            SizedBox(width: ResponsiveUtils.getSpacing(context, SpacingType.md)),
            _buildCounterButton("+", onPlus),
          ],
        ),
        SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.sm)),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.headline),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: ResponsiveUtils.getPagePadding(context),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 16, 49, 92),
                  Color.fromARGB(255, 24, 73, 138),
                  Color.fromARGB(255, 10, 31, 59),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo Section
                  Container(
                    height: ResponsiveUtils.isMobile(context) ? 150 : 200,
                    child: Image.asset(
                      "assets/images/Flightclub Logo.png",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.sports_score_rounded,
                          size: ResponsiveUtils.isMobile(context) ? 80 : 120,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.lg)),

                  // Start Score Section
                  Column(
                    children: [
                      Text(
                        "Startscore",
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.headline),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                      Row(
                        children: [
                          _buildScoreButton(301),
                          _buildScoreButton(501),
                          _buildScoreButton(701),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xl)),

                  // Game Mode Section
                  Column(
                    children: [
                      Text(
                        "Spielmodus",
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.headline),
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                      Row(
                        children: [
                          _buildModeButton("Ohne Gegner", X01PlayMode.withOutEnemy),
                          _buildModeButton("Mit Gegner", X01PlayMode.withEnemy),
                          _buildModeButton("vs. Bot", X01PlayMode.vsBot),
                        ],
                      ),
                    ],
                  ),

                  // Conditional Player Selection
                  if (selectedButtonSpielModus == X01PlayMode.withEnemy) ...[
                    SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xl)),
                    
                    // Player Selection Section
                    Column(
                      children: [
                        Text(
                          "Spieler wählen",
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.headline),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                        Row(
                          children: [
                            _buildPlayerButton(player1, true),
                            SizedBox(width: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                            _buildPlayerButton(player2, false),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xl)),

                    // Sets and Legs Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCounterSection("Sets", setCounter, handleSetCounterPlus, handleSetCounterMinus),
                        _buildCounterSection("Legs", legCounter, handleLegCounterPlus, handleLegCounterMinus),
                      ],
                    ),

                    SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xl)),

                    // Double In Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Double In",
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getFontSize(context, FontSizeType.title),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.getSpacing(context, SpacingType.md)),
                        Transform.scale(
                          scale: ResponsiveUtils.isMobile(context) ? 1.3 : 1.5,
                          child: Checkbox(
                            value: doubleIn,
                            onChanged: (bool? value) {
                              setState(() {
                                doubleIn = value!;
                              });
                            },
                            activeColor: AppTheme.primaryBlue,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xl)),

                    // Start Game Button
                    Container(
                      width: ResponsiveUtils.isMobile(context) 
                        ? ResponsiveUtils.getScreenWidth(context) * 0.7
                        : 300,
                      child: CustomButton(
                        text: "Spiel starten",
                        type: ButtonType.success,
                        size: ButtonSize.large,
                        onPressed: startGame,
                      ),
                    ),
                  ],

                  SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.xl)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}