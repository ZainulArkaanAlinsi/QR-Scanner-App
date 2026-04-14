import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedCarousel extends StatelessWidget {
  final List<EventModel> events;
  final Function(EventModel) onTap;

  const FeaturedCarousel({
    super.key,
    required this.events,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: events.length > 5 ? 5 : events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () => onTap(event),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image
                    Hero(
                      tag: 'event-image-${event.id}-featured',
                      child: event.images.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: event.images.first,
                              fit: BoxFit.cover,
                            )
                          : Container(color: Theme.of(context).primaryColor),
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),

                    // Text Content
                    Positioned(
                      bottom: 24,
                      left: 24,
                      right: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            event.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event.desc,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
