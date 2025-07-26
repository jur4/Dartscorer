import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../theme/app_theme.dart';

enum ButtonSize { small, medium, large }
enum ButtonType { primary, secondary, danger, success }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonType type;
  final bool isLoading;
  final Widget? icon;
  final double? customWidth;
  final double? customHeight;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.customWidth,
    this.customHeight,
    this.borderRadius,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getButtonColor() {
    switch (widget.type) {
      case ButtonType.primary:
        return AppTheme.primaryBlue;
      case ButtonType.secondary:
        return AppTheme.backgroundDark;
      case ButtonType.danger:
        return Colors.red.shade600;
      case ButtonType.success:
        return Colors.green.shade600;
    }
  }

  Color _getTextColor() {
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.danger:
      case ButtonType.success:
        return Colors.white;
      case ButtonType.secondary:
        return Colors.white;
    }
  }

  double _getButtonHeight(BuildContext context) {
    if (widget.customHeight != null) return widget.customHeight!;
    
    switch (widget.size) {
      case ButtonSize.small:
        return ResponsiveUtils.getButtonHeight(context) * 0.8;
      case ButtonSize.medium:
        return ResponsiveUtils.getButtonHeight(context);
      case ButtonSize.large:
        return ResponsiveUtils.getButtonHeight(context) * 1.3;
    }
  }

  double _getFontSize(BuildContext context) {
    switch (widget.size) {
      case ButtonSize.small:
        return ResponsiveUtils.getFontSize(context, FontSizeType.body);
      case ButtonSize.medium:
        return ResponsiveUtils.getFontSize(context, FontSizeType.subtitle);
      case ButtonSize.large:
        return ResponsiveUtils.getFontSize(context, FontSizeType.title);
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final Color buttonColor = _getButtonColor();
    final Color textColor = _getTextColor();

    return GestureDetector(
      onTap: isDisabled ? null : widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: _getButtonHeight(context),
              width: widget.customWidth,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getSpacing(context, SpacingType.md),
                vertical: ResponsiveUtils.getSpacing(context, SpacingType.sm),
              ),
              decoration: BoxDecoration(
                color: isDisabled
                    ? buttonColor.withOpacity(0.5)
                    : _isPressed
                        ? buttonColor.withOpacity(0.8)
                        : buttonColor,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? 
                  ResponsiveUtils.getSpacing(context, SpacingType.sm),
                ),
                boxShadow: isDisabled 
                  ? [] 
                  : AppTheme.defaultShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    SizedBox(width: ResponsiveUtils.getSpacing(context, SpacingType.sm)),
                  ],
                  if (widget.isLoading)
                    SizedBox(
                      width: _getFontSize(context),
                      height: _getFontSize(context),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  else
                    Flexible(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: _getFontSize(context),
                          color: isDisabled ? textColor.withOpacity(0.5) : textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}