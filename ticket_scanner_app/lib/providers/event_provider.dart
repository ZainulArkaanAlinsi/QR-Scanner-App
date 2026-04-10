import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';

class EventProvider extends ChangeNotifier {
  List<EventModel> _events = [];
  EventModel? _selectedEvent;
  bool _isLoading = false;
  String? _error;

  List<EventModel> get events => _events;
  EventModel? get selectedEvent => _selectedEvent;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents() async {
    _setLoading(true);
    _error = null;

    final res = await EventService.getEvents();
    if (res.isSuccess) {
      _events = EventService.parseList(res.data);
    } else {
      _error = res.message;
    }
    _setLoading(false);
  }

  Future<void> fetchEvent(String eventId) async {
    _setLoading(true);
    _error = null;

    final res = await EventService.getEvent(eventId);
    if (res.isSuccess) {
      _selectedEvent = EventService.parseSingle(res.data);
    } else {
      _error = res.message;
    }
    _setLoading(false);
  }

  Future<bool> createEvent(Map<String, dynamic> data) async {
    _setLoading(true);
    _error = null;

    final res = await EventService.storeEvent(data);
    if (res.isSuccess) {
      await fetchEvents(); // Refresh list
      _setLoading(false);
      return true;
    } else {
      _error = res.message;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateEvent(String eventId, Map<String, dynamic> data) async {
    _setLoading(true);
    _error = null;

    final res = await EventService.updateEvent(eventId, data);
    if (res.isSuccess) {
      await fetchEvents(); // Refresh list
      _setLoading(false);
      return true;
    } else {
      _error = res.message;
      _setLoading(false);
      return false;
    }
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
