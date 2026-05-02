import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle getTitleStyle(BuildContext context,
      {double? fontSize, bool isBold = false}) {
    return TextStyle(
      fontSize: fontSize ?? 24,
      fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Amiri',
    );
  }

  static TextStyle getPoetNameStyle(BuildContext context, {double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.primary,
      fontFamily: 'Amiri',
    );
  }

  static TextStyle getPoemContentStyle(
    BuildContext context, {
    double? fontSize,
    bool isBold = false,
    Color? textColor,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      height: 2.0,
      color: textColor ?? Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Amiri',
    );
  }

  static TextStyle getBodyStyle(BuildContext context) {
    return TextStyle(
      fontSize: 14,
      color: Theme.of(context).textTheme.bodySmall?.color,
      fontFamily: 'Amiri',
    );
  }
}
