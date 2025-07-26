import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/start_screen.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DartvereinApp());
}

class DartvereinApp extends StatelessWidget {
  const DartvereinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(
            apiService: context.read<ApiService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Dartverein - Professionelles Dart-Scoring',
        theme: AppTheme.darkTheme,
        home: const StartScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}