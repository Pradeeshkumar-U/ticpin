import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:azlistview/azlistview.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:get/get.dart';
import 'package:ticpin/constants/colors.dart';
import 'package:ticpin/constants/size.dart';
import 'package:ticpin/constants/glass_container.dart';
import 'package:ticpin/services/controllers/event_controller.dart';
import 'package:ticpin/services/controllers/location_controller.dart';
import 'package:ticpin/pages/home/homepage.dart';
import 'package:ticpin/services/places.dart';
import 'package:geolocator/geolocator.dart';

class CityModel extends ISuspensionBean {
  final String name;
  String? tag;

  CityModel({required this.name, this.tag});

  @override
  String getSuspensionTag() => tag!;
}

class Locationpage extends StatefulWidget {
  final Position position;
  const Locationpage({super.key, required this.position});

  @override
  State<Locationpage> createState() => _LocationpageState();
}

class _LocationpageState extends State<Locationpage> {
  final TextEditingController _controller = TextEditingController();
  List<AutocompletePrediction> placePred = [];
  List<CityModel> items = [];
  final locationController = Get.find<LocationController>();
  final eventController = Get.find<EventController>();
  Sizes size = Sizes();

  final List<String> tn_places = [
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
    'Tiruchirappalli',
    'Tiruchuli',
    'Tirukkoilur',
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

  @override
  void initState() {
    super.initState();
    initList(tn_places);
  }

  void initList(List<String> list) {
    items =
        list.map((e) {
          return CityModel(name: e, tag: e[0].toUpperCase());
        }).toList();
    SuspensionUtil.sortListBySuspensionTag(items);
    SuspensionUtil.setShowSuspensionStatus(items);
  }

  Future<void> placesAutocomplete(String query) async {
    if (query.isEmpty) {
      if (mounted) setState(() => placePred = []);
      return;
    }
    final response = await Places().getAutocomplete(query);
    if (mounted) {
      setState(() {
        placePred = response.pred ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Platform.isIOS ? Colors.black : whiteColor,
        appBar: AppBar(
          backgroundColor: Platform.isIOS ? Colors.black : whiteColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GestureDetector(
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                size: size.safeWidth * 0.08,
                color: Platform.isIOS ? whiteColor : Colors.black,
              ),
              onTap: () => Get.back(),
            ),
          ),
          title: Text(
            'Location',
            style: TextStyle(
              fontSize: size.safeWidth * 0.045,
              fontFamily: 'Regular',
              color: Platform.isIOS ? whiteColor : Colors.black,
            ),
          ),
        ),
        body: Stack(
          children: [
            if (Platform.isIOS)
              Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [gradient1, gradient2, Colors.black],
                  ),
                ),
              ),
            Column(
              children: [
                const SizedBox(height: 10),
                _buildSearchBar(),
                _buildCurrentLocationButton(),
                _controller.text.isEmpty
                    ? _buildAzList()
                    : _buildPredictionList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Center(
      child: TicpinGlassContainer(
        width: size.safeWidth * 0.9,
        height: size.safeHeight * 0.07,
        borderRadius: 13,
        child: Container(
          height: size.safeHeight * 0.07,
          decoration: BoxDecoration(
            border: Border.all(
              color: Platform.isIOS ? Colors.white24 : Colors.black26,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: size.safeWidth * 0.04),
                child: Icon(
                  CupertinoIcons.search,
                  size: size.width * 0.06,
                  color: Platform.isIOS ? whiteColor : Colors.black54,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Platform.isIOS ? whiteColor : blackColor,
                  style: TextStyle(
                    color: Platform.isIOS ? whiteColor : Colors.black,
                    fontFamily: 'Regular',
                  ),
                  onChanged: (value) {
                    setState(() => placePred = []);
                    placesAutocomplete(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    hintText: "Search your location",
                    hintStyle: TextStyle(
                      color: Platform.isIOS ? Colors.white54 : Colors.black38,
                      fontFamily: 'Regular',
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLocationButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.safeWidth * 0.05,
        vertical: size.safeWidth * 0.05,
      ),
      child: TicpinGlassContainer(
        width: size.safeWidth * 0.9,
        height: size.safeWidth * 0.11,
        borderRadius: 10,
        child: ElevatedButton(
          onPressed: () async {
            locationController.manualLocationSelected = false;
            locationController.city.value = "";
            Get.off(() => Homepage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Platform.isIOS
                    ? Colors.white.withOpacity(0.1)
                    : greyColor.withAlpha(30),
            elevation: 0,
            fixedSize: Size(size.safeWidth * 0.9, size.safeWidth * 0.11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
                    colorFilter: ColorFilter.mode(
                      Platform.isIOS ? whiteColor : blackColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.safeWidth * 0.03,
                    ),
                    child: Text(
                      "Use my Current Location",
                      style: TextStyle(
                        fontFamily: 'Regular',
                        color: Platform.isIOS ? whiteColor : blackColor,
                      ),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.navigate_next,
                size: size.safeWidth * 0.065,
                color: Platform.isIOS ? whiteColor : blackColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAzList() {
    return Expanded(
      child: AzListView(
        data: items,
        itemCount: items.length,
        indexBarOptions: IndexBarOptions(
          textStyle: TextStyle(
            color: Platform.isIOS ? whiteColor : Colors.black54,
            fontSize: 10,
          ),
          indexHintTextStyle: const TextStyle(fontSize: 24, color: whiteColor),
          indexHintDecoration: BoxDecoration(
            color: gradient1,
            shape: BoxShape.circle,
          ),
        ),
        itemBuilder: (context, index) {
          final p = items[index].name;
          return _buildLocationTile(
            title: p,
            onTap: () {
              locationController.setUserCity("$p, Tamil Nadu");
              eventController.loadAllEvents();
              Get.off(() => Homepage(fromLoc: '$p, Tamilnadu'));
            },
          );
        },
      ),
    );
  }

  Widget _buildPredictionList() {
    return Expanded(
      child: ListView.builder(
        itemCount: placePred.length,
        itemBuilder: (context, index) {
          final p = placePred[index];
          final mainText = p.structuredFormatting?.mainText ?? '';
          final secondaryText =
              p.structuredFormatting?.secondaryText?.replaceAll(
                ', India',
                '',
              ) ??
              '';
          return _buildLocationTile(
            title: mainText,
            subtitle: secondaryText,
            onTap: () {
              final fullCity =
                  "$mainText, ${p.structuredFormatting?.secondaryText}";
              locationController.setUserCity(fullCity);
              eventController.loadAllEvents();
              Get.off(
                () => Homepage(
                  fromLoc: '$mainText, $secondaryText',
                  address: fullCity,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLocationTile({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Platform.isIOS ? Colors.white24 : Colors.black54,
              ),
              color:
                  Platform.isIOS
                      ? Colors.white.withOpacity(0.05)
                      : Colors.transparent,
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: Platform.isIOS ? whiteColor : Colors.black,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Medium',
              fontSize: size.safeWidth * 0.038,
              color: Platform.isIOS ? whiteColor : Colors.black,
            ),
          ),
          subtitle:
              subtitle != null
                  ? Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: size.safeWidth * 0.032,
                      color: Platform.isIOS ? Colors.white70 : Colors.black54,
                    ),
                  )
                  : null,
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Platform.isIOS ? Colors.white38 : Colors.grey.shade400,
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          indent: size.safeWidth * 0.05,
          endIndent: size.safeWidth * 0.1,
          color: Platform.isIOS ? Colors.white10 : const Color(0xFFF5F5F5),
        ),
      ],
    );
  }
}
