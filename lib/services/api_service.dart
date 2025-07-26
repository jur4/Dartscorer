import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8081/api';
  
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Login fehlgeschlagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Verbindungsfehler: $e');
    }
  }

  Future<Map<String, dynamic>> register(String username, String password, String email) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Registrierung fehlgeschlagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Verbindungsfehler: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}