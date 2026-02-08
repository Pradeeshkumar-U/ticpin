// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

// class TurfAnalyticspage extends StatefulWidget {
//   final String turfId;
//   final Map<String, dynamic> turfData;

//   const TurfAnalyticspage({
//     super.key,
//     required this.turfId,
//     required this.turfData,
//   });

//   @override
//   State<TurfAnalyticspage> createState() => _TurfAnalyticspageState();
// }

// class _TurfAnalyticspageState extends State<TurfAnalyticspage> {
//   String selectedPeriod = 'Week';
//   Map<String, dynamic> analyticsData = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadAnalytics();
//   }

//   Future<void> _loadAnalytics() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final now = DateTime.now();
//       DateTime startDate;

//       switch (selectedPeriod) {
//         case 'Week':
//           startDate = now.subtract(Duration(days: 7));
//           break;
//         case 'Month':
//           startDate = now.subtract(Duration(days: 30));
//           break;
//         case 'Year':
//           startDate = now.subtract(Duration(days: 365));
//           break;
//         default:
//           startDate = now.subtract(Duration(days: 7));
//       }

//       // Fetch bookings for the period
//       final bookingsQuery = await FirebaseFirestore.instance
//           .collection('turf_bookings')
//           .where('turfId', isEqualTo: widget.turfId)
//           .where('createdAt', isGreaterThanOrEqualTo: startDate)
//           .get();

//       int totalBookings = 0;
//       int confirmedBookings = 0;
//       int cancelledBookings = 0;
//       double totalRevenue = 0;
//       double totalHours = 0;
//       Map<String, int> bookingsByDate = {};
//       Map<String, double> revenueByDate = {};

//       for (var doc in bookingsQuery.docs) {
//         final data = doc.data();
//         totalBookings++;

//         final status = data['status'] ?? '';
//         if (status == 'confirmed') {
//           confirmedBookings++;
//           totalRevenue += (data['totalAmount'] ?? 0).toDouble();
//           totalHours += (data['totalHours'] ?? 0).toDouble();
//         } else if (status.contains('cancelled')) {
//           cancelledBookings++;
//         }

//         // Track bookings by date
//         final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
//         if (createdAt != null) {
//           final dateKey = DateFormat('yyyy-MM-dd').format(createdAt);
//           bookingsByDate[dateKey] = (bookingsByDate[dateKey] ?? 0) + 1;
          
//           if (status == 'confirmed') {
//             revenueByDate[dateKey] = 
//                 (revenueByDate[dateKey] ?? 0) + (data['totalAmount'] ?? 0).toDouble();
//           }
//         }
//       }

//       setState(() {
//         analyticsData = {
//           'totalBookings': totalBookings,
//           'confirmedBookings': confirmedBookings,
//           'cancelledBookings': cancelledBookings,
//           'totalRevenue': totalRevenue,
//           'totalHours': totalHours,
//           'averageBookingValue': confirmedBookings > 0 ? totalRevenue / confirmedBookings : 0,
//           'bookingsByDate': bookingsByDate,
//           'revenueByDate': revenueByDate,
//         };
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading analytics: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Turf Analytics',
//           style: TextStyle(fontFamily: 'Regular'),
//         ),
//         backgroundColor: Color(0xFF1E1E82),
//         foregroundColor: Colors.white,
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Turf Name
//                   Text(
//                     widget.turfData['name'] ?? 'Turf Analytics',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Regular',
//                     ),
//                   ),
//                   SizedBox(height: 8),

//                   // Period Selector
//                   Row(
//                     children: [
//                       Text(
//                         'Period: ',
//                         style: TextStyle(fontFamily: 'Regular'),
//                       ),
//                       ChoiceChip(
//                         label: Text('Week', style: TextStyle(fontFamily: 'Regular')),
//                         selected: selectedPeriod == 'Week',
//                         onSelected: (selected) {
//                           if (selected) {
//                             setState(() => selectedPeriod = 'Week');
//                             _loadAnalytics();
//                           }
//                         },
//                       ),
//                       SizedBox(width: 8),
//                       ChoiceChip(
//                         label: Text('Month', style: TextStyle(fontFamily: 'Regular')),
//                         selected: selectedPeriod == 'Month',
//                         onSelected: (selected) {
//                           if (selected) {
//                             setState(() => selectedPeriod = 'Month');
//                             _loadAnalytics();
//                           }
//                         },
//                       ),
//                       SizedBox(width: 8),
//                       ChoiceChip(
//                         label: Text('Year', style: TextStyle(fontFamily: 'Regular')),
//                         selected: selectedPeriod == 'Year',
//                         onSelected: (selected) {
//                           if (selected) {
//                             setState(() => selectedPeriod = 'Year');
//                             _loadAnalytics();
//                           }
//                         },
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 24),

//                   // Summary Cards
//                   GridView.count(
//                     crossAxisCount: 2,
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     childAspectRatio: 1.5,
//                     children: [
//                       _buildStatCard(
//                         'Total Bookings',
//                         '${analyticsData['totalBookings'] ?? 0}',
//                         Icons.event_note,
//                         Colors.blue,
//                       ),
//                       _buildStatCard(
//                         'Confirmed',
//                         '${analyticsData['confirmedBookings'] ?? 0}',
//                         Icons.check_circle,
//                         Colors.green,
//                       ),
//                       _buildStatCard(
//                         'Total Revenue',
//                         '₹${NumberFormat('#,##,###').format(analyticsData['totalRevenue'] ?? 0)}',
//                         Icons.currency_rupee,
//                         Colors.orange,
//                       ),
//                       _buildStatCard(
//                         'Cancelled',
//                         '${analyticsData['cancelledBookings'] ?? 0}',
//                         Icons.cancel,
//                         Colors.red,
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 24),

//                   // Additional Stats
//                   Card(
//                     child: Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Additional Insights',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Regular',
//                             ),
//                           ),
//                           SizedBox(height: 16),
//                           _buildStatRow(
//                             'Total Hours Booked',
//                             '${(analyticsData['totalHours'] ?? 0).toStringAsFixed(1)} hrs',
//                           ),
//                           _buildStatRow(
//                             'Average Booking Value',
//                             '₹${(analyticsData['averageBookingValue'] ?? 0).toStringAsFixed(0)}',
//                           ),
//                           _buildStatRow(
//                             'Cancellation Rate',
//                             '${_getCancellationRate()}%',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   SizedBox(height: 24),

//                   // Bookings Chart
//                   if ((analyticsData['bookingsByDate'] as Map?)?.isNotEmpty ?? false)
//                     Card(
//                       child: Padding(
//                         padding: EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Bookings Trend',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Regular',
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             SizedBox(
//                               height: 200,
//                               child: _buildBookingsChart(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                   SizedBox(height: 24),

//                   // Recent Bookings
//                   Text(
//                     'Recent Bookings',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Regular',
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                         .collection('turf_bookings')
//                         .where('turfId', isEqualTo: widget.turfId)
//                         .orderBy('createdAt', descending: true)
//                         .limit(10)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return Center(child: CircularProgressIndicator());
//                       }

//                       final bookings = snapshot.data!.docs;
//                       if (bookings.isEmpty) {
//                         return Center(
//                           child: Padding(
//                             padding: EdgeInsets.all(20),
//                             child: Text('No bookings yet'),
//                           ),
//                         );
//                       }

//                       return ListView.builder(
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         itemCount: bookings.length,
//                         itemBuilder: (context, index) {
//                           final booking = bookings[index].data() as Map<String, dynamic>;
//                           return _buildBookingCard(booking);
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, color: color, size: 32),
//             SizedBox(height: 8),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Regular',
//               ),
//             ),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey.shade600,
//                 fontFamily: 'Regular',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontFamily: 'Regular'),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Regular',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingsChart() {
//     final bookingsByDate = analyticsData['bookingsByDate'] as Map<String, int>;
//     final sortedDates = bookingsByDate.keys.toList()..sort();
    
//     if (sortedDates.isEmpty) {
//       return Center(child: Text('No data available'));
//     }

//     return LineChart(
//       LineChartData(
//         gridData: FlGridData(show: true),
//         titlesData: FlTitlesData(
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(showTitles: true, reservedSize: 40),
//           ),
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: (value, meta) {
//                 if (value.toInt() >= 0 && value.toInt() < sortedDates.length) {
//                   final date = DateTime.parse(sortedDates[value.toInt()]);
//                   return Text(
//                     DateFormat('MM/dd').format(date),
//                     style: TextStyle(fontSize: 10),
//                   );
//                 }
//                 return Text('');
//               },
//             ),
//           ),
//           rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//           topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         ),
//         borderData: FlBorderData(show: true),
//         lineBarsData: [
//           LineChartBarData(
//             spots: sortedDates.asMap().entries.map((entry) {
//               return FlSpot(
//                 entry.key.toDouble(),
//                 bookingsByDate[entry.value]!.toDouble(),
//               );
//             }).toList(),
//             isCurved: true,
//             color: Color(0xFF1E1E82),
//             barWidth: 3,
//             dotData: FlDotData(show: true),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookingCard(Map<String, dynamic> booking) {
//     final status = booking['status'] ?? '';
//     final statusColor = _getStatusColor(status);

//     return Card(
//       margin: EdgeInsets.only(bottom: 8),
//       child: ListTile(
//         title: Text(
//           'Booking #${booking['bookingId']?.substring(0, 8) ?? 'N/A'}',
//           style: TextStyle(fontFamily: 'Regular'),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               '${booking['date']} • ${booking['session']}',
//               style: TextStyle(fontFamily: 'Regular'),
//             ),
//             Text(
//               '${booking['totalHours']} hrs • ₹${booking['totalAmount']}',
//               style: TextStyle(fontFamily: 'Regular'),
//             ),
//           ],
//         ),
//         trailing: Container(
//           padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//           decoration: BoxDecoration(
//             color: statusColor.withAlpha(50),
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: statusColor),
//           ),
//           child: Text(
//             _getStatusText(status),
//             style: TextStyle(
//               fontSize: 12,
//               color: statusColor,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Regular',
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'confirmed':
//         return Colors.green;
//       case 'pending':
//         return Colors.orange;
//       case 'cancelled':
//       case 'cancelled_by_admin':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _getStatusText(String status) {
//     switch (status) {
//       case 'confirmed':
//         return 'Confirmed';
//       case 'pending':
//         return 'Pending';
//       case 'cancelled':
//         return 'Cancelled';
//       case 'cancelled_by_admin':
//         return 'Admin Cancelled';
//       default:
//         return status;
//     }
//   }

//   String _getCancellationRate() {
//     final total = analyticsData['totalBookings'] ?? 0;
//     final cancelled = analyticsData['cancelledBookings'] ?? 0;
//     if (total == 0) return '0';
//     return ((cancelled / total) * 100).toStringAsFixed(1);
//   }
// }
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
      double ticpinAppRevenue = 0;
      double directRevenue = 0;
      double advancePaymentRevenue = 0;
      double fullPaymentRevenue = 0;
      double totalHours = 0;
      Map<String, int> bookingsByDate = {};
      Map<String, double> revenueByDate = {};

      for (var doc in bookingsQuery.docs) {
        final data = doc.data();
        totalBookings++;

        final status = data['status'] ?? '';
        final amount = (data['totalAmount'] ?? 0).toDouble();
        final paymentSource = data['paymentSource'] ?? 'ticpin_app'; // Assume ticpin_app if not specified
        final paymentType = data['paymentType'] ?? 'full'; // 'advance' or 'full'

        if (status == 'confirmed') {
          confirmedBookings++;
          totalRevenue += amount;
          totalHours += (data['totalHours'] ?? 0).toDouble();

          // Track Ticpin app vs Direct revenue
          if (paymentSource == 'ticpin_app') {
            ticpinAppRevenue += amount;

            // Track payment type
            if (paymentType == 'advance') {
              advancePaymentRevenue += amount; // 30% payment
            } else {
              fullPaymentRevenue += amount; // Full payment
            }
          } else {
            directRevenue += amount;
          }
        } else if (status.contains('cancelled')) {
          cancelledBookings++;
        }

        // Track bookings by date
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        if (createdAt != null) {
          final dateKey = DateFormat('yyyy-MM-dd').format(createdAt);
          bookingsByDate[dateKey] = (bookingsByDate[dateKey] ?? 0) + 1;

          if (status == 'confirmed') {
            revenueByDate[dateKey] = (revenueByDate[dateKey] ?? 0) + amount;
          }
        }
      }

      setState(() {
        analyticsData = {
          'totalBookings': totalBookings,
          'confirmedBookings': confirmedBookings,
          'cancelledBookings': cancelledBookings,
          'totalRevenue': totalRevenue,
          'ticpinAppRevenue': ticpinAppRevenue,
          'directRevenue': directRevenue,
          'advancePaymentRevenue': advancePaymentRevenue,
          'fullPaymentRevenue': fullPaymentRevenue,
          'totalHours': totalHours,
          'averageBookingValue': confirmedBookings > 0 ? totalRevenue / confirmedBookings : 0,
          'bookingsByDate': bookingsByDate,
          'revenueByDate': revenueByDate,
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
          'Turf Analytics',
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
                  // Turf Name Header
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
                        Icon(Icons.sports_soccer, color: Colors.white, size: 32),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.turfData['name'] ?? 'Turf Analytics',
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

                  // Summary Cards
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
                        'Confirmed',
                        '${analyticsData['confirmedBookings'] ?? 0}',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      _buildStatCard(
                        'Total Hours',
                        '${(analyticsData['totalHours'] ?? 0).toStringAsFixed(1)} hrs',
                        Icons.schedule,
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

                  SizedBox(height: 16),

                  // Additional Stats
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(20),
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
                            'Average Booking Value',
                            '₹${(analyticsData['averageBookingValue'] ?? 0).toStringAsFixed(0)}',
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
                          Divider(height: 24),
                          _buildStatRow(
                            'Avg Hours per Booking',
                            '${_getAverageHours()} hrs',
                            Icons.access_time,
                            Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Revenue Trend Chart
                  if ((analyticsData['revenueByDate'] as Map?)?.isNotEmpty ?? false)
                    _buildRevenueChartCard(),

                  SizedBox(height: 16),

                  // Bookings Chart
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
                  SizedBox(height: 8),
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
    final advancePayments = analyticsData['advancePaymentRevenue'] ?? 0.0;
    final fullPayments = analyticsData['fullPaymentRevenue'] ?? 0.0;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade700, Colors.teal.shade900],
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
                      '30% Advance',
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
                      'Full Bookings',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        fontFamily: 'Regular',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹${NumberFormat('#,##,###').format(fullPayments)}',
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
            SizedBox(height: 4),
            Text(
              'Revenue generated via Ticpin app for this turf',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Regular',
              ),
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
      child: Padding(
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
                fontSize: 20,
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
              colors: [Colors.green.shade400, Colors.teal.shade600],
            ),
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400.withOpacity(0.3),
                  Colors.teal.shade600.withOpacity(0.1),
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
    final paymentSource = booking['paymentSource'] ?? 'ticpin_app';
    final paymentType = booking['paymentType'] ?? 'full';
    final amount = (booking['totalAmount'] ?? 0).toDouble();

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
                  child: Text(
                    'Booking #${booking['bookingId']?.substring(0, 8) ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Regular',
                    ),
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
                  '${booking['date']}',
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  '${booking['session']}',
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  '${booking['totalHours']} hrs',
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
                SizedBox(width: 16),
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 6),
                Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 13, fontFamily: 'Regular'),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(height: 1),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      paymentSource == 'ticpin_app' 
                          ? Icons.phone_android 
                          : Icons.store,
                      size: 16,
                      color: paymentSource == 'ticpin_app' 
                          ? Colors.blue 
                          : Colors.orange,
                    ),
                    SizedBox(width: 6),
                    Text(
                      paymentSource == 'ticpin_app' 
                          ? 'Ticpin App' 
                          : 'Direct',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: paymentSource == 'ticpin_app' 
                            ? Colors.blue 
                            : Colors.orange,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ],
                ),
                if (paymentSource == 'ticpin_app')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: paymentType == 'advance' 
                          ? Colors.amber.shade50 
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: paymentType == 'advance' 
                            ? Colors.amber.shade200 
                            : Colors.green.shade200,
                      ),
                    ),
                    child: Text(
                      paymentType == 'advance' ? '30% Advance' : 'Full Payment',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: paymentType == 'advance' 
                            ? Colors.amber.shade900 
                            : Colors.green.shade900,
                        fontFamily: 'Regular',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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
    switch (status.toLowerCase()) {
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
    if (total == 0) return '0.0';
    return ((cancelled / total) * 100).toStringAsFixed(1);
  }

  String _getAverageHours() {
    final confirmed = analyticsData['confirmedBookings'] ?? 0;
    final totalHours = analyticsData['totalHours'] ?? 0.0;
    if (confirmed == 0) return '0.0';
    return (totalHours / confirmed).toStringAsFixed(1);
  }
}