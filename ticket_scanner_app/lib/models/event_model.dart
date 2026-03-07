class EventModel {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final List<String> images;
  final int maxReservation;
  final int? ticketsCountCount; // from withCount

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.images,
    required this.maxReservation,
    this.ticketsCountCount,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<String> imgs = [];
    if (json['images'] != null) {
      if (json['images'] is List) {
        imgs = (json['images'] as List).map((e) => e.toString()).toList();
      }
    }
    return EventModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      images: imgs,
      maxReservation: json['max_reservation'] ?? 0,
      ticketsCountCount: json['tickets_count_count'],
    );
  }

  int get availableSlots {
    if (ticketsCountCount == null) return maxReservation;
    return maxReservation - ticketsCountCount!;
  }

  bool get isFull => availableSlots <= 0;
  bool get isPast => date.isBefore(DateTime.now());
}
