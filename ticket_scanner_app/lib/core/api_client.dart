import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/api_response.dart';

class ApiClient {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kTokenKey);
  }

  static Map<String, String> _buildHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<ApiResponse> get(String endpoint) async {
    final token = await _getToken();
    try {
      final res = await http.get(
        Uri.parse('$kBaseUrl$endpoint'),
        headers: _buildHeaders(token: token),
      );
      return _parse(res);
    } catch (e) {
      return ApiResponse(
        status: 'Error',
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  static Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    try {
      final res = await http.post(
        Uri.parse('$kBaseUrl$endpoint'),
        headers: _buildHeaders(token: token),
        body: body != null ? jsonEncode(body) : null,
      );
      return _parse(res);
    } catch (e) {
      return ApiResponse(
        status: 'Error',
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  static Future<ApiResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    try {
      final res = await http.patch(
        Uri.parse('$kBaseUrl$endpoint'),
        headers: _buildHeaders(token: token),
        body: body != null ? jsonEncode(body) : null,
      );
      return _parse(res);
    } catch (e) {
      return ApiResponse(
        status: 'Error',
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  static Future<ApiResponse> delete(String endpoint) async {
    final token = await _getToken();
    try {
      final res = await http.delete(
        Uri.parse('$kBaseUrl$endpoint'),
        headers: _buildHeaders(token: token),
      );
      return _parse(res);
    } catch (e) {
      return ApiResponse(
        status: 'Error',
        message: 'Network error: ${e.toString()}',
        data: null,
      );
    }
  }

  static ApiResponse _parse(http.Response res) {
    try {
      final json = jsonDecode(res.body);
      return ApiResponse(
        status: json['status'] ?? 'Error',
        message: json['message'] ?? 'Unknown error',
        data: json['data'],
      );
    } catch (_) {
      return ApiResponse(
        status: 'Error',
        message: 'Failed to parse response (${res.statusCode})',
        data: null,
      );
    }
  }
}
