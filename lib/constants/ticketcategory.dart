import 'package:cloud_firestore/cloud_firestore.dart';

class TicketCategory {
  final String id;
  final String type;
  final double price;
  final int quantity;
  final String seatingType;
  final DateTime bookingCutoff;
  final List<String> inclusions;

  TicketCategory({
    required this.id,
    required this.type,
    required this.price,
    required this.quantity,
    required this.seatingType,
    required this.bookingCutoff,
    required this.inclusions,
  });

  /// ✅ Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'price': price,
      'quantity': quantity,
      'seatingType': seatingType,
      'bookingCutoff': Timestamp.fromDate(bookingCutoff),
      'inclusions': inclusions,
    };
  }

  /// ✅ Create from Firestore map
  factory TicketCategory.fromMap(Map<String, dynamic> map) {
    // Safely handle Timestamp, DateTime, or String
    DateTime cutoff;
    final rawCutoff = map['bookingCutoff'];
    if (rawCutoff is Timestamp) {
      cutoff = rawCutoff.toDate();
    } else if (rawCutoff is DateTime) {
      cutoff = rawCutoff;
    } else if (rawCutoff is String) {
      cutoff = DateTime.tryParse(rawCutoff) ?? DateTime.now();
    } else {
      cutoff = DateTime.now();
    }

    // Safe parsing for price
    double parsedPrice = 0;
    final rawPrice = map['price'];
    if (rawPrice is int)
      parsedPrice = rawPrice.toDouble();
    else if (rawPrice is double)
      parsedPrice = rawPrice;
    else if (rawPrice is String)
      parsedPrice = double.tryParse(rawPrice) ?? 0;

    // Safe parsing for quantity
    int parsedQty = 0;
    final rawQty = map['quantity'];
    if (rawQty is int)
      parsedQty = rawQty;
    else if (rawQty is double)
      parsedQty = rawQty.toInt();
    else if (rawQty is String)
      parsedQty = int.tryParse(rawQty) ?? 0;

    // Safe parsing for inclusions
    List<String> inclusions = [];
    final rawInclusions = map['inclusions'];
    if (rawInclusions is List) {
      inclusions = rawInclusions.map((e) => e.toString()).toList();
    }

    return TicketCategory(
      id: map['id']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      price: parsedPrice,
      quantity: parsedQty,
      seatingType: map['seatingType']?.toString() ?? 'standing',
      bookingCutoff: cutoff,
      inclusions: inclusions,
    );
  }
}
