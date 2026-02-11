import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/constant.dart';
import 'package:ticpin/constants/shapes/locationtiles.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/styles.dart';
import 'package:ticpin/pages/home/homepage.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/location_controller.dart';
import 'package:ticpin/services/places.dart';

// ignore: must_be_immutable
class Locationpage extends StatefulWidget {
  Locationpage({super.key, required this.position});
  Position position;

  @override
  State<Locationpage> createState() => _LocationpageState();
}

class _LocationpageState extends State<Locationpage> {
  String? response;
  List<CountryList> items = [];

  Position? _position;
  @override
  void initState() {
    super.initState();
    initList(tn_places);
    _determinePosition();
  }

  void initList(List<String> list) {
    items = list.map((item) => CountryList(name: item, tag: item[0])).toList();
  }

  List<AutocompletePrediction> placePred = [];

  TextEditingController _controller = TextEditingController();
  void placesAutocomplete(String query) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      'maps/api/place/autocomplete/json',
      {
        'input': query,
        // 'types': '(cities)', // restrict to cities
        'components': 'country:in', // restrict to India
        'location':
            _position == null
                ? '10.8,78.7'
                : '${_position!.latitude},${_position!.longitude}',
        'radius': '30000',
        'key': placesApiKey,
      },
    );

    response = await Places().fetchUrl(uri);
    if (response != null) {
      PlaceAutoCompleteResponse res =
          PlaceAutoCompleteResponse.parseAutoCompleteResult(response!);
      if (res.pred != null) {
        setState(() {
          placePred = res.pred!;
        });
      } else {
        setState(() {
          placePred = [];
        });
      }
    }
  }

  final tn_places = [
    'Agastheeswaram',
    'Alandur',
    'Alangudi',
    'Alangulam',
    'Alathur',
    'Ambasamudram',
    'Ambattur',
    'Ambur',
    'Aminjikarai',
    'Anaicut',
    'Anaimalai',
    'Anchetty',
    'Andimadam',
    'Annur',
    'Anthiyur',
    'Arakkonam',
    'Aranthangi',
    'Aravakurichi',
    'Arcot',
    'Ariyalur',
    'Arni',
    'Aruppukottai',
    'Athoor',
    'Attur',
    'Aundipatti',
    'Avadi',
    'Avinashi',
    'Avudaiyarkoil',
    'Ayanavaram',
    'Bargur',
    'Bhavani',
    'Bhuvanagiri',
    'Bodinayakanur',
    'Budalur',
    'Central',
    'Chengalpattu',
    'Chengam',
    'Chennai',
    'Cheranmahadevi',
    'Chetpet',
    'Cheyyar',
    'Cheyyur',
    'Chidambaram',
    'Chidhambaram',
    'Chinnaselam',
    'Coimbatore',
    'Coonoor',
    'Cuddalore',
    'Denkanikottai',
    'Devakottai',
    'Dharapuram',
    'Dharmapuri',
    'Dindigul',
    'Edappady',
    'Egmore',
    'Eral',
    'Erode',
    'Ettayapuram',
    'Ganagavalli',
    'Gandarvakottai',
    'Gingee',
    'Gobichettipalayam',
    'Gudalur',
    'Gudiyatham',
    'Guindy',
    'Gujiliamparai',
    'Gummidipoondi',
    'Harur',
    'Hosur',
    'Ilayankudi',
    'Illuppur',
    'Illupur',
    'Jamunamarathoor',
    'Kadaladi',
    'Kadavur',
    'Kadayampatti',
    'Kadayanallur',
    'Kalaiyarkovil',
    'Kalasapakkam',
    'Kalavai',
    'Kalkulam',
    'Kallakurichi',
    'Kalligudi',
    'Kalvarayan',
    'Kamuthi',
    'Kancheepuram',
    'Kandachipuram',
    'Kangeyam',
    'Kanniyakumari',
    'Karaikudi',
    'Karambakudi',
    'Karimangalam',
    'Kariyapatti',
    'Karur',
    'Katpadi',
    'Kattumannarkoil',
    'Kayathar',
    'Keelakarai',
    'Killiyoor',
    'Kilpennathur',
    'Kilvelur',
    'Kinathukadavu',
    'Kodaikanal',
    'Kodumudi',
    'Kolli',
    'Koothanallur',
    'Kotagiri',
    'Kovilpatti',
    'Kovilpatty',
    'Krishnagiri',
    'Krishnarayapuram',
    'Kudavasal',
    'Kulathur',
    'Kulithalai',
    'Kumarapalayam',
    'Kumbakonam',
    'Kundah',
    'Kundrathur',
    'Kunnam',
    'Kuppam',
    'Kurinjipadi',
    'Kuthalam',
    'Lalgudi',
    'Madathukkulam',
    'Madhavaram',
    'Madhurantakam',
    'Madukarai',
    'Madurai',
    'Madurandagam',
    'Maduravoyal',
    'Mambalam',
    'Manamadurai',
    'Manamelkudi',
    'Manapparai',
    'Manmangalam',
    'Mannachanallur',
    'Mannargudi',
    'Manur',
    'Marakkanam',
    'Marungapuri',
    'Mayiladuthurai',
    'Melmalaiyanur',
    'Melur',
    'Mettupalayam',
    'Mettur',
    'Modakkurichi',
    'Mohanur',
    'Mudukulathur',
    'Musiri',
    'Muthupettai',
    'Mylapore',
    'Nagapattinam',
    'Nagercoil',
    'Nallampalli',
    'Namakkal',
    'Nambiyur',
    'Nanguneri',
    'Nannilam',
    'Natham',
    'Natrampalli',
    'Needamangalam',
    'Nemili',
    'Nilakottai',
    'Nilgiris',
    'Oddenchatram',
    'Omalur',
    'Orathanad',
    'Ottapidaram',
    'Padmanabhapuram',
    'Palacode',
    'Palani',
    'Palayamkottai',
    'Palladam',
    'Pallavaram',
    'Pallipattu',
    'Pandalur',
    'Panruti',
    'Papanasam',
    'Pappireddipatti',
    'Paramakudi',
    'Paramathi',
    'Pattukottai',
    'Pennagaram',
    'Peraiyur',
    'Perambalur',
    'Perambur',
    'Peravurani',
    'Periyakulam',
    'Pernambut',
    'Perundurai',
    'Perur',
    'Pethanaickenpalayam',
    'Pettai',
    'Pochampalli',
    'Pollachi',
    'Polur',
    'Ponnamaravathi',
    'Ponneri',
    'Poonamallee',
    'Pudukkottai',
    'Pugalur',
    'Pursawalkam',
    'Radhapuram',
    'Rajapalayam',
    'Rajasingamangalam',
    'Ramanathapuram',
    'Rameswaram',
    'Ranipet',
    'Rasipuram',
    'Salem',
    'Sankarankovil',
    'Sankarapuram',
    'Sankari',
    'Sathyamangalam',
    'Sattankulam',
    'Sattur',
    'Sendamangalam',
    'Sendurai',
    'Shencottai',
    'Sholinganallur',
    'Sholingur',
    'Shoolagiri',
    'Singampunari',
    'Sirkazhi',
    'Sivaganga',
    // 'Sivagangai',
    'Sivagiri',
    'Sivakasi',
    'Srimushnam',
    'Sriperumbudur',
    'Srirangam',
    'Srivaikundam',
    'Srivlliputhur',
    'Sulur',
    'Tambaram',
    'Tenkasi',
    'Thalaivasal',
    'Thalavadi',
    'Thandrampet',
    'Thanjavur',
    'Tharangambadi',
    'Theni',
    'Thiruchirapalli-West',
    'Thiruchirappalli',
    'Thirukkalukundram',
    'Thirukkuvalai',
    'Thirumangalam',
    'Thirumayam',
    'Thirupathur',
    // 'Thirupattur',
    'Thirupparankundram',
    'Thirupporur',
    'Thiruppuvanam',
    'Thiruthuraipoondi',
    'Thiruvadani',
    'Thiruvaiyaru',
    'Thiruvarur',
    'Thiruvattar',
    'Thiruvengadam',
    'Thiruvennainallur',
    'Thiruverumbur',
    'Thiruvidaimaruthur',
    'Thiruvonam',
    'Thiruvottiyur',
    'Thoothukudi',
    'Thottiam',
    'Thovalai',
    'Thuraiyur',
    'Tindivanam',
    'Tiruchendur',
    'Tiruchengode',
    // 'Tiruchengodu',
    'Tiruchirappalli',
    'Tiruchuli',
    'Tirukkoilur',
    // 'Tirukoilur',
    'Tirunelveli',
    'Tirupattur',
    'Tiruppur',
    'Tiruttani',
    'Tiruvallur',
    'Tiruvannamalai',
    'Tisayanvilai',
    'Titagudi',
    'Tondiarpet',
    'Trichy',
    'Udayarpalayam',
    'Udhagai',
    'Udumalpet',
    'Ulundurpet',
    'Usilampatti',
    'Uthamapalayam',
    'Uthangarai',
    'Uthiramerur',
    'Uthukkuli',
    'Uthukottai',
    'V.K.Pudur',
    'Vadipatti',
    'Valangaiman',
    'Valapady',
    'Valparai',
    'Vanapuram',
    'Vandalur',
    'Vandavasi',
    'Vaniyambadi',
    'Vanur',
    'Vedaranyam',
    'Vedasandur',
    'Velachery',
    'Vellore',
    'Velur',
    'Vembakkam',
    'Vembakkottai',
    'Veppanthattai',
    'Veppur',
    'Vikkiravandi',
    'Vilathikulam',
    'Vilavancode',
    'Viluppuram',
    'Viralimalai',
    'Virudhunagar',
    'Vridhachalam',
    'Walajabad',
    'Walajah',
    'Watrap',
    'Yercaud',
  ];

  String? _address;
  bool _loading = false;

  String? place = '';

  /// Get permission and current location
  void _determinePosition() async {
    _position = widget.position;
  }

  void _showCityDialog(String? city) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("City Found"),
            content: Text("Your current city is $city"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(
                    context,
                    city,
                  ); // Go back to previous page with city
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(
                    context,
                    city,
                  ); // Go back to previous page with city
                },
                child: Text("Continue"),
              ),
            ],
          ),
    );
  }

  /// Get current address using Places API
  // Future<void> _getCurrentAddress() async {
  //   setState(() => _loading = true);
  //   try {
  //     final result = await getCityFromCoords(
  //       _position!.latitude,
  //       _position!.longitude,
  //     );

  //     setState(() {
  //       _address = result ?? 'No address found';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _address = 'Error: $e';
  //     });
  //   } finally {
  //     setState(() => _loading = false);
  //   }
  // }
  final eventController = Get.find<EventController>();
  final locationController = Get.find<LocationController>();

  Sizes size = Sizes();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          surfaceTintColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: defaultPadding),
            child: GestureDetector(
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                size: size.safeWidth * 0.08,
              ),
              onTap: () => Get.back(),
            ),
          ),
          title: Text(
            'Location',
            style: TextStyle(
              fontSize: size.safeWidth * 0.045,
              fontFamily: 'Regular',
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: size.safeWidth * 0.9,
              height: size.safeHeight * 0.07,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.safeWidth * 0.04),
                    child: Icon(CupertinoIcons.search, size: size.width * 0.06),
                  ),
                  SizedBox(
                    width: size.safeWidth * 0.75,

                    // height: size.safeHeight * 0.07,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: blackColor,
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {
                            placePred = [];
                          });
                          placesAutocomplete(value);
                        },
                        style: TextStyle(
                          // fontSize: size.safeWidth * 0.04,
                          color: Colors.black,
                          fontFamily: 'Regular',
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            // vertical: 16,
                          ),

                          hintText: "Search your location",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: size.safeWidth * 0.05),
            //   child: Container(
            //     height: size.safeHeight * 0.063,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(13),
            //       border: Border.all(color: Colors.black26, width: 1),
            //     ),
            //     child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: TextField(
            //         textCapitalization: TextCapitalization.sentences,
            //         cursorColor: blackColor,
            //         controller: _controller,
            //         textAlign: TextAlign.start, // Start alignment when typing
            //         onChanged: (value) {
            //           setState(() {
            //             placePred = [];
            //           });
            //           placesAutocomplete(value);
            //         },
            //         style: TextStyle(fontFamily: 'Regular'),
            //         textInputAction: TextInputAction.search,
            //         decoration: InputDecoration(
            //           isCollapsed: true,
            //           border: InputBorder.none,
            //           hintText: "Search your location",
            //           hintStyle: TextStyle(fontFamily: 'Regular'),
            //           prefixIcon: Icon(CupertinoIcons.search, size: 20),
            //           contentPadding: EdgeInsets.symmetric(vertical: 14),
            //           isDense: true,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.safeWidth * 0.05,
                vertical: size.safeWidth * 0.05,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  locationController.manualLocationSelected = false;
                  locationController.city.value = "";
                  Get.off(Homepage());
                },

                style: ElevatedButton.styleFrom(
                  // splashFactory: NoSplash.splashFactory,
                  backgroundColor: greyColor.withAlpha(30),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  // foregroundColor: Colors.transparent,
                  // surfaceTintColor: Colors.transparent,
                  enableFeedback: false,
                  overlayColor: Colors.transparent,
                  fixedSize: Size(size.safeWidth * 0.9, size.safeWidth * 0.11),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/icons/location.svg",
                          height: 19,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.safeWidth * 0.03,
                          ),
                          child: Text(
                            "Use my Current Location",
                            style: TextStyle(
                              fontFamily: 'Regular',
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        // horizontal: size.safeWidth * 0.01,
                      ),
                      child: Icon(
                        Icons.navigate_next,
                        size: size.safeWidth * 0.065,
                        color: blackColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _controller.text.isEmpty
                ? Expanded(
                  child: AzListView(
                    indexBarAlignment: Alignment.centerRight,
                    data: items,
                    itemCount: items.length,
                    indexBarOptions: IndexBarOptions(
                      indexHintAlignment: Alignment.centerRight,
                      needRebuild: true,
                    ),
                    itemBuilder: (context, index) {
                      final p = items[index].name;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              minTileHeight: Sizes().height * 0.05,
                              onTap: () {
                                locationController.setUserCity(
                                  "$p, Tamil Nadu",
                                );
                                eventController.loadAllEvents();
                                Get.off(Homepage(fromLoc: '$p, Tamilnadu'));
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashColor: Colors.transparent,
                              selectedTileColor: Colors.transparent,
                              selectedColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              horizontalTitleGap: 0,
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.location_on_outlined),
                                ),
                              ),
                              // subtitle: Padding(
                              //   padding: EdgeInsets.only(
                              //     left: Sizes().width * 0.03,
                              //   ),
                              //   child: Text(
                              //     p.structuredFormatting?.secondaryText!
                              //             .replaceAll(', India', '') ??
                              //         '',
                              //     maxLines: 2,
                              //     overflow: TextOverflow.ellipsis,
                              //     style: TextStyle(
                              //       fontFamily: 'Regular',
                              //       fontSize: size.safeWidth * 0.03,
                              //     ),
                              //   ),
                              // ),
                              title: Padding(
                                padding: EdgeInsets.only(
                                  left: Sizes().width * 0.03,
                                ),
                                child: Text(
                                  p,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: size.safeWidth * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                            indent: Sizes().width * 0.05,
                            endIndent: Sizes().width * 0.05,
                            // color: blackColor,
                            color: Color(
                              0xFFF5F5F5,
                            ), // Use a light color for the divider
                          ),
                        ],
                      );
                    },
                  ),
                )
                : Expanded(
                  child: ListView.builder(
                    itemCount: placePred.length,
                    itemBuilder: (context, index) {
                      final p = placePred[index];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              minTileHeight: Sizes().height * 0.05,
                              onTap: () {
                                final fullCity =
                                    "${p.structuredFormatting?.mainText}, ${p.structuredFormatting?.secondaryText}";

                                locationController.setUserCity(fullCity);
                                eventController.loadAllEvents();

                                Get.off(
                                  Homepage(
                                    fromLoc:
                                        '${p.structuredFormatting?.mainText}, ${p.structuredFormatting?.secondaryText!.replaceAll(', India', '')}',
                                    address:
                                        '${p.structuredFormatting?.mainText}, ${p.structuredFormatting?.secondaryText}',
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashColor: Colors.transparent,
                              selectedTileColor: Colors.transparent,
                              selectedColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              horizontalTitleGap: 0,
                              leading: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black54,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.location_on_outlined),
                                ),
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.only(
                                  left: Sizes().width * 0.03,
                                ),
                                child: Text(
                                  p.structuredFormatting?.secondaryText!
                                          .replaceAll(', India', '') ??
                                      '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: size.safeWidth * 0.03,
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: EdgeInsets.only(
                                  left: Sizes().width * 0.03,
                                ),
                                child: Text(
                                  p.structuredFormatting?.mainText ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Medium',
                                    fontSize: size.safeWidth * 0.035,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                            indent: Sizes().width * 0.05,
                            endIndent: Sizes().width * 0.05,
                            // color: blackColor,
                            color: Color(
                              0xFFF5F5F5,
                            ), // Use a light color for the divider
                          ),
                        ],
                      );
                    },
                  ),
                ),
            // LocationListTile(
            //   press: () {},
            //   location:

            // ),
            // Center(
            //   child: Text(
            //     response != null ? response! : "Banasree, Dhaka, Bangladesh",
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
