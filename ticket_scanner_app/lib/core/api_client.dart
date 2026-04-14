import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/api_response.dart';
import '../env/env.dart';

class ApiClient {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(kTokenKey);
  }

  static Map<String, String> _buildHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-API-Key': Env.apiKey,
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

  static Future<ApiResponse> postMultipart(
    String endpoint, {
    Map<String, String>? body,
    List<http.MultipartFile>? files,
  }) async {
    final token = await _getToken();
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$kBaseUrl$endpoint'),
      );

      request.headers.addAll(_buildHeaders(token: token));
      // MultipartRequest headers usually shouldn't have Content-Type set manually
      request.headers.remove('Content-Type');

      if (body != null) request.fields.addAll(body);
      if (files != null) request.files.addAll(files);

      final streamedRes = await request.send();
      final res = await http.Response.fromStream(streamedRes);
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
