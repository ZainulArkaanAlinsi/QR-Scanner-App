import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ticket_model.dart';

class TicketTile extends StatelessWidget {
  final TicketModel ticket;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const TicketTile({
    super.key,
    required this.ticket,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = ticket.createdAt != null
        ? DateFormat('dd MMM yyyy').format(ticket.createdAt!)
        : 'Recently';

    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getStatusColor(context).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            ticket.isCanceled
                ? Icons.cancel_outlined
                : (ticket.used ? Icons.check_circle_outline : Icons.confirmation_number_outlined),
            color: _getStatusColor(context),
            size: 20,
          ),
        ),
        title: Text(
          ticket.event?.name ?? 'Event Ticket',
          style: Theme.of(context).textTheme.titleSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Ordered $dateStr • #${ticket.id.substring(0, 8).toUpperCase()}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        trailing: Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400),
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    if (ticket.isCanceled) return Theme.of(context).colorScheme.error;
    if (ticket.used) return Colors.amber.shade700;
    return Theme.of(context).primaryColor;
  }
}
