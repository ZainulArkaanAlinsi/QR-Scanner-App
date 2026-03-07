class TicketModel {
  final String id;
  final String code;
  final String eventId;
  final String userId;
  final bool isCanceled;
  final DateTime? checkInAt;
  final DateTime? createdAt;

  TicketModel({
    required this.id,
    required this.code,
    required this.eventId,
    required this.userId,
    required this.isCanceled,
    this.checkInAt,
    this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id']?.toString() ?? '',
      code: json['code'] ?? '',
      eventId: json['event_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      isCanceled: json['is_canceled'] == true,
      checkInAt: json['check_in_at'] != null
          ? DateTime.tryParse(json['check_in_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  /// Status label for display
  String get statusLabel {
    if (isCanceled) return 'Canceled';
    if (checkInAt != null) return 'Checked In';
    return 'Active';
  }

  bool get isActive => !isCanceled && checkInAt == null;
}
