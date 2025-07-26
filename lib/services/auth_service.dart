import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService extends ChangeNotifier {
  final ApiService _apiService;
  bool _isAuthenticated = false;
  String? _token;
  String? _username;
  bool _isLoading = false;

  AuthService({required ApiService apiService}) : _apiService = apiService {
    _loadAuthState();
  }

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get username => _username;
  bool get isLoading => _isLoading;

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _username = prefs.getString('username');
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Test credentials for development
      if (_isTestCredentials(username, password)) {
        _token = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
        _username = username;
        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setString('username', username);

        _isLoading = false;
        notifyListeners();
        return true;
      }

      // Try actual API login if not test credentials
      final response = await _apiService.login(username, password);
      
      _token = response['token'];
      _username = username;
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('username', username);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  bool _isTestCredentials(String username, String password) {
    // Test credentials for development
    final testCredentials = {
      'admin': 'admin123',
      'test': 'test123',
      'user': 'password',
      'dartverein': 'dart2024',
      'player1': '123456',
      'demo': 'demo123',
    };

    return testCredentials.containsKey(username) && 
           testCredentials[username] == password;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');

    _isAuthenticated = false;
    _token = null;
    _username = null;
    notifyListeners();
  }
}