import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/event_tile.dart';
import '../../widgets/error_card.dart';
import '../../widgets/featured_carousel.dart';
import '../../core/utils/const.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withValues(alpha: 0.05),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<EventProvider>(
            builder: (_, ep, __) {
              final filteredEvents = ep.events.where((e) {
                return e.name.toLowerCase().contains(_query) ||
                    e.desc.toLowerCase().contains(_query);
              }).toList();

              return RefreshIndicator(
                onRefresh: ep.fetchEvents,
                color: theme.primaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Bar with gradient background
                      Container(
                        padding: EdgeInsets.fromLTRB(Const.padding, 16, Const.padding, 24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.primaryColor,
                              theme.primaryColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.watch<AuthProvider>().isAdmin 
                                        ? 'Dashboard' 
                                        : 'Hello, Traveler!',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      context.watch<AuthProvider>().isAdmin
                                        ? 'Event Management' 
                                        : 'Discover Amazing Events',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: context.watch<AuthProvider>().isAdmin 
                                    ? const Icon(Icons.admin_panel_settings, color: Colors.white, size: 22)
                                    : Icon(Icons.favorite_border, color: Colors.white, size: 22),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Search Bar
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _searchCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Search events...',
                                  hintStyle: TextStyle(color: Colors.grey.shade400),
                                  prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                                  suffixIcon: _query.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear, size: 20),
                                          onPressed: () => _searchCtrl.clear(),
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Featured Carousel (only if no active search)
                      if (_query.isEmpty && ep.events.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Icon(Icons.auto_awesome, color: theme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Featured Events',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        FeaturedCarousel(
                          events: ep.events,
                          onTap: (event) => context.push('/event/${event.id}'),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: Const.padding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (ep.error != null) ...[
                              ErrorCard(message: ep.error!, onDismiss: ep.clearError),
                              const SizedBox(height: 16),
                            ],

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _query.isEmpty ? 'All Events' : 'Search Results',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${filteredEvents.length} events',
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            if (ep.isLoading && ep.events.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(color: theme.primaryColor),
                                      const SizedBox(height: 16),
                                      Text('Loading events...', style: TextStyle(color: Colors.grey.shade400)),
                                    ],
                                  ),
                                ),
                              )
                            else if (filteredEvents.isEmpty)
                              Center(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 60),
                                    Container(
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.search_off, size: 60, color: Colors.grey.shade200),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _query.isEmpty ? 'No events available' : 'No matches for "$_query"',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                  return EventTile(
                                    event: event,
                                    onTap: () => context.push('/event/${event.id}'),
                                  );
                                },
                              ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
