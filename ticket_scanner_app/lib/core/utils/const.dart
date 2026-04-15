import 'package:flutter/material.dart';
import 'package:ticket_scanner_app/env/env.dart';

class Const {
  // App Info
  static String get appName => "Ticket Scanner";
  static String get appVersion => "1.0.0";

  // API Config (Web/Backend)
  static String get baseUrl => Env.apiUrl.replaceAll('/api', '');
  static String get apiUrl => Env.apiUrl;
  static String get apiKey => Env.apiKey; // Using Envied

  // Storage Keys
  static String get tokenKey => "auth_token";
  static String get userKey => "user_data";

  // UI Constants
  static double get padding => 20.0;
  static double get radius => 16.0;
  static double get cardElevation => 0.0;
  
  // Brand Colors
  static get primaryColor => const Color(0xFF6366F1);
}
