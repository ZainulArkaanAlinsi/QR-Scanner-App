import '../core/api_client.dart';
import '../models/api_response.dart';
import '../models/ticket_model.dart';

class TicketService {
  /// POST /event/{eventId}/reserve — reserve a ticket (attendee)
  static Future<ApiResponse> reserveTicket(String eventId) async {
    return await ApiClient.post('/event/$eventId/reserve');
  }

  /// GET /my-tickets — list my tickets (attendee)
  static Future<ApiResponse> getMyTickets() async {
    return await ApiClient.get('/my-tickets');
  }

  /// PATCH /ticket/{ticketId}/cancel — cancel ticket (attendee)
  static Future<ApiResponse> cancelTicket(String ticketId) async {
    return await ApiClient.patch('/ticket/$ticketId/cancel');
  }

  /// PATCH /checkin — check in by QR code (admin)
  /// [code] = the full QR code string scanned from camera
  static Future<ApiResponse> checkinTicket(String code) async {
    return await ApiClient.patch(
      '/checkin',
      body: {'code': code},
    );
  }

  /// GET /event/{eventId}/ticket — list tickets for an event (admin)
  static Future<ApiResponse> getTicketsByEvent(String eventId) async {
    return await ApiClient.get('/event/$eventId/ticket');
  }

  /// Parse list of tickets from response data
  static List<TicketModel> parseList(dynamic data) {
    if (data == null || data is! List) return [];
    return data
        .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Parse single ticket from response data
  static TicketModel? parseSingle(dynamic data) {
    if (data == null || data is! Map) return null;
    return TicketModel.fromJson(data as Map<String, dynamic>);
  }
}
