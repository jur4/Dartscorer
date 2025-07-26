import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'main_menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String errorText = "";

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    
    try {
      final success = await authService.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        setState(() {
          errorText = "";
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainMenuScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorText = "Login fehlgeschlagen";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 36, 48),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 16, 49, 92),
                    Color.fromARGB(255, 24, 73, 138),
                    Color.fromARGB(255, 10, 31, 59),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Image.asset(
                      "assets/images/Flightclub Logo.png",
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.sports_score_rounded,
                          size: 120,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Dart Scorer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 400,
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 28, 36, 48),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 40, top: 40, bottom: 50, right: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (errorText.isNotEmpty) ...[
                          Text(
                            errorText,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                        ],
                        const Text(
                          "Benutzername",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: _usernameController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Benutzername",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(158, 112, 106, 106),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(62, 126, 111, 111),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 73, 149, 201),
                                  width: 2,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(62, 126, 111, 111),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Bitte geben Sie einen Benutzernamen ein';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Passwort",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 50,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Passwort",
                              hintStyle: const TextStyle(
                                color: Color.fromARGB(158, 112, 106, 106),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword 
                                      ? Icons.visibility 
                                      : Icons.visibility_off,
                                  color: const Color.fromARGB(158, 112, 106, 106),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(62, 126, 111, 111),
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 73, 149, 201),
                                  width: 2,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(62, 126, 111, 111),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bitte geben Sie ein Passwort ein';
                              }
                              if (value.length < 6) {
                                return 'Passwort muss mindestens 6 Zeichen lang sein';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleLogin(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Consumer<AuthService>(
                            builder: (context, authService, child) {
                              return GestureDetector(
                                onTap: authService.isLoading ? null : _handleLogin,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  height: 60,
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: authService.isLoading 
                                        ? const Color.fromARGB(255, 30, 60, 85)
                                        : const Color.fromARGB(255, 73, 149, 201),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (authService.isLoading)
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      else
                                        const Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Test-Accounts:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "admin / admin123\ntest / test123\ndartverein / dart2024",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}