import 'event_model.dart';

class TicketModel {
  final String id;
  final String code;
  final String eventId;
  final String userId;
  final bool isCanceled;
  final DateTime? checkedAt;
  final DateTime? createdAt;
  final EventModel? event;

  TicketModel({
    required this.id,
    required this.code,
    required this.eventId,
    required this.userId,
    required this.isCanceled,
    this.checkedAt,
    this.createdAt,
    this.event,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      eventId: json['event_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      isCanceled: json['is_canceled'] == true,
      checkedAt: json['checked_at'] != null
          ? DateTime.tryParse(json['checked_at'] ?? '')
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      event: json['event'] != null ? EventModel.fromJson(json['event']) : null,
    );
  }

  /// Status label for display
  String get statusLabel {
    if (isCanceled) return 'Canceled';
    if (checkedAt != null) return 'Checked In';
    return 'Active';
  }

  bool get isActive => !isCanceled && checkedAt == null;
  bool get used => checkedAt != null;
}
