import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../utils/responsive_utils.dart';
import '../models/player.dart';
import '../models/statistics.dart';
import '../services/player_service.dart';
import '../services/statistics_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PlayerService _playerService = PlayerService();
  final StatisticsService _statisticsService = StatisticsService();
  
  List<Player> _players = [];
  List<PlayerStatisticsSummary> _allStatistics = [];
  Player? _selectedPlayer;
  PlayerStatisticsSummary? _selectedPlayerStats;
  bool _isLoading = true;
  String _sortBy = 'winRate';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final players = await _playerService.getAllPlayers();
      setState(() {
        _players = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Fehler beim Laden der Daten: $e');
    }
  }

  Future<void> _loadPlayerStatistics(Player player) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _statisticsService.getPlayerStatistics(player.id);
      setState(() {
        _selectedPlayer = player;
        _selectedPlayerStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Fehler beim Laden der Statistiken: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D47A1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/flightclub_logo.png',
              height: 30,
            ),
            const SizedBox(width: 12),
            const Text(
              'Statistiken',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Spielerauswahl'),
            Tab(text: 'Rangliste'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPlayerSelectionTab(),
            _buildRankingTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSelectionTab() {
    return Padding(
      padding: ResponsiveUtils.getPagePadding(context),
      child: Column(
        children: [
          if (_selectedPlayer == null) ...[
            const Text(
              'Wählen Sie einen Spieler aus:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _buildPlayersList(),
            ),
          ] else ...[
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedPlayer = null;
                      _selectedPlayerStats = null;
                    });
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  'Statistiken für ${_selectedPlayer!.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _buildPlayerStatistics(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRankingTab() {
    return Padding(
      padding: ResponsiveUtils.getPagePadding(context),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Sortieren nach:',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButton<String>(
                  value: _sortBy,
                  dropdownColor: const Color(0xFF1976D2),
                  style: const TextStyle(color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'winRate', child: Text('Siegquote')),
                    DropdownMenuItem(value: 'total180s', child: Text('180er')),
                    DropdownMenuItem(value: 'gamesWon', child: Text('Gewonnene Spiele')),
                    DropdownMenuItem(value: 'overallAverage', child: Text('Durchschnitt')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Rangliste wird nach Backend-Integration verfügbar sein',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList() {
    if (_players.isEmpty) {
      return const Center(
        child: Text(
          'Keine Spieler gefunden',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _players.length,
      itemBuilder: (context, index) {
        final player = _players[index];
        return _buildPlayerCard(player);
      },
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1976D2),
          child: Text(
            player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: player.email != null && player.email!.isNotEmpty
          ? Text(
              player.email!,
              style: const TextStyle(color: Colors.white70),
            )
          : null,
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        onTap: () => _loadPlayerStatistics(player),
      ),
    );
  }

  Widget _buildPlayerStatistics() {
    if (_selectedPlayerStats == null) {
      return const Center(
        child: Text(
          'Keine Statistiken verfügbar',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
      );
    }

    final stats = _selectedPlayerStats!;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatCard(
            'Spiele',
            [
              StatItem('Gespielt', stats.totalGames.toString()),
              StatItem('Gewonnen', stats.gamesWon.toString()),
              StatItem('Siegquote', '${stats.winRate.toStringAsFixed(1)}%'),
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Legs',
            [
              StatItem('Gewonnen', stats.totalLegsWon.toString()),
              StatItem('Verloren', stats.totalLegsLost.toString()),
              StatItem('Leg-Quote', '${stats.legWinRate.toStringAsFixed(1)}%'),
            ],
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Würfe',
            [
              StatItem('180er', stats.total180s.toString()),
              StatItem('140+', stats.total140Plus.toString()),
              StatItem('100+', stats.total100Plus.toString()),
            ],
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            'Leistung',
            [
              StatItem('Durchschnitt', stats.overallAverage.toStringAsFixed(2)),
              StatItem('Höchstes Finish', stats.highestCheckout.toString()),
              StatItem('', ''),
            ],
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, List<StatItem> items, Color color) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.where((item) => item.label.isNotEmpty).map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class StatItem {
  final String label;
  final String value;

  StatItem(this.label, this.value);
}