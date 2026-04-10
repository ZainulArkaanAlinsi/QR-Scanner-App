import 'package:ticket_scanner_app/env/env.dart';

class Const {
  // App Info
  static String get appName => "Ticket Scanner";
  static String get appVersion => "1.0.0";

  // API Config (Web/Backend)
  static String get baseUrl => "http://ticket-scanner.com";
  static String get apiUrl => "$baseUrl/api";
  static String get apiKey => Env.apiKey; // Using Envied

  // Storage Keys
  static String get tokenKey => "auth_token";
  static String get userKey => "user_data";
}
