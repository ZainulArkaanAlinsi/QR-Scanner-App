import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/ticket_provider.dart';
import '../widgets/status_badge.dart';
import '../widgets/error_card.dart';
import '../models/ticket_model.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TicketProvider>().fetchMyTickets();
    });
  }

  Future<void> _cancel(TicketModel ticket) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancel Ticket'),
        content: const Text('Are you sure you want to cancel this ticket?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      final ok = await context.read<TicketProvider>().cancelTicket(ticket.id);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Ticket canceled.'),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        context.read<TicketProvider>().fetchMyTickets();
      }
    }
  }

  void _showQr(BuildContext context, TicketModel ticket) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text(
              'Your QR Code',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor),
            ),
            const SizedBox(height: 6),
            Text(
              'Show this to the event organizer',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            QrImageView(
              data: ticket.code,
              version: QrVersions.auto,
              size: 220,
              eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square, color: theme.primaryColor),
              dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: theme.primaryColor),
            ),
            const SizedBox(height: 16),
            StatusBadge(status: ticket.statusLabel),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: const Text('My Tickets',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Consumer<TicketProvider>(
        builder: (_, tp, __) {
          if (tp.isLoading && tp.myTickets.isEmpty) {
            return Center(
                child: CircularProgressIndicator(color: theme.primaryColor));
          }
          return RefreshIndicator(
            color: theme.primaryColor,
            onRefresh: tp.fetchMyTickets,
            child: CustomScrollView(
              slivers: [
                if (tp.error != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ErrorCard(message: tp.error!),
                    ),
                  ),
                if (tp.myTickets.isEmpty && !tp.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.confirmation_num_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No tickets yet',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _TicketCard(
                          ticket: tp.myTickets[i],
                          onCancel: () => _cancel(tp.myTickets[i]),
                          onShowQr: () => _showQr(context, tp.myTickets[i]),
                        ),
                        childCount: tp.myTickets.length,
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

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback onCancel;
  final VoidCallback onShowQr;

  const _TicketCard({
    required this.ticket,
    required this.onCancel,
    required this.onShowQr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Colored left strip
          Container(
            width: 6,
            height: 100,
            decoration: BoxDecoration(
              color: ticket.isActive
                  ? theme.primaryColor
                  : ticket.isCanceled
                      ? Colors.red.shade300
                      : Colors.blue.shade400,
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusBadge(status: ticket.statusLabel),
                      const Spacer(),
                      if (ticket.isActive)
                        TextButton.icon(
                          onPressed: onShowQr,
                          icon: const Icon(Icons.qr_code, size: 16),
                          label: const Text('QR'),
                          style: TextButton.styleFrom(
                            foregroundColor: theme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ticket #${ticket.id.substring(0, 8)}...',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: theme.primaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ticket.code.length > 30
                        ? '${ticket.code.substring(0, 30)}...'
                        : ticket.code,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ),
          if (ticket.isActive)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined,
                    color: Colors.red, size: 22),
                tooltip: 'Cancel Ticket',
                onPressed: onCancel,
              ),
            ),
        ],
      ),
    );
  }
}
