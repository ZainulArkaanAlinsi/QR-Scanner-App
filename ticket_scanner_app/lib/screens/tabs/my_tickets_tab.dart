import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/ticket_provider.dart';
import '../../widgets/error_card.dart';
import '../../models/ticket_model.dart';

class MyTicketsTab extends StatefulWidget {
  const MyTicketsTab({super.key});

  @override
  State<MyTicketsTab> createState() => _MyTicketsTabState();
}

class _MyTicketsTabState extends State<MyTicketsTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchMyTickets();
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
          'My Tickets',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Consumer<TicketProvider>(
        builder: (_, tp, __) {
          if (tp.isLoading && tp.myTickets.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)));
          }

          if (tp.error != null && tp.myTickets.isEmpty) {
            return Center(child: ErrorCard(message: tp.error!));
          }

          if (tp.myTickets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_num_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('You have no tickets yet',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF1A237E),
            onRefresh: tp.fetchMyTickets,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tp.myTickets.length,
              itemBuilder: (_, i) => _TicketCard(ticket: tp.myTickets[i]),
            ),
          );
        },
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final dateStr = ticket.createdAt != null
        ? DateFormat('dd MMM yyyy • HH:mm').format(ticket.createdAt!.toLocal())
        : 'Unknown Date';

    Color statusColor;
    if (ticket.isCanceled) {
      statusColor = Colors.red;
    } else if (ticket.checkedAt != null) {
      statusColor = const Color(0xFF2E7D32);
    } else {
      statusColor = const Color(0xFF1A237E);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Status stripe
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TICKET #${ticket.id.substring(0, 8).toUpperCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket.statusLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // In a real app we'd fetch event name. For now using ID
                    Text(
                      'Event ID: ${ticket.eventId}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          'Reserved: $dateStr',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Ticket stub area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        color: Colors.grey.shade200,
                        width: 1,
                        style: BorderStyle.solid)),
              ),
              child:
                  const Icon(Icons.qr_code, color: Color(0xFF1A237E), size: 32),
            ),
          ],
        ),
      ),
    );
  }
}
