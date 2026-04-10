import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/event_provider.dart';
import 'package:intl/intl.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        title: const Text(
          'Event Management',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/events/create'),
        backgroundColor: const Color(0xFF1A237E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Consumer<EventProvider>(
        builder: (_, ep, __) {
          if (ep.isLoading && ep.events.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)));
          }

          return RefreshIndicator(
            color: const Color(0xFF1A237E),
            onRefresh: ep.fetchEvents,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: ep.events.length,
              itemBuilder: (_, i) {
                final event = ep.events[i];
                final dateStr = DateFormat('dd/MM/yyyy').format(event.date);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EAF6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event, color: Color(0xFF1A237E)),
                    ),
                    title: Text(
                      event.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$dateStr • ${event.maxReservation} slots'),
                        const SizedBox(height: 4),
                        Text(
                          '${event.availableSlots} remaining',
                          style: TextStyle(
                            color: event.isFull ? Colors.red : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context
                          .read<EventProvider>()
                          .clearSelectedEvent(); // ensure clean state
                      ep.fetchEvent(event.id); // Load full detail for edit
                      context.push('/events/edit/${event.id}');
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
