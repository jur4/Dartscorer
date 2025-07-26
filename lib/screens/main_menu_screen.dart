import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import 'start_screen.dart';
import 'match_type_screen.dart';
import 'player_management_screen.dart';
import 'statistics_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StartScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 52, 70),
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
            child: Column(
              children: [
                Column(
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
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color.fromARGB(255, 73, 149, 201),
                                      Color.fromARGB(255, 73, 149, 201),
                                    ],
                                  ),
                                ),
                                height: screenHeight * 0.25,
                                width: screenWidth * 0.4,
                                child: CustomButton(
                                  borderRadius: 10,
                                  text: "Training",
                                  onPressed: () {
                                    // TODO: Navigate to training
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Training-Modus kommt bald!'),
                                        backgroundColor: Colors.blue,
                                      ),
                                    );
                                  },
                                  type: ButtonType.primary,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color.fromARGB(255, 73, 149, 201),
                                      Color.fromARGB(255, 73, 149, 201),
                                    ],
                                  ),
                                ),
                                height: screenHeight * 0.25,
                                width: screenWidth * 0.4,
                                child: CustomButton(
                                  borderRadius: 10,
                                  text: "Statistiken",
                                  onPressed: () => Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const StatisticsScreen(),
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
                                  type: ButtonType.secondary,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color.fromARGB(255, 73, 149, 201),
                                      Color.fromARGB(255, 73, 149, 201),
                                    ],
                                  ),
                                ),
                                height: screenHeight * 0.25,
                                width: screenWidth * 0.4,
                                child: CustomButton(
                                  borderRadius: 10,
                                  text: "Match",
                                  onPressed: () => Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const MatchTypeScreen(),
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
                              SizedBox(
                                height: screenHeight * 0.05,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      Color.fromARGB(255, 73, 149, 201),
                                      Color.fromARGB(255, 73, 149, 201),
                                    ],
                                  ),
                                ),
                                height: screenHeight * 0.25,
                                width: screenWidth * 0.4,
                                child: CustomButton(
                                  borderRadius: 10,
                                  text: "Spieler verwalten",
                                  onPressed: () => Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>
                                          const PlayerManagementScreen(),
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
                                  type: ButtonType.secondary,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}