import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketCard extends StatefulWidget {
  final String bookingId;
  final String eventName;
  final String date;
  final String time;
  final String venue;
  final String seats;
  final String posterPath;
  final String qrImagePath;
  final String logoPath;

  const TicketCard({
    super.key,
    required this.bookingId,
    required this.eventName,
    required this.date,
    required this.time,
    required this.venue,
    required this.seats,
    required this.posterPath,
    required this.qrImagePath,
    required this.logoPath,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  final GlobalKey _captureKey = GlobalKey();

  /// Capture widget as image
  Future<Uint8List> _capture() async {
    // ✅ Wait until widget is fully rendered
    await WidgetsBinding.instance.endOfFrame;

    final boundary =
        _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  /// Share ticket image
  Future<void> _share() async {
    try {
      final bytes = await _capture();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.eventName} Ticket.png');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  /// Download ticket image
  // Future<void> _download() async {
  //   try {
  //     final bytes = await _capture();
  //     final dir = await getApplicationDocumentsDirectory();
  //     debugPrint("Download path: ${dir.path}");
  //     final file = File('${dir.path}/${widget.eventName} Ticket.png');
  //     await file.writeAsBytes(bytes);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Ticket saved successfully")),
  //     );
  //   } catch (e) {
  //     debugPrint("Download error: $e");
  //   }
  // }

  Future<void> _download() async {
    try {
      final bytes = await _capture();

      final dir = Directory('/storage/emulated/0/Download');
      final file = File('${dir.path}/${widget.eventName} Ticket.png');

      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Saved to Downloads")));
    } catch (e) {
      debugPrint("Download error: $e");
    }
  }

  Future<void> addToGoogleWallet(
    String ticketNumber,
    String eventName,
    String qr,
    String holderName,
  ) async {
    final res = await FirebaseFunctions.instance
        .httpsCallable('googleWalletTicket')
        .call({
          'ticketNumber': ticketNumber,
          'eventName': eventName,
          'qr': qr,
          'holderName': holderName,
        });

    final url = res.data['url'];
    if (url != null)
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> addToAppleWallet(
    String ticketNumber,
    String eventName,
    String seat,
    String qr,
  ) async {
    final res = await FirebaseFunctions.instance
        .httpsCallable('appleWalletTicket')
        .call({
          'ticketNumber': ticketNumber,
          'eventName': eventName,
          'seat': seat,
          'qr': qr,
        });

    final url = res.data['url'];
    if (url != null)
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: gradient1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: RepaintBoundary(
              key: _captureKey,
              child: AspectRatio(
                aspectRatio: 4 / 5, // ✅ MAINTAINED
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  color: gradient2.withAlpha(220),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        // ✅ scroll inside
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// TITLE
                            Image.network(
                              "https://www.ticpin.in/ticpin-logo-black.png",
                              scale: 8,
                              color: Colors.white,
                            ),
                            // Text(
                            //   "TICPIN",
                            //   style: TextStyle(
                            //     fontSize: w * 0.06,
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SizedBox(height: h * 0.03),

                            /// TOP DETAILS
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _txt(
                                        "BOOKING ID: ${widget.bookingId}",
                                        bold: true,
                                      ),
                                      _txt(widget.eventName),
                                      const SizedBox(height: 25),
                                      _txt(widget.date, bold: true),
                                      _txt(widget.time),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      widget.posterPath,
                                      height: w * 0.3,
                                      width: w * 0.26,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            /// VENUE & SEATS
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _txt("VENUE", bold: true),
                                      _txt(widget.venue),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _txt("SEATS", bold: true),
                                    _txt(widget.seats),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            /// QR CODE
                            Container(
                              height: w * 0.32,
                              width: w * 0.32,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(widget.qrImagePath),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 5),

                            /// FOOTER
                            Center(
                              child: _txt("Scan QR to Verify", bold: true),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Image.asset(
                          widget.logoPath,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ACTION BUTTONS
          Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: _share,
                color: gradient1.withOpacity(0.8),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                splashColor: gradient2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.share, size: 30, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      "Share this Ticket",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              MaterialButton(
                onPressed: _download,
                color: gradient1.withOpacity(0.8),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                splashColor: gradient2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download, size: 30, color: Colors.white),
                    SizedBox(width: 20),
                    Text(
                      "Download Ticket",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Common text widget (wrap-safe)
  Widget _txt(String text, {bool bold = false}) {
    return Text(
      text,
      softWrap: true,
      maxLines: null,
      overflow: TextOverflow.visible,
      style: TextStyle(
        fontSize: 11.5,
        color: Colors.white,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
