import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class DiningAnalyticsPage extends StatefulWidget {
  final String diningId;
  final Map<String, dynamic> diningData;

  const DiningAnalyticsPage({
    super.key,
    required this.diningId,
    required this.diningData,
  });

  @override
  State<DiningAnalyticsPage> createState() => _DiningAnalyticsPageState();
}

class _DiningAnalyticsPageState extends State<DiningAnalyticsPage> {
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
          .collection('dining_bookings')
          .where('diningId', isEqualTo: widget.diningId)
          .where('createdAt', isGreaterThanOrEqualTo: startDate)
          .get();

      int totalBookings = 0;
      int confirmedBookings = 0;
      int cancelledBookings = 0;
      int completedBookings = 0;
      double totalRevenue = 0;
      double ticpinAppRevenue = 0;
      double directRevenue = 0;
      double advancePayments = 0;
      double billPayments = 0;
      int totalPeople = 0;
      Map<String, int> bookingsByDate = {};
      Map<String, double> revenueByDate = {};
      Map<String, int> bookingsByTimeSlot = {};
      Map<String, int> peopleByTimeSlot = {};

      for (var doc in bookingsQuery.docs) {
        final data = doc.data();
        totalBookings++;

        final status = data['status'] ?? '';
        final advanceAmount = (data['advanceAmount'] ?? 0).toDouble();
        final billAmount = (data['billAmount'] ?? 0).toDouble();
        final numberOfPeople = (data['numberOfPeople'] ?? 0);
        final timeSlot = data['timeSlot'] ?? 'Unknown';
        final paymentSource = data['paymentSource'] ?? 'ticpin_app'; // Assume ticpin_app if not specified

        if (status == 'confirmed' || status == 'completed') {
          if (status == 'confirmed') {
            confirmedBookings++;
          } else {
            completedBookings++;
          }

          totalPeople += (numberOfPeople as num).toInt();

          // Track revenue
          if (advanceAmount > 0) {
            totalRevenue += advanceAmount;
            advancePayments += advanceAmount;

            if (paymentSource == 'ticpin_app') {
              ticpinAppRevenue += advanceAmount;
            } else {
              directRevenue += advanceAmount;
            }
          }

          if (billAmount > 0) {
            totalRevenue += billAmount;
            billPayments += billAmount;
            // Bill payments are typically direct
            directRevenue += billAmount;
          }

          // Track by time slot
          bookingsByTimeSlot[timeSlot] = (bookingsByTimeSlot[timeSlot] ?? 0) + 1;
          peopleByTimeSlot[timeSlot] = (peopleByTimeSlot[timeSlot] ?? 0) + (numberOfPeople as int);
        } else if (status == 'cancelled') {
          cancelledBookings++;
        }

        // Track bookings by date
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null) {
          final dateKey = DateFormat('yyyy-MM-dd').format(createdAt);
          bookingsByDate[dateKey] = (bookingsByDate[dateKey] ?? 0) + 1;

          if (status == 'confirmed' || status == 'completed') {
            double dayRevenue = 0;
            if (advanceAmount > 0) dayRevenue += advanceAmount;
            if (billAmount > 0) dayRevenue += billAmount;
            revenueByDate[dateKey] = (revenueByDate[dateKey] ?? 0) + dayRevenue;
          }
        }
      }

      final activeBookings = confirmedBookings; // Bookings that are confirmed but not completed

      setState(() {
        analyticsData = {
          'totalBookings': totalBookings,
          'confirmedBookings': confirmedBookings,
          'completedBookings': completedBookings,
          'activeBookings': activeBookings,
          'cancelledBookings': cancelledBookings,
          'totalRevenue': totalRevenue,
          'ticpinAppRevenue': ticpinAppRevenue,
          'directRevenue': directRevenue,
          'advancePayments': advancePayments,
          'billPayments': billPayments,
          'totalPeople': totalPeople,
          'averageBookingValue': (confirmedBookings + completedBookings) > 0 
              ? totalRevenue / (confirmedBookings + completedBookings) 
              : 0,
          'averagePartySize': (confirmedBookings + completedBookings) > 0 
              ? totalPeople / (confirmedBookings + completedBookings) 
              : 0,
          'bookingsByDate': bookingsByDate,
          'revenueByDate': revenueByDate,
          'bookingsByTimeSlot': bookingsByTimeSlot,
          'peopleByTimeSlot': peopleByTimeSlot,
          'ticpinAppPercentage': totalRevenue > 0 
              ? (ticpinAppRevenue / totalRevenue * 100) 
              : 0.0,
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Dining Analytics',
          style: TextStyle(fontFamily: 'Regular', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF1E1E82),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dining Name
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1E1E82), Color(0xFF2E2E92)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.restaurant, color: Colors.white, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.diningData['name'] ?? 'Dining Analytics',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Regular',
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Revenue & Bookings Overview',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Regular',
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),

                  // Period Selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          'Period: ',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        _buildPeriodChip('Week'),
                        SizedBox(width: 8),
                        _buildPeriodChip('Month'),
                        SizedBox(width: 8),
                        _buildPeriodChip('Year'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Revenue Overview Card
                  _buildRevenueOverviewCard(),
                  SizedBox(height: 16),

                  // Ticpin App Revenue Card
                  _buildTicpinRevenueCard(),
                  SizedBox(height: 16),

                  // Booking Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildStatCard(
                        'Total Bookings',
                        '${analyticsData['totalBookings'] ?? 0}',
                        Icons.event_note,
                        Colors.blue,
                      ),
                      _buildStatCard(
                        'Active',
                        '${analyticsData['activeBookings'] ?? 0}',
                        Icons.access_time,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        'Completed',
                        '${analyticsData['completedBookings'] ?? 0}',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Cancelled',
                        '${analyticsData['cancelledBookings'] ?? 0}',
                        Icons.cancel,
                        Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Guest & Table Stats
                  _buildGuestStatsCard(),
                  SizedBox(height: 16),

                  // Time Slot Distribution
                  if ((analyticsData['bookingsByTimeSlot'] as Map?)?.isNotEmpty ?? false)
                    _buildTimeSlotCard(),
                  SizedBox(height: 16),

                  // Revenue Trend Chart
                  if ((analyticsData['revenueByDate'] as Map?)?.isNotEmpty ?? false)
                    _buildRevenueChartCard(),
                  SizedBox(height: 16),

                  // Bookings Trend Chart
                  if ((analyticsData['bookingsByDate'] as Map?)?.isNotEmpty ?? false)
                    _buildBookingsChartCard(),
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
                  SizedBox(height: 12),
                  _buildRecentBookingsList(),
                ],
              ),
            ),
    );
  }

  Widget _buildPeriodChip(String period) {
    final isSelected = selectedPeriod == period;
    return ChoiceChip(
      label: Text(
        period,
        style: TextStyle(
          fontFamily: 'Regular',
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: isSelected,
      selectedColor: Color(0xFF1E1E82),
      backgroundColor: Colors.white,
      onSelected: (selected) {
        if (selected) {
          setState(() => selectedPeriod = period);
          _loadAnalytics();
        }
      },
    );
  }

  Widget _buildRevenueOverviewCard() {
    final totalRevenue = analyticsData['totalRevenue'] ?? 0.0;
    final advancePayments = analyticsData['advancePayments'] ?? 0.0;
    final billPayments = analyticsData['billPayments'] ?? 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade700, Colors.deepPurple.shade900],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Revenue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'Regular',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '₹${NumberFormat('#,##,###').format(totalRevenue)}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white24),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Advance Payments',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontFamily: 'Regular',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹${NumberFormat('#,##,###').format(advancePayments)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade300,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Bill Payments',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontFamily: 'Regular',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹${NumberFormat('#,##,###').format(billPayments)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade300,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicpinRevenueCard() {
    final ticpinAppRevenue = analyticsData['ticpinAppRevenue'] ?? 0.0;
    final directRevenue = analyticsData['directRevenue'] ?? 0.0;
    final ticpinPercentage = analyticsData['ticpinAppPercentage'] ?? 0.0;
    final totalRevenue = analyticsData['totalRevenue'] ?? 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone_android, color: Colors.blue, size: 24),
                SizedBox(width: 8),
                Text(
                  'Ticpin App Revenue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Regular',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone_android, color: Colors.blue, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Ticpin App',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹${NumberFormat('#,##,###').format(ticpinAppRevenue)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${ticpinPercentage.toStringAsFixed(1)}% of total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.store, color: Colors.orange, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'Direct',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                                fontFamily: 'Regular',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹${NumberFormat('#,##,###').format(directRevenue)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                            fontFamily: 'Regular',
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${(100 - ticpinPercentage).toStringAsFixed(1)}% of total',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange.shade900,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 12,
                child: Row(
                  children: [
                    if (ticpinPercentage > 0)
                      Expanded(
                        flex: ticpinPercentage.round(),
                        child: Container(color: Colors.blue),
                      ),
                    if ((100 - ticpinPercentage) > 0)
                      Expanded(
                        flex: (100 - ticpinPercentage).round(),
                        child: Container(color: Colors.orange),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestStatsCard() {
    final totalPeople = analyticsData['totalPeople'] ?? 0;
    final averagePartySize = analyticsData['averagePartySize'] ?? 0.0;
    final averageBookingValue = analyticsData['averageBookingValue'] ?? 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest & Booking Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 16),
            _buildStatRow(
              'Total Guests Served',
              '$totalPeople people',
              Icons.people,
              Colors.purple,
            ),
            Divider(height: 24),
            _buildStatRow(
              'Average Party Size',
              '${averagePartySize.toStringAsFixed(1)} people',
              Icons.group,
              Colors.blue,
            ),
            Divider(height: 24),
            _buildStatRow(
              'Avg Booking Value',
              '₹${averageBookingValue.toStringAsFixed(0)}',
              Icons.receipt_long,
              Colors.green,
            ),
            Divider(height: 24),
            _buildStatRow(
              'Cancellation Rate',
              '${_getCancellationRate()}%',
              Icons.info_outline,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard() {
    final bookingsByTimeSlot = analyticsData['bookingsByTimeSlot'] as Map<String, int>;
    final peopleByTimeSlot = analyticsData['peopleByTimeSlot'] as Map<String, int>;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookings by Time Slot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 16),
            ...bookingsByTimeSlot.entries.map((entry) {
              final timeSlot = entry.key;
              final bookings = entry.value;
              final people = peopleByTimeSlot[timeSlot] ?? 0;
              final color = _getTimeSlotColor(timeSlot);

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(_getTimeSlotIcon(timeSlot), color: color, size: 24),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeSlot,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Regular',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$people people • $bookings tables',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$bookings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChartCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _buildRevenueChart(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsChartCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
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
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Regular',
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontFamily: 'Regular',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Regular',
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Regular',
          ),
        ),
      ],
    );
  }

  Widget _buildRevenueChart() {
    final revenueByDate = analyticsData['revenueByDate'] as Map<String, double>;
    final sortedDates = revenueByDate.keys.toList()..sort();

    if (sortedDates.isEmpty) {
      return Center(child: Text('No data available'));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${(value / 1000).toStringAsFixed(0)}k',
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
                  final date = DateTime.parse(sortedDates[value.toInt()]);
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: TextStyle(fontSize: 9),
                    ),
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
                revenueByDate[entry.value]!,
              );
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
            ),
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.purple.shade400.withOpacity(0.3),
                  Colors.deepPurple.shade600.withOpacity(0.1),
                ],
              ),
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
        gridData: FlGridData(show: true, drawVerticalLine: false),
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
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: TextStyle(fontSize: 9),
                    ),
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
            belowBarData: BarAreaData(
              show: true,
              color: Color(0xFF1E1E82).withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentBookingsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('dining_bookings')
          .where('diningId', isEqualTo: widget.diningId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final bookings = snapshot.data!.docs;
        if (bookings.isEmpty) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No bookings yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
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
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] ?? '';
    final statusColor = _getStatusColor(status);
    final userDetails = booking['userDetails'] as Map<String, dynamic>? ?? {};
    final numberOfPeople = booking['numberOfPeople'] ?? 0;
    final timeSlot = booking['timeSlot'] ?? 'N/A';
    final date = booking['date'] ?? 'N/A';
    final startTime = booking['startTime'] ?? '';
    final endTime = booking['endTime'] ?? '';
    final advanceAmount = (booking['advanceAmount'] ?? 0).toDouble();
    final billAmount = (booking['billAmount'] ?? 0).toDouble();

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
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
                        userDetails['name'] ?? 'Guest',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Regular',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        userDetails['phone'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: 'Regular',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    _getStatusText(status),
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  date,
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  '$startTime - $endTime',
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  timeSlot,
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
                SizedBox(width: 16),
                Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  '$numberOfPeople ${numberOfPeople == 1 ? 'person' : 'people'}',
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
              ],
            ),
            if (advanceAmount > 0 || billAmount > 0) ...[
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (advanceAmount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.payment, size: 14, color: Colors.amber.shade700),
                          SizedBox(width: 4),
                          Text(
                            'Advance: ₹${advanceAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (billAmount > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.receipt_long, size: 14, color: Colors.green.shade700),
                          SizedBox(width: 4),
                          Text(
                            'Bill: ₹${billAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                              fontFamily: 'Regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
  }

  Color _getTimeSlotColor(String timeSlot) {
    switch (timeSlot.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.green;
      case 'dinner':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  IconData _getTimeSlotIcon(String timeSlot) {
    switch (timeSlot.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  String _getCancellationRate() {
    final total = analyticsData['totalBookings'] ?? 0;
    final cancelled = analyticsData['cancelledBookings'] ?? 0;
    if (total == 0) return '0.0';
    return ((cancelled / total) * 100).toStringAsFixed(1);
  }
}