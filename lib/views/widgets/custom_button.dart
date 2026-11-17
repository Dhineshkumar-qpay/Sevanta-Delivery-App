import 'package:flutter/material.dart';
import 'package:sevanta_delivery_partner/utils/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.height = 48,
    this.borderRadius = 14,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: textColor ?? Colors.white,
                ),
              )
            : Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: textColor ?? Colors.white,
                ),
              ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    super.key,
    required this.onTap,
    required this.child,
    required this.color,
  });

  final VoidCallback onTap;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: ButtonStyle(
        side: WidgetStatePropertyAll(BorderSide(color: color, width: 1.5)),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        ),
        surfaceTintColor: WidgetStatePropertyAll(AppColors.white),
        shadowColor:  WidgetStatePropertyAll(AppColors.white),
        elevation: WidgetStatePropertyAll(2),
        backgroundColor: WidgetStatePropertyAll(AppColors.white),
      ),
      child: child,
    );
  }
}
