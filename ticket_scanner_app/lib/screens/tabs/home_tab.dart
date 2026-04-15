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
    return Scaffold(
      body: SafeArea(
        child: Consumer<EventProvider>(
          builder: (_, ep, __) {
            final filteredEvents = ep.events.where((e) {
              return e.name.toLowerCase().contains(_query) ||
                  e.desc.toLowerCase().contains(_query);
            }).toList();

            return RefreshIndicator(
              onRefresh: ep.fetchEvents,
              color: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Bar (Role-Based)
                    Padding(
                      padding: EdgeInsets.fromLTRB(Const.padding, 16, Const.padding, 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.watch<AuthProvider>().isAdmin 
                                  ? 'System Dashboard' 
                                  : 'Explore Events',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.watch<AuthProvider>().isAdmin
                                  ? "Global event management and monitoring"
                                  : "Find the best experiences around you",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          context.watch<AuthProvider>().isAdmin 
                            ? Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.security, color: Theme.of(context).primaryColor, size: 22),
                              )
                            : _buildWishlistBadge(ep.bookmarkedIds.length),
                        ],
                      ),
                    ),

                    // Featured Carousel (only if no active search)
                    if (_query.isEmpty && ep.events.isNotEmpty) ...[
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
                                hintText: 'Search events...',
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _query.isEmpty ? 'Trending Now' : 'Search Results',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (_query.isEmpty)
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('See All'),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          if (ep.isLoading && ep.events.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                              ),
                            )
                          else if (filteredEvents.isEmpty)
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  Icon(Icons.search_off, size: 80, color: Colors.grey.shade200),
                                  const SizedBox(height: 16),
                                  Text(
                                    _query.isEmpty ? 'No events available' : 'No matches for "$_query"',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }

  Widget _buildWishlistBadge(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Icon(Icons.favorite_border, color: Theme.of(context).primaryColor, size: 22),
        ),
        if (count > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Center(
                child: Text(
                  count.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
