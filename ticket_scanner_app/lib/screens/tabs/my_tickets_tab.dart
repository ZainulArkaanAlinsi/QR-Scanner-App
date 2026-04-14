import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../providers/ticket_provider.dart';
import '../../widgets/ticket_tile.dart';
import '../../widgets/error_card.dart';
import '../../models/ticket_model.dart';
import '../../core/utils/const.dart';

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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ticket.event?.name ?? 'Event Ticket',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Show this QR to the event staff',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade100, width: 2),
                ),
                child: QrImageView(
                  data: ticket.code,
                  version: QrVersions.auto,
                  size: 220.0,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Theme.of(context).primaryColor,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ID: #${ticket.id.toUpperCase()}',
                  style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
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
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<TicketProvider>(
          builder: (_, tp, __) {
            final active = tp.myTickets.where((t) => t.isActive).toList();
            final canceled = tp.myTickets.where((t) => t.isCanceled).toList();
            final used = tp.myTickets.where((t) => t.used).toList();

            return RefreshIndicator(
              onRefresh: tp.fetchMyTickets,
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
                              child: Icon(Icons.confirmation_number_outlined, color: theme.primaryColor),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'My Tickets',
                              style: theme.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (tp.error != null) ...[
                        ErrorCard(message: tp.error!, onDismiss: tp.clearError),
                        const SizedBox(height: 16),
                      ],

                      if (tp.isLoading && tp.myTickets.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: CircularProgressIndicator(color: theme.primaryColor),
                          ),
                        )
                      else if (tp.myTickets.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 80),
                              Icon(Icons.confirmation_num_outlined, size: 100, color: Colors.grey.shade100),
                              const SizedBox(height: 20),
                              Text(
                                'No tickets found',
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade400, fontWeight: FontWeight.w600),
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
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          '$title Tickets (${tickets.length})',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: expanded,
        tilePadding: EdgeInsets.zero,
        iconColor: Theme.of(context).primaryColor,
        childrenPadding: const EdgeInsets.only(top: 8),
        children: tickets.map((t) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TicketTile(
            ticket: t,
            backgroundColor: isError 
              ? Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1)
              : (t.used ? Colors.amber.withValues(alpha: 0.05) : null),
            onTap: () => _showQr(t),
          ),
        )).toList(),
      ),
    );
  }
}
