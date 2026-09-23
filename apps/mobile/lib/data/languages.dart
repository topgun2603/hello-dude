import 'package:flutter/material.dart';

/// Display data for the launch languages (Language screen design).
class LanguageInfo {
  const LanguageInfo(
    this.code,
    this.native,
    this.english,
    this.greeting,
    this.color,
    this.tint,
  );
  final String code, native, english, greeting;
  final Color color, tint;
}

const languages = [
  LanguageInfo(
    'ta',
    'தமிழ்',
    'Tamil',
    'Vanakkam!',
    Color(0xFF7C3AED),
    Color(0xFFF3EEFF),
  ),
  LanguageInfo(
    'te',
    'తెలుగు',
    'Telugu',
    'Namaskaram!',
    Color(0xFFEA580C),
    Color(0xFFFFF1E6),
  ),
  LanguageInfo(
    'kn',
    'ಕನ್ನಡ',
    'Kannada',
    'Namaskara!',
    Color(0xFF059669),
    Color(0xFFE8F8F1),
  ),
  LanguageInfo(
    'ml',
    'മലയാളം',
    'Malayalam',
    'Namaskaram!',
    Color(0xFF2563EB),
    Color(0xFFEAF1FE),
  ),
  LanguageInfo(
    'hi',
    'हिन्दी',
    'Hindi',
    'Namaste!',
    Color(0xFFE11D48),
    Color(0xFFFDEDEF),
  ),
  LanguageInfo(
    'bn',
    'বাংলা',
    'Bengali',
    'Nomoskar!',
    Color(0xFFD97706),
    Color(0xFFFEF5E4),
  ),
  LanguageInfo(
    'mr',
    'मराठी',
    'Marathi',
    'Namaskar!',
    Color(0xFF9333EA),
    Color(0xFFF5EDFD),
  ),
  LanguageInfo(
    'en',
    'English',
    'English',
    'Hello!',
    Color(0xFF0891B2),
    Color(0xFFE6F6FA),
  ),
];

LanguageInfo languageInfo(String code) =>
    languages.firstWhere((l) => l.code == code, orElse: () => languages.last);

String languageNames(List<String> codes) =>
    codes.map((c) => languageInfo(c).english).join(' · ');
