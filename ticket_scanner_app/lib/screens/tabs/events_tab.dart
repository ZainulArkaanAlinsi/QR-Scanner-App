import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../widgets/error_card.dart';
import '../../core/utils/const.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      setState(() => _query = _searchCtrl.text.toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/events/create'),
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
      ),
      body: SafeArea(
        child: Consumer<EventProvider>(
          builder: (_, ep, __) {
            final filteredEvents = ep.events.where((e) {
              return e.name.toLowerCase().contains(_query);
            }).toList();

            return RefreshIndicator(
              onRefresh: ep.fetchEvents,
              color: theme.primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(Const.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.campaign_outlined, color: theme.primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Manage Events',
                              style: theme.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Const.radius),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            hintText: 'Search managed events...',
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 20),
                                    onPressed: () => _searchCtrl.clear(),
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (ep.error != null) ...[
                        ErrorCard(message: ep.error!, onDismiss: ep.clearError),
                        const SizedBox(height: 16),
                      ],

                      if (ep.isLoading && ep.events.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: CircularProgressIndicator(color: theme.primaryColor),
                          ),
                        )
                      else if (filteredEvents.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              Icon(Icons.event_note_outlined, size: 100, color: Colors.grey.shade100),
                              const SizedBox(height: 20),
                              Text(
                                'No events found',
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredEvents.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return _buildManagementTile(context, event);
                          },
                        ),
                      const SizedBox(height: 80), // Space for FAB
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildManagementTile(BuildContext context, dynamic event) {
    final theme = Theme.of(context);
    final dateStr = DateFormat('dd MMM yyyy').format(event.date);
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(12),
        onTap: () => context.push('/events/edit/${event.id}'),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.event_available_outlined, color: theme.primaryColor),
        ),
        title: Text(
          event.name,
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('$dateStr • ${event.maxReservation} Total Slots', style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: event.isFull ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${event.availableSlots} available',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: event.isFull ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.edit_outlined, size: 20, color: Colors.grey.shade400),
      ),
    );
  }
}
