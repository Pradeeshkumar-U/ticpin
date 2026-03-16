import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/models/offer/offersummary.dart';

class OfferController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var loading = false.obs;
  var allOffers = <OfferSummary>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadActiveOffers();
  }

  Future<void> loadActiveOffers() async {
    loading.value = true;
    try {
      final snap =
          await _firestore
              .collection('offers')
              .where('status', isEqualTo: 'active')
              .get();

      allOffers.value =
          snap.docs.map((doc) => OfferSummary.fromDoc(doc)).toList();
    } catch (e) {
      print('Error loading offers: $e');
    } finally {
      loading.value = false;
    }
  }
}
