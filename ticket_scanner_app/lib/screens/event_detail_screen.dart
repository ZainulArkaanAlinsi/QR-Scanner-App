import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../providers/ticket_provider.dart';
import '../widgets/error_card.dart';
import '../core/utils/const.dart';

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
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Ticket reserved for ${context.read<EventProvider>().selectedEvent?.name}!', style: const TextStyle(fontWeight: FontWeight.w600))),
          ]),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    
    return Scaffold(
      body: Consumer<EventProvider>(
        builder: (_, ep, __) {
          final event = ep.selectedEvent;
          
          if (ep.isLoading && event == null) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }
          
          if (event == null) {
            return Scaffold(
              appBar: AppBar(leading: const BackButton()),
              body: Center(
                child: ep.error != null
                    ? ErrorCard(message: ep.error!)
                    : const Text('Event not found'),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                backgroundColor: theme.primaryColor,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B), size: 20),
                    onPressed: () => context.go('/home'),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_outlined, color: Color(0xFF1E293B), size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'event-image-${event.id}',
                        child: event.images.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: event.images.first,
                                fit: BoxFit.cover,
                              )
                            : Container(color: theme.primaryColor),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Const.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                      
                      // Info Row
                      Row(
                        children: [
                          _buildInfoItem(Icons.calendar_month, "Date", DateFormat('dd MMM yyyy').format(event.date)),
                          const SizedBox(width: 24),
                          _buildInfoItem(Icons.access_time, "Time", DateFormat('HH:mm').format(event.date)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      const Divider(height: 1),
                      const SizedBox(height: 24),

                      Text('About this event', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        event.desc,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Capacity Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.primaryColor.withValues(alpha: 0.1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.people_outline, color: theme.primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.isFull ? 'Sold Out' : 'Availability',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    event.isFull
                                        ? 'Check back later for openings'
                                        : '${event.availableSlots} slots remaining from ${event.maxReservation}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),

                      // TicketProvider error
                      Consumer<TicketProvider>(
                        builder: (_, tp, __) {
                          if (tp.error == null) return const SizedBox.shrink();
                          return Column(children: [
                            ErrorCard(message: tp.error!, onDismiss: tp.clearError),
                            const SizedBox(height: 16),
                          ]);
                        },
                      ),

                      // Reserve button for attendee
                      if (!auth.isAdmin)
                        Consumer<TicketProvider>(
                          builder: (_, tp, __) => SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: event.isFull || event.isPast ? Colors.grey.shade300 : theme.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: (event.isFull || event.isPast) ? null : _reserve,
                              child: tp.isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.confirmation_num_outlined),
                                        const SizedBox(width: 12),
                                        Text(
                                          event.isFull
                                              ? 'Event is Full'
                                              : event.isPast
                                                  ? 'Event Ended'
                                                  : 'Reserve Ticket Now',
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 40),
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

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
