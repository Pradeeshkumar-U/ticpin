import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class TurfAnalyticspage extends StatefulWidget {
  final String turfId;
  final Map<String, dynamic> turfData;

  const TurfAnalyticspage({
    super.key,
    required this.turfId,
    required this.turfData,
  });

  @override
  State<TurfAnalyticspage> createState() => _TurfAnalyticspageState();
}

class _TurfAnalyticspageState extends State<TurfAnalyticspage> {
  String selectedPeriod = 'Week';
  Map<String, dynamic> analyticsData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() {
      isLoading = true;
    });

    try {
      final now = DateTime.now();
      DateTime startDate;

      switch (selectedPeriod) {
        case 'Week':
          startDate = now.subtract(Duration(days: 7));
          break;
        case 'Month':
          startDate = now.subtract(Duration(days: 30));
          break;
        case 'Year':
          startDate = now.subtract(Duration(days: 365));
          break;
        default:
          startDate = now.subtract(Duration(days: 7));
      }

      // Fetch bookings for the period
      final bookingsQuery = await FirebaseFirestore.instance
          .collection('turf_bookings')
          .where('turfId', isEqualTo: widget.turfId)
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .get();

      int totalBookings = 0;
      int confirmedBookings = 0;
      int cancelledBookings = 0;
      double totalRevenue = 0;
      double totalHours = 0;
      Map<String, int> bookingsByDate = {};
      Map<String, double> revenueByDate = {};

      for (var doc in bookingsQuery.docs) {
        final data = doc.data();
        totalBookings++;

        final status = data['status'] ?? '';
        if (status == 'confirmed') {
          confirmedBookings++;
          totalRevenue += (data['totalAmount'] ?? 0).toDouble();
          totalHours += (data['totalHours'] ?? 0).toDouble();
        } else if (status.contains('cancelled')) {
          cancelledBookings++;
        }

        // Track bookings by date
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null) {
          final dateKey = DateFormat('yyyy-MM-dd').format(createdAt);
          bookingsByDate[dateKey] = (bookingsByDate[dateKey] ?? 0) + 1;
          
          if (status == 'confirmed') {
            revenueByDate[dateKey] = 
                (revenueByDate[dateKey] ?? 0) + (data['totalAmount'] ?? 0).toDouble();
          }
        }
      }

      setState(() {
        analyticsData = {
          'totalBookings': totalBookings,
          'confirmedBookings': confirmedBookings,
          'cancelledBookings': cancelledBookings,
          'totalRevenue': totalRevenue,
          'totalHours': totalHours,
          'averageBookingValue': confirmedBookings > 0 ? totalRevenue / confirmedBookings : 0,
          'bookingsByDate': bookingsByDate,
          'revenueByDate': revenueByDate,
        };
        isLoading = false;
      });
    } catch (e) {
      print('Error loading analytics: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Turf Analytics',
          style: TextStyle(fontFamily: 'Regular'),
        ),
        backgroundColor: Color(0xFF1E1E82),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Turf Name
                  Text(
                    widget.turfData['name'] ?? 'Turf Analytics',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: 8),

                  // Period Selector
                  Row(
                    children: [
                      Text(
                        'Period: ',
                        style: TextStyle(fontFamily: 'Regular'),
                      ),
                      ChoiceChip(
                        label: Text('Week', style: TextStyle(fontFamily: 'Regular')),
                        selected: selectedPeriod == 'Week',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => selectedPeriod = 'Week');
                            _loadAnalytics();
                          }
                        },
                      ),
                      SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('Month', style: TextStyle(fontFamily: 'Regular')),
                        selected: selectedPeriod == 'Month',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => selectedPeriod = 'Month');
                            _loadAnalytics();
                          }
                        },
                      ),
                      SizedBox(width: 8),
                      ChoiceChip(
                        label: Text('Year', style: TextStyle(fontFamily: 'Regular')),
                        selected: selectedPeriod == 'Year',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => selectedPeriod = 'Year');
                            _loadAnalytics();
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Summary Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        'Total Bookings',
                        '${analyticsData['totalBookings'] ?? 0}',
                        Icons.event_note,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Confirmed',
                        '${analyticsData['confirmedBookings'] ?? 0}',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Total Revenue',
                        '₹${NumberFormat('#,##,###').format(analyticsData['totalRevenue'] ?? 0)}',
                        Icons.currency_rupee,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        'Cancelled',
                        '${analyticsData['cancelledBookings'] ?? 0}',
                        Icons.cancel,
                        Colors.red,
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Additional Stats
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Additional Insights',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildStatRow(
                            'Total Hours Booked',
                            '${(analyticsData['totalHours'] ?? 0).toStringAsFixed(1)} hrs',
                          ),
                          _buildStatRow(
                            'Average Booking Value',
                            '₹${(analyticsData['averageBookingValue'] ?? 0).toStringAsFixed(0)}',
                          ),
                          _buildStatRow(
                            'Cancellation Rate',
                            '${_getCancellationRate()}%',
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Bookings Chart
                  if ((analyticsData['bookingsByDate'] as Map?)?.isNotEmpty ?? false)
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bookings Trend',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Regular',
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 200,
                              child: _buildBookingsChart(),
                            ),
                          ],
                        ),
                      ),
                    ),

                  SizedBox(height: 24),

                  // Recent Bookings
                  Text(
                    'Recent Bookings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                  SizedBox(height: 8),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('turf_bookings')
                        .where('turfId', isEqualTo: widget.turfId)
                        .orderBy('createdAt', descending: true)
                        .limit(10)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final bookings = snapshot.data!.docs;
                      if (bookings.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('No bookings yet'),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index].data() as Map<String, dynamic>;
                          return _buildBookingCard(booking);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Regular',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontFamily: 'Regular'),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsChart() {
    final bookingsByDate = analyticsData['bookingsByDate'] as Map<String, int>;
    final sortedDates = bookingsByDate.keys.toList()..sort();
    
    if (sortedDates.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                  final date = DateTime.parse(sortedDates[value.toInt()]);
                  return Text(
                    DateFormat('MM/dd').format(date),
                    style: TextStyle(fontSize: 10),
                  );
                }
                return Text('');
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: sortedDates.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                bookingsByDate[entry.value]!.toDouble(),
              );
            }).toList(),
            isCurved: true,
            color: Color(0xFF1E1E82),
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] ?? '';
    final statusColor = _getStatusColor(status);

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          'Booking #${booking['bookingId']?.substring(0, 8) ?? 'N/A'}',
          style: TextStyle(fontFamily: 'Regular'),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${booking['date']} • ${booking['session']}',
              style: TextStyle(fontFamily: 'Regular'),
            ),
            Text(
              '${booking['totalHours']} hrs • ₹${booking['totalAmount']}',
              style: TextStyle(fontFamily: 'Regular'),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(50),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            _getStatusText(status),
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Regular',
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'cancelled_by_admin':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'cancelled_by_admin':
        return 'Admin Cancelled';
      default:
        return status;
    }
  }

  String _getCancellationRate() {
    final total = analyticsData['totalBookings'] ?? 0;
    final cancelled = analyticsData['cancelledBookings'] ?? 0;
    if (total == 0) return '0';
    return ((cancelled / total) * 100).toStringAsFixed(1);
  }
}