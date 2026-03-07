import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../models/event_model.dart';
import '../widgets/error_card.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TicketScan',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Text(
              'Hello, ${auth.user?.name ?? ''}!',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          if (auth.isAdmin)
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
              tooltip: 'Scan QR',
              onPressed: () => context.go('/scanner'),
            ),
          if (!auth.isAdmin)
            IconButton(
              icon: const Icon(Icons.confirmation_num_outlined,
                  color: Colors.white),
              tooltip: 'My Tickets',
              onPressed: () => context.go('/my-tickets'),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () async {
              await auth.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
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
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ep.error != null) ...[
                          ErrorCard(message: ep.error!),
                          const SizedBox(height: 12),
                        ],
                        const Text(
                          'Upcoming Events',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ep.events.length} events available',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
                if (ep.events.isEmpty && !ep.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No events yet',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _EventCard(
                          event: ep.events[i],
                          onTap: () => context.go('/event/${ep.events[i].id}'),
                        ),
                        childCount: ep.events.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('EEE, dd MMM yyyy • HH:mm').format(event.date.toLocal());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: event.images.isNotEmpty
                  ? Image.network(
                      event.images.first,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PlaceholderImage(),
                    )
                  : _PlaceholderImage(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(dateStr,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        event.isFull
                            ? 'Full'
                            : '${event.availableSlots} slots left',
                        style: TextStyle(
                          fontSize: 13,
                          color: event.isFull
                              ? Colors.red
                              : const Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      color: const Color(0xFFE8EAF6),
      child: const Icon(Icons.event, size: 60, color: Color(0xFF9FA8DA)),
    );
  }
}
