import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_theme.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? maxWidth;
  final bool applyGradient;
  final bool centerContent;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.maxWidth,
    this.applyGradient = false,
    this.centerContent = false,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: centerContent ? double.infinity : null,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? ResponsiveUtils.getMaxWidth(context),
      ),
      margin: margin,
      padding: padding ?? ResponsiveUtils.getPagePadding(context),
      decoration: BoxDecoration(
        color: applyGradient ? null : backgroundColor,
        gradient: applyGradient ? AppTheme.primaryGradient : null,
      ),
      child: centerContent ? Center(child: child) : child,
    );
  }
}

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? backgroundColor;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(
        ResponsiveUtils.getSpacing(context, SpacingType.sm),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.backgroundDark,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: elevation != null && elevation! > 0
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: elevation! * 2,
                offset: Offset(0, elevation! / 2),
              ),
            ]
          : null,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(
          ResponsiveUtils.getSpacing(context, SpacingType.md),
        ),
        child: child,
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final EdgeInsets? padding;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? ResponsiveUtils.getPagePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount ?? ResponsiveUtils.getGridColumns(context),
        childAspectRatio: childAspectRatio ?? 1.0,
        crossAxisSpacing: crossAxisSpacing ?? 
          ResponsiveUtils.getSpacing(context, SpacingType.md),
        mainAxisSpacing: mainAxisSpacing ?? 
          ResponsiveUtils.getSpacing(context, SpacingType.md),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}