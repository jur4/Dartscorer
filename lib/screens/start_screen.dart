import 'package:flutter/material.dart';
import '../components/custom_button.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                  // Title Section
                  Container(
                    padding: EdgeInsets.only(top: ResponsiveUtils.getSpacing(context, SpacingType.xl)),
                    child: Text(
                      "Dart Scorer",
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getFontSize(
                          context, 
                          FontSizeType.display,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: ResponsiveUtils.getSpacing(context, SpacingType.md)),

                  // Logo Section
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: ResponsiveUtils.isMobile(context) 
                            ? 400 
                            : ResponsiveUtils.isTablet(context) 
                              ? 500 
                              : 600,
                          maxWidth: ResponsiveUtils.isMobile(context) 
                            ? 350 
                            : ResponsiveUtils.isTablet(context) 
                              ? 450 
                              : 550,
                        ),
                        child: Image.asset(
                          "assets/images/Flightclub Logo.png",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              constraints: BoxConstraints(
                                maxHeight: ResponsiveUtils.isMobile(context) 
                                  ? 250 
                                  : ResponsiveUtils.isTablet(context) 
                                    ? 350 
                                    : 400,
                                maxWidth: ResponsiveUtils.isMobile(context) 
                                  ? 250 
                                  : ResponsiveUtils.isTablet(context) 
                                    ? 350 
                                    : 400,
                              ),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    ResponsiveUtils.getSpacing(context, SpacingType.lg),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/dartboard.png",
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.sports_score_rounded,
                                          size: ResponsiveUtils.isMobile(context) 
                                            ? 120 
                                            : ResponsiveUtils.isTablet(context) 
                                              ? 160 
                                              : 200,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Button Section
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ResponsiveUtils.isMobile(context) 
                              ? ResponsiveUtils.getScreenWidth(context) * 0.6
                              : ResponsiveUtils.isTablet(context) 
                                ? 400 
                                : 500,
                          ),
                          child: CustomButton(
                            text: "Einloggen",
                            size: ResponsiveUtils.isMobile(context) 
                              ? ButtonSize.medium 
                              : ButtonSize.large,
                            type: ButtonType.primary,
                            icon: Icon(
                              Icons.login,
                              color: Colors.white,
                              size: ResponsiveUtils.getFontSize(
                                context, 
                                FontSizeType.title,
                              ),
                            ),
                            onPressed: () => _navigateToLogin(context),
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtils.getSpacing(
                            context, 
                            SpacingType.lg,
                          ),
                        ),
                        Text(
                          "Version 1.0.0",
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getFontSize(
                              context, 
                              FontSizeType.small,
                            ),
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}