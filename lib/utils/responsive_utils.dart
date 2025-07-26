import 'package:flutter/material.dart';

class ResponsiveUtils {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static EdgeInsets getPagePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) {
      return 48.0;
    } else if (isTablet(context)) {
      return 56.0;
    } else {
      return 64.0;
    }
  }

  static double getFontSize(BuildContext context, FontSizeType type) {
    final multiplier = isMobile(context) ? 1.0 : isTablet(context) ? 1.1 : 1.2;
    
    switch (type) {
      case FontSizeType.small:
        return 12.0 * multiplier;
      case FontSizeType.body:
        return 16.0 * multiplier;
      case FontSizeType.subtitle:
        return 20.0 * multiplier;
      case FontSizeType.title:
        return 24.0 * multiplier;
      case FontSizeType.headline:
        return 32.0 * multiplier;
      case FontSizeType.display:
        return 48.0 * multiplier;
    }
  }

  static double getSpacing(BuildContext context, SpacingType type) {
    final multiplier = isMobile(context) ? 1.0 : isTablet(context) ? 1.2 : 1.4;
    
    switch (type) {
      case SpacingType.xs:
        return 4.0 * multiplier;
      case SpacingType.sm:
        return 8.0 * multiplier;
      case SpacingType.md:
        return 16.0 * multiplier;
      case SpacingType.lg:
        return 24.0 * multiplier;
      case SpacingType.xl:
        return 32.0 * multiplier;
      case SpacingType.xxl:
        return 48.0 * multiplier;
    }
  }

  static int getGridColumns(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  static double getMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 600;
    } else {
      return 800;
    }
  }
}

enum FontSizeType {
  small,
  body,
  subtitle,
  title,
  headline,
  display,
}

enum SpacingType {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
}