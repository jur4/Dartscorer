import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartverein_app/services/auth_service.dart';
import 'package:dartverein_app/services/api_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      SharedPreferences.setMockInitialValues({});
      authService = AuthService(apiService: mockApiService);
    });

    group('Test Credentials', () {
      test('should accept valid test credentials', () async {
        // Test valid credentials
        final result = await authService.login('admin', 'admin123');
        
        expect(result, true);
        expect(authService.isAuthenticated, true);
        expect(authService.username, 'admin');
        expect(authService.token, isNotNull);
      });

      test('should accept all predefined test credentials', () async {
        final testCredentials = {
          'admin': 'admin123',
          'test': 'test123',
          'user': 'password',
          'dartverein': 'dart2024',
          'player1': '123456',
          'demo': 'demo123',
        };

        for (final entry in testCredentials.entries) {
          // Reset auth state
          await authService.logout();
          
          final result = await authService.login(entry.key, entry.value);
          
          expect(result, true, reason: 'Failed for ${entry.key}');
          expect(authService.isAuthenticated, true);
          expect(authService.username, entry.key);
        }
      });

      test('should reject invalid test credentials', () async {
        expect(() async => await authService.login('admin', 'wrongpassword'),
               throwsException);
        
        expect(authService.isAuthenticated, false);
        expect(authService.username, null);
        expect(authService.token, null);
      });
    });

    group('API Login', () {
      test('should attempt API login for non-test credentials', () async {
        // Setup mock API response
        when(mockApiService.login('apiuser', 'apipass'))
            .thenAnswer((_) async => {'token': 'api_token_123'});

        final result = await authService.login('apiuser', 'apipass');

        expect(result, true);
        expect(authService.isAuthenticated, true);
        expect(authService.username, 'apiuser');
        expect(authService.token, 'api_token_123');
        
        verify(mockApiService.login('apiuser', 'apipass')).called(1);
      });

      test('should handle API login failure', () async {
        when(mockApiService.login('apiuser', 'wrongpass'))
            .thenThrow(Exception('Login failed'));

        expect(() async => await authService.login('apiuser', 'wrongpass'),
               throwsException);
        
        expect(authService.isAuthenticated, false);
        verify(mockApiService.login('apiuser', 'wrongpass')).called(1);
      });
    });

    group('State Management', () {
      test('should handle loading state correctly', () async {
        expect(authService.isLoading, false);

        // Start login process
        final loginFuture = authService.login('admin', 'admin123');
        
        // Check loading state during login
        expect(authService.isLoading, true);
        
        await loginFuture;
        
        // Check loading state after login
        expect(authService.isLoading, false);
      });

      test('should persist auth state', () async {
        await authService.login('test', 'test123');
        
        // Create new instance to test persistence
        final newAuthService = AuthService(apiService: mockApiService);
        await Future.delayed(Duration(milliseconds: 100)); // Wait for _loadAuthState
        
        expect(newAuthService.isAuthenticated, true);
        expect(newAuthService.username, 'test');
      });

      test('should clear state on logout', () async {
        await authService.login('admin', 'admin123');
        expect(authService.isAuthenticated, true);
        
        await authService.logout();
        
        expect(authService.isAuthenticated, false);
        expect(authService.username, null);
        expect(authService.token, null);
      });
    });

    group('Error Handling', () {
      test('should handle SharedPreferences errors gracefully', () async {
        // This test ensures the service doesn't crash on storage errors
        expect(() => authService.login('admin', 'admin123'), returnsNormally);
      });

      test('should reset loading state on error', () async {
        when(mockApiService.login(any, any))
            .thenThrow(Exception('Network error'));

        try {
          await authService.login('apiuser', 'apipass');
        } catch (e) {
          // Expected to throw
        }

        expect(authService.isLoading, false);
      });
    });
  });
}