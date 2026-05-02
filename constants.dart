import 'package:flutter/material.dart';

class AppConstants {
  // ألوان التطبيق
  static const Color primaryColor = Color(0xFF1A237E);
  static const Color secondaryColor = Color(0xFFC62828);
  static const Color accentColor = Color(0xFF2E7D32);
  static const Color backgroundColor = Color(0xFFF5F0E8);

  // أحجام النصوص الافتراضية
  static const double defaultFontSize = 18.0;
  static const double minFontSize = 14.0;
  static const double maxFontSize = 36.0;

  // ألوان الخلفيات
  static const Map<String, Color> backgroundColors = {
    'default': Colors.transparent,
    'white': Colors.white,
    'light_yellow': Color(0xFFFFF9C4),
    'light_green': Color(0xFFC8E6C9),
    'light_blue': Color(0xFFBBDEFB),
    'light_grey': Color(0xFFE0E0E0),
    'dark': Color(0xFF424242),
  };

  // روابط التواصل
  static const String email = 'contact@diwanpoems.com';
  static const String website = 'www.diwanpoems.com';
  static const String facebook = 'https://www.facebook.com/diwanpoems';
  static const String instagram = 'https://www.instagram.com/diwanpoems';
  static const String whatsapp = 'https://wa.me/1234567890';

  // إصدار التطبيق
  static const String appVersion = '1.0.0';
  static const String appName = 'ديوان القصائد';
}
