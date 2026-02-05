import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ==================== ADMIN EVENT MANAGEMENT PAGE ====================

class AdminEventManagementPage extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> eventData;

  const AdminEventManagementPage({
    Key? key,
    required this.eventId,
    required this.eventData,
  }) : super(key: key);

  @override
  State<AdminEventManagementPage> createState() =>
      _AdminEventManagementPageState();
}

class _AdminEventManagementPageState extends State<AdminEventManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Calculate total sold and revenue
  Map<String, dynamic> _calculateStatistics(
    List<Map<String, dynamic>> tickets,
  ) {
    int totalQuantity = 0;
    int totalSold = 0;
    int totalRevenue = 0;

    for (var ticket in tickets) {
      final quantity = ticket['quantity'] ?? 0;
      final available = ticket['available'] ?? quantity;
      final price = ticket['price'] ?? 0;
      final sold = quantity - available;

      totalQuantity += (quantity as num).toInt();
      totalSold += (sold as num).toInt();
      totalRevenue += ((sold * price)).toInt();
    }

    return {
      'totalQuantity': totalQuantity,
      'totalSold': totalSold,
      'totalAvailable': totalQuantity - totalSold,
      'totalRevenue': totalRevenue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventData['name'] ?? 'Event Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.confirmation_number), text: 'Tickets'),
            Tab(icon: Icon(Icons.people), text: 'Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildTicketsTab(), _buildBookingsTab()],
      ),
    );
  }

  // ==================== TICKETS TAB ====================
  Widget _buildTicketsTab() {
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('events').doc(widget.eventId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('Event not found'));
        }

        final eventData = snapshot.data!.data() as Map<String, dynamic>;
        final tickets = List<Map<String, dynamic>>.from(
          eventData['tickets'] ?? [],
        );

        if (tickets.isEmpty) {
          return const Center(child: Text('No tickets available'));
        }

        final stats = _calculateStatistics(tickets);

        return Column(
          children: [
            // Statistics Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.purple.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Event Statistics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total Tickets',
                        stats['totalQuantity'].toString(),
                        Icons.confirmation_number,
                      ),
                      _buildStatItem(
                        'Sold',
                        stats['totalSold'].toString(),
                        Icons.check_circle,
                      ),
                      _buildStatItem(
                        'Available',
                        stats['totalAvailable'].toString(),
                        Icons.event_available,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Icon(Icons.attach_money, color: Colors.white),
                        // const SizedBox(width: 8),
                        Text(
                          'Total Revenue: ₹${NumberFormat('#,##,###').format(stats['totalRevenue'])}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tickets List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  final ticket = tickets[index];
                  return _buildTicketCard(ticket);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final quantity = ticket['quantity'] ?? 0;
    final available = ticket['available'] ?? quantity;
    final sold = quantity - available;
    final price = ticket['price'] ?? 0;
    final revenue = sold * price;
    final soldPercentage = quantity > 0 ? (sold / quantity * 100) : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket['type'] ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${price.toString()}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        ticket['seatingType'] == 'VIP'
                            ? Colors.amber.shade100
                            : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    ticket['seatingType'] ?? 'Standard',
                    style: TextStyle(
                      color:
                          ticket['seatingType'] == 'VIP'
                              ? Colors.amber.shade900
                              : Colors.blue.shade900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sold: $sold / $quantity',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${soldPercentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: soldPercentage / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      soldPercentage > 75
                          ? Colors.red
                          : soldPercentage > 50
                          ? Colors.orange
                          : Colors.green,
                    ),
                    minHeight: 10,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildTicketStat(
                    'Available',
                    available.toString(),
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildTicketStat(
                    'Revenue',
                    '₹${NumberFormat('#,##,###').format(revenue)}',
                    Colors.blue,
                  ),
                ),
              ],
            ),

            // Inclusions
            if (ticket['inclusions'] != null &&
                (ticket['inclusions'] as List).isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Inclusions:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    (ticket['inclusions'] as List)
                        .map(
                          (inclusion) => Chip(
                            label: Text(
                              inclusion,
                              style: const TextStyle(fontSize: 12),
                            ),
                            backgroundColor: Colors.grey.shade200,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTicketStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withAlpha(100)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BOOKINGS TAB ====================
  Widget _buildBookingsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore
              .collection('bookings')
              .where('eventId', isEqualTo: widget.eventId)
              .orderBy('createdAt', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No bookings yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final bookings = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index].data() as Map<String, dynamic>;
            final bookingId = bookings[index].id;
            return _buildBookingCard(booking, bookingId);
          },
        );
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, String bookingId) {
    final status = booking['status'] ?? 'pending';
    final userDetails = booking['userDetails'] as Map<String, dynamic>? ?? {};
    final timestamp = booking['createdAt'] as Timestamp?;
    final date = timestamp?.toDate();

    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showBookingDetails(booking, bookingId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userDetails['name'] ?? 'Unknown User',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userDetails['email'] ?? 'No email',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (userDetails['phone'] != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            userDetails['phone'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 16, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBookingInfo(
                    'Ticket Type',
                    booking['ticketType'] ?? 'Unknown',
                    Icons.confirmation_number,
                  ),
                  _buildBookingInfo(
                    'Quantity',
                    booking['quantity']?.toString() ?? '0',
                    Icons.people,
                  ),
                  _buildBookingInfo(
                    'Amount',
                    '₹${booking['totalAmount'] ?? 0}',
                    Icons.attach_money,
                  ),
                ],
              ),
              if (date != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Booked: ${DateFormat('MMM dd, yyyy - hh:mm a').format(date)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (status == 'pending')
                    TextButton.icon(
                      onPressed: () => _confirmBooking(bookingId, booking),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Confirm'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                  if (status != 'cancelled')
                    TextButton.icon(
                      onPressed: () => _cancelBooking(bookingId, booking),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  TextButton.icon(
                    onPressed: () => _deleteBooking(bookingId, booking),
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingInfo(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  // ==================== BOOKING ACTIONS ====================

  void _showBookingDetails(Map<String, dynamic> booking, String bookingId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      'Booking ID',
                      booking['bookingId'] ?? bookingId,
                    ),
                    _buildDetailRow('Status', booking['status'] ?? 'pending'),
                    _buildDetailRow(
                      'Ticket Type',
                      booking['ticketType'] ?? 'Unknown',
                    ),
                    _buildDetailRow(
                      'Quantity',
                      booking['quantity']?.toString() ?? '0',
                    ),
                    _buildDetailRow(
                      'Total Amount',
                      '₹${booking['totalAmount'] ?? 0}',
                    ),
                    const Divider(height: 32),
                    const Text(
                      'User Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...((booking['userDetails'] as Map<String, dynamic>?) ?? {})
                        .entries
                        .map(
                          (e) => _buildDetailRow(
                            e.key[0].toUpperCase() + e.key.substring(1),
                            e.value?.toString() ?? 'N/A',
                          ),
                        )
                        .toList(),
                    if (booking['paymentId'] != null) ...[
                      const Divider(height: 32),
                      const Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow('Payment ID', booking['paymentId']),
                      if (booking['paymentMethod'] != null)
                        _buildDetailRow(
                          'Payment Method',
                          booking['paymentMethod'],
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Future<void> _confirmBooking(
    String bookingId,
    Map<String, dynamic> booking,
  ) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'confirmed',
        'confirmedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking confirmed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _cancelBooking(
    String bookingId,
    Map<String, dynamic> booking,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Booking'),
            content: const Text(
              'Are you sure you want to cancel this booking? Tickets will be restored.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      await _firestore.runTransaction((transaction) async {
        // Get booking
        final bookingRef = _firestore.collection('bookings').doc(bookingId);
        final bookingDoc = await transaction.get(bookingRef);

        if (!bookingDoc.exists) {
          throw Exception('Booking not found');
        }

        final bookingData = bookingDoc.data()!;

        // Get event and restore tickets
        final eventRef = _firestore
            .collection('events')
            .doc(bookingData['eventId']);
        final eventDoc = await transaction.get(eventRef);

        if (!eventDoc.exists) {
          throw Exception('Event not found');
        }

        final eventData = eventDoc.data()!;
        final tickets = List<Map<String, dynamic>>.from(
          eventData['tickets'] ?? [],
        );

        // Find and update ticket availability
        for (int i = 0; i < tickets.length; i++) {
          if (tickets[i]['id'] == bookingData['ticketId']) {
            final currentAvailable = tickets[i]['available'] ?? 0;
            final quantity = bookingData['quantity'] ?? 0;
            tickets[i]['available'] = currentAvailable + quantity;
            break;
          }
        }

        // Update event
        transaction.update(eventRef, {'tickets': tickets});

        // Update booking
        transaction.update(bookingRef, {
          'status': 'cancelled',
          'cancelledAt': FieldValue.serverTimestamp(),
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking cancelled and tickets restored'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteBooking(
    String bookingId,
    Map<String, dynamic> booking,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Booking'),
            content: const Text(
              'Are you sure you want to delete this booking? '
              'If not cancelled, tickets will be restored.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Yes, Delete'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      // If booking is not cancelled, restore tickets first
      if (booking['status'] != 'cancelled') {
        await _firestore.runTransaction((transaction) async {
          final eventRef = _firestore
              .collection('events')
              .doc(booking['eventId']);
          final eventDoc = await transaction.get(eventRef);

          if (eventDoc.exists) {
            final eventData = eventDoc.data()!;
            final tickets = List<Map<String, dynamic>>.from(
              eventData['tickets'] ?? [],
            );

            for (int i = 0; i < tickets.length; i++) {
              if (tickets[i]['id'] == booking['ticketId']) {
                final currentAvailable = tickets[i]['available'] ?? 0;
                final quantity = booking['quantity'] ?? 0;
                tickets[i]['available'] = currentAvailable + quantity;
                break;
              }
            }

            transaction.update(eventRef, {'tickets': tickets});
          }
        });
      }

      // Delete booking
      await _firestore.collection('bookings').doc(bookingId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
