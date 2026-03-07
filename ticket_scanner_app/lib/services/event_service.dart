import '../core/api_client.dart';
import '../models/api_response.dart';
import '../models/event_model.dart';

class EventService {
  /// GET /event — list all events
  static Future<ApiResponse> getEvents() async {
    final res = await ApiClient.get('/event');
    return res;
  }

  /// GET /event/{id} — event detail
  static Future<ApiResponse> getEvent(String eventId) async {
    final res = await ApiClient.get('/event/$eventId');
    return res;
  }

  /// Parse list of events from response data
  static List<EventModel> parseList(dynamic data) {
    if (data == null || data is! List) return [];
    return data
        .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Parse single event from response data
  static EventModel? parseSingle(dynamic data) {
    if (data == null || data is! Map) return null;
    return EventModel.fromJson(data as Map<String, dynamic>);
  }
}
