class ApiResponse {
  final String status;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  bool get isSuccess => status == 'Success';
}
