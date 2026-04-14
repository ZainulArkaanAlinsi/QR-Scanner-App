import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/ticket_provider.dart';
import '../../widgets/ticket_tile.dart';
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

  void _showQr(TicketModel ticket) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ticket.event?.name ?? 'Event Ticket',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Show this QR to the event staff',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: QrImageView(
                  data: ticket.code,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '#${ticket.id.toUpperCase()}',
                style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TicketProvider>(
          builder: (_, tp, __) {
            final active = tp.myTickets.where((t) => t.isActive).toList();
            final canceled = tp.myTickets.where((t) => t.isCanceled).toList();
            final used = tp.myTickets.where((t) => t.used).toList();

            return RefreshIndicator(
              onRefresh: tp.fetchMyTickets,
              color: Colors.indigo,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.confirmation_number, color: Colors.indigo),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'My tickets',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1F2937),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      if (tp.error != null) ...[
                        ErrorCard(message: tp.error!, onDismiss: tp.clearError),
                        const SizedBox(height: 16),
                      ],

                      if (tp.isLoading && tp.myTickets.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(color: Colors.indigo),
                          ),
                        )
                      else if (tp.myTickets.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 60),
                              Icon(Icons.confirmation_num_outlined, size: 80, color: Colors.grey.shade200),
                              const SizedBox(height: 16),
                              Text(
                                'No tickets found',
                                style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      else ...[
                        _buildSection(context, 'Active', active, true),
                        const SizedBox(height: 16),
                        _buildSection(context, 'Used', used, false),
                        const SizedBox(height: 16),
                        _buildSection(context, 'Canceled', canceled, false, isError: true),
                      ],
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

  Widget _buildSection(BuildContext context, String title, List<TicketModel> tickets, bool expanded, {bool isError = false}) {
    if (tickets.isEmpty) return const SizedBox.shrink();
    return ExpansionTile(
      title: Text(
        '$title Tickets (${tickets.length})',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      initiallyExpanded: expanded,
      shape: const RoundedRectangleBorder(side: BorderSide.none),
      childrenPadding: const EdgeInsets.only(top: 8),
      children: tickets.map((t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TicketTile(
          ticket: t,
          backgroundColor: isError 
            ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.2)
            : (t.used ? Colors.amber.withValues(alpha: 0.1) : null),
          onTap: () => _showQr(t),
        ),
      )).toList(),
    );
  }
}
