import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../providers/ticket_provider.dart';
import '../widgets/loading_button.dart';
import '../widgets/error_card.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvent(widget.eventId);
      context.read<TicketProvider>().clearError();
    });
  }

  Future<void> _reserve() async {
    final tp = context.read<TicketProvider>();
    final ok = await tp.reserveTicket(widget.eventId);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Ticket reserved successfully!'),
          ]),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Consumer<EventProvider>(
        builder: (_, ep, __) {
          final event = ep.selectedEvent;
          if (ep.isLoading && event == null) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)));
          }
          if (event == null) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color(0xFF1A237E),
                  leading: const BackButton(color: Colors.white)),
              body: Center(
                child: ep.error != null
                    ? ErrorCard(message: ep.error!)
                    : const Text('Event not found'),
              ),
            );
          }

          final dateStr = DateFormat('EEEE, dd MMMM yyyy • HH:mm')
              .format(event.date.toLocal());

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: const Color(0xFF1A237E),
                leading: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => context.go('/home'),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  background: event.images.isNotEmpty
                      ? Image.network(
                          event.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const ColoredBox(color: Color(0xFF1A237E)),
                        )
                      : const ColoredBox(
                          color: Color(0xFF283593),
                          child: Icon(Icons.event,
                              size: 100, color: Color(0xFF9FA8DA)),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Info chips
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _InfoChip(icon: Icons.calendar_today, label: dateStr),
                          _InfoChip(
                            icon: Icons.people,
                            label: event.isFull
                                ? 'Full (${event.maxReservation})'
                                : '${event.availableSlots} / ${event.maxReservation} slots left',
                            color: event.isFull
                                ? Colors.red
                                : const Color(0xFF2E7D32),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'About this event',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.desc,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.6),
                      ),
                      const SizedBox(height: 24),

                      // TicketProvider error
                      Consumer<TicketProvider>(
                        builder: (_, tp, __) {
                          if (tp.error == null) return const SizedBox.shrink();
                          return Column(children: [
                            ErrorCard(
                                message: tp.error!, onDismiss: tp.clearError),
                            const SizedBox(height: 16),
                          ]);
                        },
                      ),

                      // Reserve button for attendee
                      if (!auth.isAdmin)
                        Consumer<TicketProvider>(
                          builder: (_, tp, __) => LoadingButton(
                            label: event.isFull
                                ? 'Event is Full'
                                : event.isPast
                                    ? 'Event Ended'
                                    : 'Reserve Ticket',
                            isLoading: tp.isLoading,
                            onPressed: (event.isFull || event.isPast)
                                ? null
                                : _reserve,
                            icon: Icons.confirmation_num_outlined,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF1A237E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label,
                style: TextStyle(
                    fontSize: 12, color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
