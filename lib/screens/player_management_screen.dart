import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../utils/responsive_utils.dart';
import '../models/player.dart';
import '../services/player_service.dart';

class PlayerManagementScreen extends StatefulWidget {
  const PlayerManagementScreen({super.key});

  @override
  State<PlayerManagementScreen> createState() => _PlayerManagementScreenState();
}

class _PlayerManagementScreenState extends State<PlayerManagementScreen> {
  final PlayerService _playerService = PlayerService();
  List<Player> _players = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    print('DEBUG: Starting to load players...');
    setState(() {
      _isLoading = true;
    });

    try {
      print('DEBUG: Calling playerService.getAllPlayers()...');
      final players = await _playerService.getAllPlayers();
      print('DEBUG: Successfully loaded ${players.length} players');
      setState(() {
        _players = players;
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Error loading players: $e');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Fehler beim Laden der Spieler: $e');
    }
  }

  Future<void> _searchPlayers(String query) async {
    if (query.isEmpty) {
      _loadPlayers();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final players = await _playerService.searchPlayers(query);
      setState(() {
        _players = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Fehler bei der Suche: $e');
    }
  }

  void _showAddPlayerDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neuen Spieler hinzufügen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-Mail (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => _addPlayer(nameController.text, emailController.text),
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPlayer(String name, String email) async {
    if (name.trim().isEmpty) {
      _showErrorSnackBar('Name ist erforderlich');
      return;
    }

    Navigator.of(context).pop();


    try {
      print('DEBUG: Creating player with name: ${name.trim()}, email: ${email.trim()}');
      await _playerService.createPlayer(name.trim(), email.trim());
      print('DEBUG: Player created successfully');
      _showSuccessSnackBar('Spieler erfolgreich hinzugefügt');
      _loadPlayers();
    } catch (e) {
      print('DEBUG: Error creating player: $e');
      _showErrorSnackBar('Fehler beim Hinzufügen des Spielers: $e');

    }
  }

  void _showEditPlayerDialog(Player player) {
    final nameController = TextEditingController(text: player.name);
    final emailController = TextEditingController(text: player.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Spieler bearbeiten'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'E-Mail (optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => _updatePlayer(player.id, nameController.text, emailController.text),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  Future<void> _updatePlayer(int id, String name, String email) async {
    if (name.trim().isEmpty) {
      _showErrorSnackBar('Name ist erforderlich');
      return;
    }

    Navigator.of(context).pop();

    try {
      await _playerService.updatePlayer(id, name.trim(), email.trim());
      _showSuccessSnackBar('Spieler erfolgreich aktualisiert');
      _loadPlayers();
    } catch (e) {
      _showErrorSnackBar('Fehler beim Aktualisieren des Spielers: $e');
    }
  }

  Future<void> _deletePlayer(Player player) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Spieler löschen'),
        content: Text('Möchten Sie ${player.name} wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _playerService.deletePlayer(player.id);
        _showSuccessSnackBar('Spieler erfolgreich gelöscht');
        _loadPlayers();
      } catch (e) {
        _showErrorSnackBar('Fehler beim Löschen des Spielers: $e');
      }
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
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
              'Spielerverwaltung',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: ResponsiveUtils.getPagePadding(context),
          child: Column(
            children: [
              _buildSearchAndAddSection(),
              const SizedBox(height: 20),
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : _buildPlayersList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndAddSection() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _searchPlayers(value);
          },
          decoration: InputDecoration(
            labelText: 'Spieler suchen...',
            labelStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Neuen Spieler hinzufügen',
            onPressed: _showAddPlayerDialog,
          ),
        ),
      ],
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => _showEditPlayerDialog(player),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePlayer(player),
            ),
          ],
        ),
      ),
    );
  }
}