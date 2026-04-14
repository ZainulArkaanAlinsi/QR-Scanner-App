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

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            ticket.isCanceled
                ? Icons.cancel_outlined
                : (ticket.used ? Icons.check_circle_outline : Icons.confirmation_number_outlined),
            color: _getStatusColor(),
            size: 20,
          ),
        ),
        title: Text(
          ticket.event?.name ?? 'Event Ticket',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Ordered $dateStr • #${ticket.id.substring(0, 8).toUpperCase()}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      ),
    );
  }

  Color _getStatusColor() {
    if (ticket.isCanceled) return Colors.red;
    if (ticket.used) return Colors.green;
    return Colors.indigo;
  }
}
