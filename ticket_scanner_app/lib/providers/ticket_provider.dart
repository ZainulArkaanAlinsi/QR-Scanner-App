import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';

class TicketProvider extends ChangeNotifier {
  List<TicketModel> _myTickets = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;
  // QR Checkin result
  String? _checkinMessage;
  bool _checkinSuccess = false;
  TicketModel? _checkinTicket;

  List<TicketModel> get myTickets => _myTickets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  String? get checkinMessage => _checkinMessage;
  bool get checkinSuccess => _checkinSuccess;
  TicketModel? get checkinTicket => _checkinTicket;

  Future<void> fetchMyTickets() async {
    _setLoading(true);
    _error = null;

    final res = await TicketService.getMyTickets();
    if (res.isSuccess) {
      _myTickets = TicketService.parseList(res.data);
    } else {
      _error = res.message;
    }
    _setLoading(false);
  }

  Future<bool> reserveTicket(String eventId) async {
    _setLoading(true);
    _error = null;
    _successMessage = null;

    final res = await TicketService.reserveTicket(eventId);
    if (res.isSuccess) {
      _successMessage = res.message;
      _setLoading(false);
      return true;
    } else {
      _error = res.message;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> cancelTicket(String ticketId) async {
    _setLoading(true);
    _error = null;

    final res = await TicketService.cancelTicket(ticketId);
    if (res.isSuccess) {
      // Update local list
      final idx = _myTickets.indexWhere((t) => t.id == ticketId);
      if (idx >= 0) {
        final updated = TicketService.parseSingle(res.data);
        if (updated != null) _myTickets[idx] = updated;
      }
      _setLoading(false);
      return true;
    } else {
      _error = res.message;
      _setLoading(false);
      return false;
    }
  }

  /// Checkin via QR scan (admin).
  /// [code] = full raw QR code string from scanner
  /// The code format is: ikutan-{uniqid}-{base64payload}
  /// We need to find the ticket ID first — the code itself is used as lookup key
  Future<void> checkinByCode(String code) async {
    _setLoading(true);
    _checkinMessage = null;

    // The API looks up ticket by 'code' field, so we pass a placeholder ticketId
    // and send code in body. We use the code as the route param workaround.
    // Actually the API: PATCH /ticket/{ticketId}/checkin  + body {code: ...}
    // We need a ticketId — but the API actually looks up ticket by code from body.
    // Looking at the controller: $ticket = Ticket::where('code', $code)->first()
    // So any ticketId works as long as we send the code. We use '0' as placeholder.
    final res = await TicketService.checkinTicket(code);

    _checkinSuccess = res.isSuccess;
    _checkinMessage = res.message;
    if (res.isSuccess && res.data != null) {
      try {
        _checkinTicket = TicketService.parseSingle(res.data);
      } catch (_) {}
    }
    _setLoading(false);
  }

  void resetCheckin() {
    _checkinMessage = null;
    _checkinSuccess = false;
    _checkinTicket = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
