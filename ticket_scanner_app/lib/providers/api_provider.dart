import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ticket_scanner_app/core/utils/const.dart';

class ApiProvider extends GetConnect {
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    httpClient.baseUrl = Const.baseUrl;

    httpClient.addRequestModifier<dynamic>((request) async {
      final token = await _storage.read(key: Const.tokenKey);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['X-API-Key'] = Const.apiKey;
      return request;
    });

    super.onInit();
  }
}
