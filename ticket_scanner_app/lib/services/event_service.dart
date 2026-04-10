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

  /// POST /event — create event (admin)
  static Future<ApiResponse> storeEvent(Map<String, dynamic> data) async {
    return await ApiClient.post('/event', body: data);
  }

  /// POST /event/{id} — update event (admin)
  static Future<ApiResponse> updateEvent(
      String eventId, Map<String, dynamic> data) async {
    return await ApiClient.post('/event/$eventId', body: data);
  }

  /// DELETE /event/{id} — delete event (admin)
  static Future<ApiResponse> deleteEvent(String eventId) async {
    return await ApiClient.delete('/event/$eventId');
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
