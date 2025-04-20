import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  AppButton({
    required this.onTap,
    required this.child,
    this.width = double.infinity,
    this.height = 50,
    required this.borderRadius,
    this.backgroundColor,
    this.childColor,
    this.elevation,
    super.key,
  });
  void Function()? onTap;

  Widget child;

  double width, height;

  double borderRadius;

  Color? backgroundColor;

  Color? childColor;

  double? elevation;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,

      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),

        backgroundColor: backgroundColor ?? Colors.black,

        foregroundColor: childColor ?? Colors.white,

        elevation: elevation ?? 5,
      ),
      child: child,
    );
  }
}
