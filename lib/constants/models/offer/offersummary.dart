import 'package:cloud_firestore/cloud_firestore.dart';

class OfferSummary {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final num discount;
  final String status;
  final String validUntil;

  OfferSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.discount,
    required this.status,
    required this.validUntil,
  });

  factory OfferSummary.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OfferSummary(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      discount: data['discount'] ?? 0,
      status: data['status'] ?? '',
      validUntil: data['validUntil'] ?? '',
    );
  }
}
