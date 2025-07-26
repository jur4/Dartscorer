import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import 'match_x01_settings_screen.dart';

class MatchTypeScreen extends StatelessWidget {
  const MatchTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 28, 36, 48),
        body: SafeArea(
          child: Container(
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
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.3,
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
                  Container(
                    width: screenWidth * 1,
                    height: screenHeight * 0.12,
                    child: CustomButton(
                      borderRadius: 0,
                      text: "X01",
                      onPressed: () => Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              const MatchX01SettingsScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                      type: ButtonType.primary,
                    ),
                  ),
                  Container(
                    width: screenWidth * 1,
                    height: screenHeight * 0.12,
                    child: CustomButton(
                      borderRadius: 0,
                      text: "Cricket",
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cricket-Modus kommt bald!'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      type: ButtonType.secondary,
                    ),
                  ),
                  Container(
                    width: screenWidth * 1,
                    height: screenHeight * 0.12,
                    child: CustomButton(
                      borderRadius: 0,
                      text: "Bob's 27",
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Bob's 27 kommt bald!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      type: ButtonType.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}