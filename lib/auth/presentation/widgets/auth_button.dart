import 'package:flutter/material.dart';

/// Custom button for authentication screens with agriculture theme
class AuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isOutlined;

  const AuthButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primaryColor = theme.primaryColor;
    final Color buttonColor = backgroundColor ?? primaryColor;
    final Color foregroundColor = textColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52,
      child: isOutlined
          ? _buildOutlinedButton(buttonColor, foregroundColor)
          : _buildElevatedButton(buttonColor, foregroundColor),
    );
  }

  Widget _buildElevatedButton(Color buttonColor, Color foregroundColor) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        elevation: 0,
        disabledBackgroundColor: buttonColor.withOpacity(0.5),
        disabledForegroundColor: foregroundColor.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
      child: isLoading
          ? _buildLoadingIndicator(foregroundColor)
          : _buildButtonContent(foregroundColor),
    );
  }

  Widget _buildOutlinedButton(Color buttonColor, Color foregroundColor) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        side: BorderSide(color: buttonColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      ),
      child: isLoading
          ? _buildLoadingIndicator(buttonColor)
          : _buildButtonContent(buttonColor),
    );
  }

  Widget _buildButtonContent(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(Color color) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(color: color, strokeWidth: 2.5),
    );
  }

  // ============ Factory Constructors ============

  /// Agriculture themed primary button
  factory AuthButton.primary({
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AuthButton(
      onPressed: onPressed,
      isLoading: isLoading,
      text: text,
      icon: icon,
      backgroundColor: const Color(0xFF2E7D32),
      textColor: Colors.white,
    );
  }

  /// Outlined agriculture button
  factory AuthButton.outlined({
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
    IconData? icon,
  }) {
    return AuthButton(
      onPressed: onPressed,
      isLoading: isLoading,
      text: text,
      icon: icon,
      isOutlined: true,
      backgroundColor: const Color(0xFF2E7D32),
    );
  }

  /// Danger/Delete button
  factory AuthButton.danger({
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return AuthButton(
      onPressed: onPressed,
      isLoading: isLoading,
      text: text,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Small button for inline use
  factory AuthButton.small({
    required VoidCallback? onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return AuthButton(
      onPressed: onPressed,
      isLoading: isLoading,
      text: text,
      height: 36,
      borderRadius: 8,
      backgroundColor: const Color(0xFF2E7D32),
      textColor: Colors.white,
    );
  }
}
