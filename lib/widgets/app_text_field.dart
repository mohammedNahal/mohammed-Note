import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.isBorder = true,
    this.validator,
  });

  final TextEditingController controller;
  final String? hint;
  final double? borderRadius;
  final IconData? prefix;
  final Widget? suffix;
  final bool obscureText;
  final bool isBorder;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: isBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 7),
          borderSide: BorderSide(color: Colors.teal.shade500, width: 1.2),
        ) : OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: isBorder ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 7),
          borderSide: BorderSide(color: Colors.teal.shade500, width: 1.2),
        ) : OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix,
      ),
      cursorColor: Colors.teal.shade500,
      cursorOpacityAnimates: true,
      cursorWidth: 3,
      cursorHeight: 15,
      smartDashesType: SmartDashesType.enabled,
      smartQuotesType: SmartQuotesType.enabled,
      obscureText: obscureText,
      validator:validator,
    );
  }
}