import 'dart:math' as math;

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/view/home/filtering_screen.dart';
import 'package:event_app/app/view/home/tab/tab_maps.dart';
import 'package:event_app/app/view/popular_event/popular_event_list.dart';
import 'package:event_app/app/view/trending/trending_screen.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/constant.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:evente/evente.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../dialog/loading_cards.dart';
import '../../../provider/event_provider.dart';
import '../../../provider/sign_in_provider.dart';
import '../../../widget/empty_screen.dart';
import '../../featured_event/featured_event_detail2.dart';
import '../../notification/notification_screen.dart';
import '../search_screen.dart';

class showCaseHome extends StatefulWidget {
  const showCaseHome({super.key});

  @override
  State<showCaseHome> createState() => _showCaseHomeState();
}

class _showCaseHomeState extends State<showCaseHome> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) => TabHome()),
    );
  }
}

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  List<ModalPopularEvent> popularEventLists = DataFile.popularEventList;
  List<ModalFeatureEvent> featureEventLists = DataFile.featureEventList;
  String? mtoken;
  DateTime now = DateTime.now();

  Position? userPosition;
  late List<EventBaru> nearbyEvents = [];

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    final SignInProvider sb = context.read<SignInProvider>();
    await FirebaseFirestore.instance.collection("UserTokens").doc(sb.uid).set({
      'token': token,
    });

    print("INI TOKENNYA");
    print(sb.uid);
  }

  Future<List<EventBaru>> fetchEventsNearby(
      double latitude, double longitude) async {
    List<EventBaru> Events = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('event').get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      double EventLatitude =
          (doc.data() as Map<String, dynamic>)['mapsLatLink'] as double? ?? 0.0;
      double EventLongitude =
          (doc.data() as Map<String, dynamic>)['mapsLangLink'] as double? ??
              0.0;

      double distance =
          calculateDistance(latitude, longitude, EventLatitude, EventLongitude);

      if (distance < 50000000000000.0) {
        // Misalnya, tampilkan Event yang berjarak kurang dari 10 km dari lokasi pengguna.
        Events.add(EventBaru.fromFirestore(doc, distance));
      }
    }
    return Events;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Implementasikan perhitungan jarak antara dua koordinat geografis di sini (misalnya, menggunakan haversine formula).
    // Anda dapat mencari library yang sesuai atau mengimplementasikan sendiri.
    const double earthRadius = 6371.0; // Radius Bumi dalam km
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    final double a = (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        (math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2));
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final double distance = earthRadius * c;
    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  void initState() {
    super.initState();

    getToken();
    getFromSharedPreferences();
    if (this.mounted) {
      context.read<EventProvider>().data.isNotEmpty
          ? print('data already loaded')
          : context.read<EventProvider>().getDataPopular(mounted);
    }
    if (this.mounted) {
      context.read<EventProvider>().data2.isNotEmpty
          ? print('data already loaded 2')
          : context.read<EventProvider>().getDataTrending(mounted);
    }
    checkAndRequestLocationPermission();
    getUserLocation().then((position) {
      setState(() {
        userPosition = position;
      });
      fetchEventsNearby(userPosition!.latitude, userPosition!.longitude)
          .then((Events) {
        Events.sort((a, b) => a.distance!.compareTo(b.distance as num));
        setState(() {
          nearbyEvents = Events;
        });
      });
    });
  }

  Future<Position> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> checkAndRequestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isDenied) {
      // Menampilkan pesan mengapa izin diperlukan
      requestLocationPermission();
    } else if (status.isPermanentlyDenied) {
      // Pengguna telah menolak izin secara permanen
      // Anda dapat memberikan pilihan untuk membuka pengaturan aplikasi lagi atau menutup aplikasi.
      requestLocationPermission();
    }
  }

  Future<void> requestLocationPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasPermission = prefs.getBool('hasLocationPermission') ?? false;

    if (hasPermission == false) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Container(
                  color: Colors.white,
                  height: 480,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/location.gif',
                        width: double.infinity,
                        height: 200.0,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Location Permission",
                        style: TextStyle(
                            fontSize: 16 + 1,
                            fontWeight: FontWeight.w800,
                            fontFamily: "RedHat"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "This app collects location data to enable access location to allow location for show near event, when the app is closed not in use.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black26,
                            fontFamily: "RedHat"),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                await Permission.location.request();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                              ),
                              onPressed: () async {
                                await Permission.location.request();
                                prefs.setBool('hasLocationPermission', true);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  DateTime getStartOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  DateTime getEndOfMonth() {
    final now = DateTime.now();
    final startOfNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    return startOfNextMonth.subtract(Duration(days: 1));
  }

  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      role = prefs.getString("role");
    });
  }

  String? role;
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final startOfMonth = getStartOfMonth();
    final endOfMonth = getEndOfMonth();

    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcaseVisibilityStatus = preferences.getBool("homeShowcasesssss");

      if (showcaseVisibilityStatus == null) {
        preferences.setBool("homeShowcasesssss", false).then((bool success) {
          if (success)
            print("Successfull in writing showshoexase");
          else
            print("some bloody problem occured");
        });

        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([
          _one,
          _two,
          _three,
          _four,
          _five,
        ]);
      }
    });

    final cb = context.watch<EventProvider>();
    final sb = context.watch<SignInProvider>();
    setStatusBarColor(Colors.white);
    return KeysToBeInherited(
      notification: _one,
      search: _two,
      filter: _three,
      nearby: _four,
      country: _five,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: ListView(
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    Stack(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      'assets/images/background.jpg',
                                    ),
                                    fit: BoxFit.cover)),
                            child: Column(children: [
                              const SizedBox(
                                height: 35.0,
                              ),
                              getPaddingWidget(
                                EdgeInsets.only(left: 20.h, right: 20.0),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // ignore: prefer_const_constructors
                                            Text(
                                              ('Welcome Back!').tr(),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Gilroy',
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            SvgPicture.asset(
                                              'assets/images/ic_waving_hand.svg',
                                              width: 15.0,
                                              height: 15.0,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          sb.name ?? '',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'Gilroy',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Showcase(
                                      key: _one,
                                      description:
                                          "Information all notifications",
                                      child: Container(
                                        height: 50.h,
                                        width: 50.h,
                                        margin: EdgeInsets.only(
                                            top: 18.h, right: 20.h),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 13.h, horizontal: 13.h),
                                        decoration: BoxDecoration(
                                            color: lightColor,
                                            borderRadius:
                                                BorderRadius.circular(22.h)),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (_, __,
                                                              ___) =>
                                                          NotificationScreen()));

                                              // Constant.sendToNext(context, Routes.notificationScreenRoute);
                                            },
                                            child: getSvg("notification.svg",
                                                height: 24.h, width: 24.h)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              getVerSpace(63.h),
                              getVerSpace(4.h),
                            ])),
                        Padding(
                          padding: const EdgeInsets.only(top: 130.0),
                          child: Showcase(
                              key: _two,
                              description: "Click here to search hotels",
                              child: Row(
                                children: [
                                  Expanded(
                                    child: getPaddingWidget(
                                        EdgeInsets.symmetric(horizontal: 20.h),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                PageRouteBuilder(
                                                    pageBuilder: (_, __, ___) =>
                                                        SearchPage()));
                                            // FilterScreen
                                          },
                                          child: Container(
                                            height: 50.0,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                getHorSpace(18.h),
                                                getSvg("search.svg",
                                                    height: 24.h, width: 24.h),
                                                getHorSpace(18.h),
                                                Text(
                                                  "Search events",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontFamily: 'Gilroy'),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            PageRouteBuilder(
                                                pageBuilder: (_, __, ___) =>
                                                    FilterScreen()));
                                      },
                                      child: Showcase(
                                        key: _three,
                                        description: 'Filter event by category',
                                        child: Container(
                                          height: 47.0,
                                          width: 47.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50.0)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: getSvg("filter.svg",
                                                height: 24.h, width: 24.h),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),

                    getVerSpace(30.h),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => showCaseMaps(),
                          ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getCustomFont(
                                ("Nearby Events").tr(), 20.sp, Colors.black, 1,
                                fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                            Row(
                              children: [
                                getCustomFont(
                                    ("View maps").tr(), 15.sp, greyColor, 1,
                                    fontWeight: FontWeight.w500,
                                    txtHeight: 1.5.h),
                                SizedBox(
                                  width: 5.0,
                                ),
                                getSvg("map.svg",
                                    height: 24.h,
                                    width: 24.h,
                                    color: greyColor),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    getVerSpace(10.h),
                    Container(
                      height: 198.h,
                      child: nearbyEvents == null
                          ? ListView.builder(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return LoadingCard(
                                  height: 200.0,
                                );
                              },
                            )
                          : nearbyEvents.isEmpty
                              ? ListView.builder(
                                  itemCount: 5,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return LoadingCard(
                                      height: 200.0,
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: nearbyEvents.take(5).length ?? 0,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final hotel = nearbyEvents[index];
                                    return buildNearHotelList(
                                      hotel: hotel,
                                    );
                                  },
                                ),

                      //  StreamBuilder(
                      //    stream: FirebaseFirestore.instance
                      //        .collection("event")
                      //       //  .where('date',
                      //       //      isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
                      //       //  .orderBy('date', descending: false)
                      //        .limit(10)
                      //        .snapshots(),
                      //    builder: (BuildContext ctx,
                      //        AsyncSnapshot<QuerySnapshot> snapshot) {
                      //      if (snapshot.connectionState == ConnectionState.waiting) {
                      //        return loadingCard(ctx);
                      //      }

                      //      if (snapshot.data!.docs.isEmpty) {
                      //        return Center(child: Column(
                      //                mainAxisAlignment: MainAxisAlignment.center,
                      //                crossAxisAlignment: CrossAxisAlignment.center,
                      //                children: [

                      //     Container(
                      //              decoration: BoxDecoration(
                      //                  color: lightColor,
                      //                  borderRadius: BorderRadius.circular(187.h)),
                      //              padding: EdgeInsets.all(10.h),
                      //              child: getAssetImage("empty.png",
                      //              height: 100.0,
                      //                   width: 134.h,boxFit: BoxFit.cover),
                      //            ),
                      //            getCustomFont(
                      //                ("Not have upcoming events").tr(), 16.sp, Colors.black, 1,
                      //                fontWeight: FontWeight.w500, txtHeight: 1.5.h),

                      //                ],
                      //              ));
                      //      }
                      //      if (snapshot.hasError) {
                      //        return Center(child: Text('Error'));
                      //      }

                      //      // return loadingCard(ctx);
                      //                      return        snapshot.hasData
                      //          ? TrendingEventCard2(list: snapshot.data?.docs,)
                      //           // buildFeatureEventList(
                      //           //    list: snapshot.data?.docs,
                      //           //  )
                      //          : Container();
                      //    },
                      //  ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCustomFont(
                              ("Upcoming Events").tr(), 20.sp, Colors.black, 1,
                              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      FeaturedEvent2Detail()));

                              // Constant.sendToNext(
                              //     context, Routes.featureEventListRoute);
                            },
                            child: getCustomFont(
                                ("View All").tr(), 15.sp, greyColor, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          )
                        ],
                      ),
                    ),
                    // if (role == "users") const Text("dsadsadsadasdsa"),
                    getVerSpace(0.h),

                    Showcase(
                      key: _four,
                      description: 'Filtering upcoming events',
                      child: Container(
                        height: 224.h,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("event")
                              .where('date',
                                  isGreaterThanOrEqualTo:
                                      Timestamp.fromDate(DateTime.now()))
                              .orderBy('date', descending: false)
                              .limit(10)
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return loadingCard(ctx);
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: lightColor,
                                        borderRadius:
                                            BorderRadius.circular(187.h)),
                                    padding: EdgeInsets.all(10.h),
                                    child: getAssetImage("empty.png",
                                        height: 100.0,
                                        width: 134.h,
                                        boxFit: BoxFit.cover),
                                  ),
                                  getCustomFont(
                                      ("Not have upcoming events").tr(),
                                      16.sp,
                                      Colors.black,
                                      1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                ],
                              ));
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error'));
                            }

                            // return loadingCard(ctx);
                            return snapshot.hasData
                                ? buildFeatureEventList(
                                    list: snapshot.data?.docs,
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ),
                    // buildFeatureEventList(context),
                    getVerSpace(24.h),

                    getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCustomFont(("Choose by Category").tr(), 20.sp,
                              Colors.black, 1,
                              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      TrendingScreen()));

                              // Constant.sendToNext(
                              //     context, Routes.trendingScreenRoute);
                            },
                            child: getCustomFont(
                                ("View All").tr(), 15.sp, greyColor, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          )
                        ],
                      ),
                    ),
                    getVerSpace(12.h),
                    Showcase(
                      key: _five,
                      description:
                          'Information effectively filtering events by category.',
                      child: Container(
                        height: 350.0,
                        child: DefaultTabController(
                          length: 13,
                          child: Scaffold(
                            backgroundColor: Colors.white,
                            appBar: PreferredSize(
                              preferredSize: const Size.fromHeight(
                                  45.0), // here the desired height
                              // ignore: unnecessary_new
                              child: new AppBar(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0,
                                  centerTitle: false,
                                  automaticallyImplyLeading: false,
                                  leadingWidth: 0.0,
                                  title: TabBar(
                                    tabAlignment: TabAlignment.start,
                                    padding: EdgeInsets.all(0.0),
                                    isScrollable: true,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    unselectedLabelColor: Colors.black,
                                    labelColor: Colors.white,
                                    labelStyle: const TextStyle(fontSize: 19.0),
                                    indicatorPadding: EdgeInsets.all(0),

                                    // ignore: unnecessary_new
                                    // ignore: prefer_const_constr
                                    indicator: BubbleTabIndicator(
                                      indicatorHeight: 45.0,
                                      indicatorColor: accentColor,
                                      padding: EdgeInsets.all(0.0),
                                      // insets: EdgeInsets.only(left:14,right: 10.0),
                                      tabBarIndicatorSize:
                                          TabBarIndicatorSize.tab,
                                    ),
                                    tabs: <Widget>[
                                      // ignore: unnecessary_new
                                      new Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                ("All").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_7_swimming.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Swimming").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_8_game.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Game").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_9_fotball.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Football").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_10_comedy.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Comedy").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),

                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_11_konser.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Konser").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),

                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_12_trophy.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Trophy").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),

                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_1_tour.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Tour").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_2_festival.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Festival").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_3_study.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Study").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_4_party.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Party").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),

                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_5_olympic.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Olympic").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Tab(
                                        child: Container(
                                          height: 47.h,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2.0,
                                                            bottom: 2.0),
                                                    child: Container(
                                                      height: 44.h,
                                                      width: 44.h,
                                                      decoration: BoxDecoration(
                                                          color: lightAccent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.h)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 9.h,
                                                              vertical: 9.h),
                                                      child: getAssetImage(
                                                          "i_6_culture.png",
                                                          height: 26.h,
                                                          width: 26.h),
                                                    ),
                                                  ),
                                                  getHorSpace(6.h),
                                                ],
                                              ),
                                              Text(
                                                ("Culture").tr(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constant.fontsFamily,
                                                    fontSize: 15.0,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              getHorSpace(6.h)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            body: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TabBarView(
                                children: [
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          // .orderBy('createdAt', descending: false)
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }

                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'swimming')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        // if (snapshot.hasError) {
                                        //   return Center(child: Text('Error'));
                                        // }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }

                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category', isEqualTo: 'game')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'football')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'comedy')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'konser')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'trophy')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category', isEqualTo: 'tour')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'festival')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category', isEqualTo: 'study')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category', isEqualTo: 'party')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'olympic')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                  Container(
                                    height: 350.0,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("event")
                                          .where('category',
                                              isEqualTo: 'culture')
                                          .limit(10)
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                loadingCard2(context),
                                                loadingCard2(context),
                                              ]);
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: EmptyScreen());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? TrendingEventCard2(
                                                list: snapshot.data?.docs,
                                              )
                                            : Container();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // buildTrendingCategoryList(),
                    // getVerSpace(24.h),
                    // Container(
                    //   height: 290.0,
                    //   child: StreamBuilder(
                    //     stream: FirebaseFirestore.instance
                    //         .collection("event")
                    //         .where('type', isEqualTo: 'trending')
                    //         .snapshots(),
                    //     builder: (BuildContext ctx,
                    //         AsyncSnapshot<QuerySnapshot> snapshot) {
                    //       return snapshot.hasData
                    //           ? TrendingEventCard2(
                    //               list: snapshot.data?.docs,
                    //             )
                    //           : Container();
                    //     },
                    //   ),
                    // ),
                    // if (cb.data2.isEmpty)
                    //   Column(
                    //     children: [
                    //       SizedBox(
                    //         height: MediaQuery.of(context).size.height * 0.20,
                    //       ),
                    //       Text("Empty"),
                    //     ],
                    //   ),
                    //           SizedBox(
                    //             height: 300.0,
                    //             child: ListView.builder(
                    //               scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    // primary: false,
                    //               itemCount: cb.data2.length,

                    //               itemBuilder: (_, int index) {
                    //                 //  return Card1(d: cb.data[index], heroTag: 'tab1$index');
                    //                 // return Card2(d: cb.data[index], heroTag: 'tab1$index');
                    //                 return buildTrendingEventList(cb.data2[index]);
                    //                 // return buildTrendingCategoryList();
                    //                 // return Opacity(
                    //                 //   opacity: cb.isLoading ? 1.0 : 0.0,
                    //                 //   child: cb.lastVisible == null
                    //                 //       ? LoadingCard(height: 250)
                    //                 //       : Center(
                    //                 //           child: SizedBox(
                    //                 //               width: 32.0,
                    //                 //               height: 32.0,
                    //                 //               child: new CupertinoActivityIndicator()),
                    //                 //         ),
                    //                 // );
                    //               },
                    //             ),
                    //           ),

                    Padding(
                      padding: EdgeInsets.only(left: 20.0.w),
                      child: getCustomFont(
                          ("Events of this month").tr(), 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                    ),

                    getVerSpace(10.h),
                    Container(
                      height: 298.h,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("event")
                            .where('date',
                                isGreaterThanOrEqualTo:
                                    Timestamp.fromDate(startOfMonth))
                            .where('date',
                                isLessThanOrEqualTo:
                                    Timestamp.fromDate(endOfMonth))
                            .orderBy('date', descending: false)
                            .limit(10)
                            .snapshots(),
                        builder: (BuildContext ctx,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return loadingCard(ctx);
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //          decoration: BoxDecoration(
                                //              color: lightColor,
                                //              borderRadius: BorderRadius.circular(187.h)),
                                //          padding: EdgeInsets.all(10.h),
                                //          child: getAssetImage("empty.png",
                                //          height: 100.0,
                                //               width: 134.h,boxFit: BoxFit.cover),
                                //        ),
                                getCustomFont(("Not have upcoming events").tr(),
                                    16.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w500,
                                    txtHeight: 1.5.h),
                              ],
                            ));
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error'));
                          }

                          // return loadingCard(ctx);
                          return snapshot.hasData
                              ? TrendingEventCard3(
                                  list: snapshot.data?.docs,
                                )
                              // buildFeatureEventList(
                              //    list: snapshot.data?.docs,
                              //  )
                              : Container();
                        },
                      ),
                    ),

                    getVerSpace(20.h),
                    // buildTrendingEventList(),
                    getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCustomFont(
                              ("Popular Events").tr(), 20.sp, Colors.black, 1,
                              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      PopularEventList()));

                              // Constant.sendToNext(
                              //     context, Routes.popularEventListRoute);
                            },
                            child: getCustomFont(
                                ("View All").tr(), 15.sp, greyColor, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          )
                        ],
                      ),
                    ),
                    getVerSpace(12.h),
                    // cb.hasData == false
                    // ignore: unnecessary_null_comparison
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("event")
                          .orderBy('count', descending: true)
                          .limit(7)
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadingCard(context);
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Center(child: EmptyScreen());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error'));
                        }
                        return snapshot.hasData
                            ? buildPopularEventList(
                                list: snapshot.data?.docs,
                                id: snapshot.data?.docs[0].id,
                              )
                            : Container();
                      },
                    ),

                    // if (cb.data.isEmpty)
                    //   Column(
                    //     children: [
                    //       SizedBox(
                    //         height: MediaQuery.of(context).size.height * 0.20,
                    //       ),
                    //       Text("Empty"),
                    //     ],
                    //   ),
                    // ListView.separated(
                    //   padding: EdgeInsets.all(15),
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: cb.data.length,
                    //   separatorBuilder: (BuildContext context, int index) =>
                    //       SizedBox(
                    //     height: 15,
                    //   ),
                    //   shrinkWrap: true,
                    //   itemBuilder: (_, int index) {
                    //     //  return Card1(d: cb.data[index], heroTag: 'tab1$index');
                    //     // return Card2(d: cb.data[index], heroTag: 'tab1$index');
                    //     return buildPopularEventList(cb.data[index]);

                    //     // return Opacity(
                    //     //   opacity: cb.isLoading ? 1.0 : 0.0,
                    //     //   child: cb.lastVisible == null
                    //     //       ? LoadingCard(height: 250)
                    //     //       : Center(
                    //     //           child: SizedBox(
                    //     //               width: 32.0,
                    //     //               height: 32.0,
                    //     //               child: new CupertinoActivityIndicator()),
                    //     //         ),
                    //     // );
                    //   },
                    // ),

                    // buildPopularEventList(),
                    getVerSpace(40.h),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // Widget buildPopularEventList(EventBaru event) {
  //   // return ListView.builder(
  //   //   padding: EdgeInsets.symmetric(horizontal: 20.h),
  //   //   itemCount: popularEventLists.length,
  //   //   primary: false,
  //   //   shrinkWrap: true,
  //   //   itemBuilder: (context, index) {
  //   //     ModalPopularEvent modalPopularEvent = popularEventLists[index];
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 20.h),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         boxShadow: [
  //           BoxShadow(
  //               color: shadowColor, blurRadius: 27, offset: const Offset(0, 8))
  //         ],
  //         borderRadius: BorderRadius.circular(22.h)),
  //     padding: EdgeInsets.only(top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 82,
  //                 width: 82,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //                     image: DecorationImage(
  //                         image: NetworkImage(
  //                           event.image ?? '',
  //                         ),
  //                         fit: BoxFit.cover)),
  //               ),
  //               // Image.network(event.image??'',height: 82,width: 82,),
  //               // getAssetImage(event.image ?? "",
  //               //     width: 82.h, height: 82.h),
  //               getHorSpace(10.h),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   getCustomFont(event.title ?? "", 18.sp, Colors.black, 1,
  //                       fontWeight: FontWeight.w600, txtHeight: 1.5.h),
  //                   getVerSpace(4.h),
  //                   getCustomFont(event.date ?? '', 15.sp, greyColor, 1,
  //                       fontWeight: FontWeight.w500, txtHeight: 1.46.h)
  //                 ],
  //               )
  //             ],
  //           ),
  //         ),
  //         Container(
  //           height: 34.h,
  //           decoration: BoxDecoration(
  //               color: lightAccent, borderRadius: BorderRadius.circular(12.h)),
  //           alignment: Alignment.center,
  //           padding: EdgeInsets.symmetric(horizontal: 12.h),
  //           child: Row(
  //             children: [
  //               getCustomFont('\$ ', 15.sp, accentColor, 1,
  //                   fontWeight: FontWeight.w600, txtHeight: 1.46.h),
  //               getCustomFont(
  //                   event.price.toString() ?? '', 15.sp, accentColor, 1,
  //                   fontWeight: FontWeight.w600, txtHeight: 1.46.h),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  //   //   },
  //   // );
  // }

  // Widget buildTrendingEventList(Event2 event) {
  //   return SizedBox(
  //     height: 289.h,
  //     child: GestureDetector(
  //       onTap: () {
  //         Constant.sendToNext(context, Routes.featuredEventDetailRoute);
  //       },
  //       child: Container(
  //         margin: EdgeInsets.only(right: 20.h, left: 20.h),
  //         child: Stack(
  //           alignment: Alignment.topCenter,
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(22.h),
  //                   image: DecorationImage(
  //                       image: NetworkImage(event.image ?? ''),
  //                       fit: BoxFit.fill)),
  //               height: 170.h,
  //               width: 248.h,
  //               padding: EdgeInsets.only(left: 12.h, top: 12.h),
  //               child: Wrap(
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                         color: "#B2000000".toColor(),
  //                         borderRadius: BorderRadius.circular(12.h)),
  //                     padding:
  //                         EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.h),
  //                     child: getCustomFont(
  //                         event.date ?? "", 13.sp, Colors.white, 1,
  //                         fontWeight: FontWeight.w600, txtHeight: 1.69.h),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Positioned(
  //               width: 230.h,
  //               top: 132.h,
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: shadowColor,
  //                           blurRadius: 27,
  //                           offset: const Offset(0, 8))
  //                     ],
  //                     borderRadius: BorderRadius.circular(22.h)),
  //                 padding: EdgeInsets.symmetric(horizontal: 16.h),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     getVerSpace(16.h),
  //                     getCustomFont(event.title ?? "", 18.sp, Colors.black, 1,
  //                         fontWeight: FontWeight.w600, txtHeight: 1.5.h),
  //                     getVerSpace(3.h),
  //                     Row(
  //                       children: [
  //                         getSvgImage("location.svg",
  //                             width: 20.h, height: 20.h, color: greyColor),
  //                         getHorSpace(5.h),
  //                         getCustomFont(
  //                             event.location ?? "", 15.sp, greyColor, 1,
  //                             fontWeight: FontWeight.w500, txtHeight: 1.5.h)
  //                       ],
  //                     ),
  //                     getVerSpace(10.h),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             CircleAvatar(
  //                               backgroundImage:
  //                                   NetworkImage(event.userProfile ?? ''),
  //                               radius: 10.0,
  //                             ),
  //                             // getAssetImage(
  //                             //     event.sponser ?? '',
  //                             //     height: 30.h,
  //                             //     width: 30.h),
  //                             getHorSpace(8.h),
  //                             getCustomFont(
  //                                 event.userName ?? '', 15.sp, greyColor, 1,
  //                                 fontWeight: FontWeight.w500,
  //                                 txtHeight: 1.46.h)
  //                           ],
  //                         ),
  //                         getButton(context, accentColor, "Join", Colors.white,
  //                             () {}, 14.sp,
  //                             weight: FontWeight.w700,
  //                             buttonHeight: 40.h,
  //                             borderRadius: BorderRadius.circular(14.h),
  //                             buttonWidth: 70.h)
  //                       ],
  //                     ),
  //                     getVerSpace(16.h),
  //                   ],
  //                 ),
  //                 // height: 133.h,
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget buildSearchWidget(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: getPaddingWidget(
              EdgeInsets.symmetric(horizontal: 20.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => SearchPage()));
                  // FilterScreen
                },
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      getHorSpace(18.h),
                      getSvg("search.svg", height: 24.h, width: 24.h),
                      getHorSpace(18.h),
                      Text(
                        "Search events",
                        style: TextStyle(fontSize: 16.sp, fontFamily: 'Gilroy'),
                      )
                    ],
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => FilterScreen()));
            },
            child: Showcase(
              key: _three,
              description: 'Filter event by category',
              child: Container(
                height: 47.0,
                width: 47.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: getSvg("filter.svg", height: 24.h, width: 24.h),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildAppBar() {
    final sb = context.watch<SignInProvider>();
    return getPaddingWidget(
      EdgeInsets.only(left: 20.h, right: 20.0),
      Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // ignore: prefer_const_constructors
                  Text(
                    ('Welcome Back!').tr(),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Gilroy',
                        color: Colors.white),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/ic_waving_hand.svg',
                    width: 15.0,
                    height: 15.0,
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                sb.name ?? '',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          Showcase(
            key: _one,
            description: "Information all notifications",
            child: Container(
              height: 50.h,
              width: 50.h,
              margin: EdgeInsets.only(top: 18.h, right: 20.h),
              padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 13.h),
              decoration: BoxDecoration(
                  color: lightColor, borderRadius: BorderRadius.circular(22.h)),
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => NotificationScreen()));

                    // Constant.sendToNext(context, Routes.notificationScreenRoute);
                  },
                  child: getSvg("notification.svg", height: 24.h, width: 24.h)),
            ),
          ),
        ],
      ),
    );
  }
}

class buildPopularEventList extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  String? id;

  buildPopularEventList({this.list, this.id});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return EventBaru.fromFirestore(e, 1);
          }).toList();
          // String? category = list?[i]['category'].toString();
          // String? date = list?[i]['date'].toString();
          // String? image = list?[i]['image'].toString();
          // String? description = list?[i]['description'].toString();
          // String? id = list?[i]['id'].toString();
          // String? location = list?[i]['location'].toString();
          // double? mapsLangLink = list?[i]['mapsLangLink'];
          // double? mapsLatLink = list?[i]['mapsLatLink'];
          // int? price = list?[i]['price'];
          // String? title = list?[i]['title'].toString();
          // String? type = list?[i]['type'].toString();
          // String? userDesc = list?[i]['userDesc'].toString();
          // String? userName = list?[i]['userName'].toString();
          // String? userProfile = list?[i]['userProfile'].toString();
          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);

          return InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection('event')
                  .doc(list?[i].id)
                  .update({'count': FieldValue.increment(1)});
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => FeaturedEvent2Detail(
                        event: events?[i],
                        // category: category,
                        // date: date,
                        // description: description,
                        // id: id,
                        // image: image,
                        // location: location,
                        // mapsLangLink: mapsLangLink,
                        // mapsLatLink: mapsLatLink,
                        // price: price,
                        // title: title,
                        // type: type,
                        // userDesc: userDesc,
                        // userName: userName,
                        // userProfile: userProfile,
                      )));
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150.0,
                      margin: EdgeInsets.only(
                          bottom: 20.h, left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: shadowColor,
                                blurRadius: 27,
                                offset: const Offset(0, 8))
                          ],
                          borderRadius: BorderRadius.circular(22.h)),
                      padding: EdgeInsets.only(
                          top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
                      child: Row(
                        children: [
                          Container(
                            height: 102,
                            width: 102,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      events?[i].image ?? '',
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          // Image.network(event.image??'',height: 82,width: 82,),
                          // getAssetImage(event.image ?? "",
                          //     width: 82.h, height: 82.h),
                          getHorSpace(10.h),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 210.w,
                                  child: getCustomFont(events?[i].title ?? "",
                                      20.5.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                      txtHeight: 1.5.h),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: [
                                    getSvg("calender.svg",
                                        color: Colors.grey[400],
                                        width: 16.h,
                                        height: 16.h),
                                    getHorSpace(5.h),
                                    getCustomFont(date.toString() ?? "", 15.sp,
                                        greyColor, 1,
                                        fontWeight: FontWeight.w500,
                                        txtHeight: 1.5.h),
                                  ],
                                ),
                                getVerSpace(5.h),
                                Row(
                                  children: [
                                    getSvg("Location.svg",
                                        color: Colors.grey[400],
                                        width: 18.h,
                                        height: 18.h),
                                    getHorSpace(5.h),
                                    Container(
                                      width: 150.w,
                                      child: getCustomFont(
                                          events?[i].location ?? "",
                                          15.sp,
                                          greyColor,
                                          1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.5.h),
                                    ),
                                  ],
                                ),
                                getVerSpace(7.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("JoinEvent")
                                          .doc("user")
                                          .collection(events[i].title ?? '')
                                          .snapshots(),
                                      builder: (BuildContext ctx,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        if (snapshot.data!.docs.isEmpty) {
                                          return Center(child: Container());
                                        }
                                        if (snapshot.hasError) {
                                          return Center(child: Text('Error'));
                                        }
                                        return snapshot.hasData
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 20.0),
                                                child: new joinEvents(
                                                  list: snapshot.data?.docs,
                                                ),
                                              )
                                            : Container();
                                      },
                                    ),
                                    if (events[i].price! > 0)
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, bottom: 0.0),
                                            child: Container(
                                              height: 35.h,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.051),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.h)),
                                              child: Center(
                                                  child: Text(
                                                "\$ " +
                                                    (events?[i]
                                                            .price
                                                            .toString() ??
                                                        ""),
                                                style: TextStyle(
                                                    color: accentColor,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.center,
                                              )),
                                            )),
                                      ),
                                    if (events[i].price == 0)
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, bottom: 0.0),
                                            child: Container(
                                              height: 35.h,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.051),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.h)),
                                              child: Center(
                                                  child: Text(
                                                ("Free").tr(),
                                                style: TextStyle(
                                                    color: accentColor,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'Gilroy',
                                                    fontWeight:
                                                        FontWeight.w700),
                                                textAlign: TextAlign.center,
                                              )),
                                            )),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 305.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10.h)),
                        padding: EdgeInsets.symmetric(
                            vertical: 3.h, horizontal: 10.h),
                        child: Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            SizedBox(width: 5),
                            getCustomFont(events?[i].count.toString() ?? "",
                                13.sp, Colors.white, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class buildFeatureEventList extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  const buildFeatureEventList({this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 196.h,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return EventBaru.fromFirestore(e, 1);
          }).toList();

          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);
          // DateTime date = DateFormat('dd/MM/yyyy').format(events![i].date.toString());
          return InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection('event')
                  .doc(list?[i].id)
                  .update({'count': FieldValue.increment(1)});
              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => FeaturedEvent2Detail(
                        event: events?[i],
                      )));
            },
            child: Container(
              width: 374.h,
              height: 196.h,
              margin: EdgeInsets.only(
                  right: 0.h, left: 20.h, top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.h),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      blurRadius: 27,
                      offset: const Offset(0, 8))
                ],
                // image: DecorationImage(
                //     image: NetworkImage(events?[i].image ?? ''),
                //     fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Container(
                    height: 196.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.h),
                      // gradient: LinearGradient(
                      //     colors: [
                      //       "#000000".toColor().withOpacity(0.0),
                      //       "#000000".toColor().withOpacity(0.88)
                      //     ],
                      //     stops: const [
                      //       0.0,
                      //       1.0
                      //     ],
                      //     begin: Alignment.centerRight,
                      //     end: Alignment.centerLeft)
                    ),
                    padding: EdgeInsets.only(left: 24.h),
                    child: Row(
                      children: [
                        Container(
                          height: 120.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            image: DecorationImage(
                                image: NetworkImage(events?[i].image ?? ''),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 170.0,
                                child: getCustomFont(events?[i].title ?? "",
                                    20.5.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w700,
                                    overflow: TextOverflow.ellipsis,
                                    txtHeight: 1.5.h),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: [
                                  getSvg("calender.svg",
                                      color: Colors.grey[400],
                                      width: 16.h,
                                      height: 16.h),
                                  getHorSpace(5.h),
                                  getCustomFont(date.toString() ?? "", 15.sp,
                                      greyColor, 1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                ],
                              ),
                              getVerSpace(5.h),
                              Row(
                                children: [
                                  getSvg("Location.svg",
                                      color: Colors.grey[400],
                                      width: 18.h,
                                      height: 18.h),
                                  getHorSpace(5.h),
                                  Container(
                                    width: 100.0,
                                    child: getCustomFont(
                                        events?[i].location ?? "",
                                        15.sp,
                                        greyColor,
                                        1,
                                        fontWeight: FontWeight.w500,
                                        txtHeight: 1.5.h),
                                  ),
                                ],
                              ),
                              getVerSpace(7.h),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("JoinEvent")
                                    .doc("user")
                                    .collection(events[i].title ?? '')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.data!.docs.isEmpty) {
                                    return Center(child: Container());
                                  }
                                  if (snapshot.hasError) {
                                    return Center(child: Text('Error'));
                                  }
                                  return snapshot.hasData
                                      ? new joinEvents(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (events[i].price! > 0)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 20.0),
                          child: Container(
                            height: 35.h,
                            width: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.051),
                                borderRadius: BorderRadius.circular(50.h)),
                            child: Center(
                                child: Text(
                              "\$ " + (events?[i].price.toString() ?? ""),
                              style: TextStyle(
                                  color: accentColor,
                                  fontSize: 15.sp,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            )),
                          )),
                    ),
                  if (events[i].price == 0)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding:
                              const EdgeInsets.only(right: 20.0, bottom: 20.0),
                          child: Container(
                            height: 35.h,
                            width: 80.0,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.051),
                                borderRadius: BorderRadius.circular(50.h)),
                            child: Center(
                                child: Text(
                              ("Free").tr(),
                              style: TextStyle(
                                  color: accentColor,
                                  fontSize: 15.sp,
                                  fontFamily: 'Gilroy',
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            )),
                          )),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget loadingCard(BuildContext context) {
  return Container(
    height: 130.0,
    width: MediaQuery.of(context).size.width - 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(
        15.0,
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0xFF333333).withOpacity(0.06),
          offset: const Offset(0, 2),
          blurRadius: 10,
        ),
      ],
    ),
    child: Shimmer.fromColors(
      baseColor: Colors.black38,
      highlightColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: 0, top: 0),
        child: Container(
          width: double.maxFinite,
          height: 30.0 * 2 + 20.0,
          margin: EdgeInsets.only(
            top: 10,
            left: 5,
            right: 5,
          ),
          padding: EdgeInsets.only(
            top: 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 25,
              ),
              Container(
                height: 150.0,
                width: 100.0,
                color: Colors.black12,
                child: Text(
                  '',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18.0,
                      width: 200.0,
                      color: Colors.black12,
                      child: Text(
                        '',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 18.0,
                      width: 150.0,
                      color: Colors.black12,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 18.0,
                      width: 50.0,
                      color: Colors.black12,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 0, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Center(
                    child: Container(
                      height: 25.0,
                      width: 25.0,
                      color: Colors.black12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loadingCard2(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 100.0,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF333333).withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.black38,
        highlightColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            width: double.maxFinite,
            height: 30.0 * 2 + 20.0,
            padding: EdgeInsets.only(
              top: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150.0,
                  width: 250,
                  color: Colors.black12,
                  child: Text(
                    '',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18.0,
                        width: 200.0,
                        color: Colors.black12,
                        child: Text(
                          '',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 18.0,
                        width: 80.0,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 100, bottom: 10, top: 10.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Center(
                      child: Container(
                        height: 25.0,
                        width: 65.0,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class TrendingEventCard extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  const TrendingEventCard({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return EventBaru.fromFirestore(e, 1);
          }).toList();
          // String? category = list?[i]['category'].toString();
          // String? date = list?[i]['date'].toString();
          // String? image = list?[i]['image'].toString();
          // String? description = list?[i]['description'].toString();
          // String? id = list?[i]['id'].toString();
          // String? location = list?[i]['location'].toString();
          // double? mapsLangLink = list?[i]['mapsLangLink'];
          // double? mapsLatLink = list?[i]['mapsLatLink'];
          // int? price = list?[i]['price'];
          // String? title = list?[i]['title'].toString();
          // String? type = list?[i]['type'].toString();
          // String? userDesc = list?[i]['userDesc'].toString();
          // String? userName = list?[i]['userName'].toString();
          // String? userProfile = list?[i]['userProfile'].toString();

          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);
          return SizedBox(
            height: 309.h,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('event')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FeaturedEvent2Detail(
                          event: events?[i],
                          // category: category,
                          // date: date,
                          // description: description,
                          // id: id,
                          // image: image,
                          // location: location,
                          // mapsLangLink: mapsLangLink,
                          // mapsLatLink: mapsLatLink,
                          // price: price,
                          // title: title,
                          // type: type,
                          // userDesc: userDesc,
                          // userName: userName,
                          // userProfile: userProfile,
                        )));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.h, left: 20.h, bottom: 20.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          color: Colors.black12,
                          image: DecorationImage(
                              image: NetworkImage(events?[i].image ?? ''),
                              fit: BoxFit.fill)),
                      height: 240.h,
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 12.h, top: 12.h),
                      child: Wrap(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: "#B2000000".toColor(),
                                borderRadius: BorderRadius.circular(10.h)),
                            padding: EdgeInsets.symmetric(
                                vertical: 7.h, horizontal: 10.h),
                            child: getCustomFont(
                                date.toString() ?? "", 15.sp, Colors.white, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      width: 330.0,
                      top: 152.h,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius: BorderRadius.circular(10.h)),
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerSpace(16.h),
                            Container(
                              width: 300.0.w,
                              child: getCustomFont(events?[i].title ?? "",
                                  20.5.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w700,
                                  txtHeight: 1.5.h),
                            ),
                            getVerSpace(3.h),
                            Row(
                              children: [
                                getSvg("Location.svg",
                                    color: accentColor,
                                    width: 18.h,
                                    height: 18.h),
                                getHorSpace(5.h),
                                Container(
                                  width: 250.0.w,
                                  child: getCustomFont(
                                      events?[i].location ?? "",
                                      15.sp,
                                      greyColor,
                                      1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                )
                              ],
                            ),
                            getVerSpace(10.h),
                            // Expanded(
                            //   child: StreamBuilder(
                            //     stream: FirebaseFirestore.instance
                            //         .collection("JoinEvent")
                            //         .doc("user")
                            //         .collection(events[i].title ?? '')
                            //         .snapshots(),
                            //     builder: (BuildContext ctx,
                            //         AsyncSnapshot<QuerySnapshot> snapshot) {
                            //       if (snapshot.connectionState ==
                            //           ConnectionState.waiting) {
                            //         return Center(
                            //             child: CircularProgressIndicator());
                            //       }

                            //       if (snapshot.data!.docs.isEmpty) {
                            //         return Center(child: Container());
                            //       }
                            //       if (snapshot.hasError) {
                            //         return Center(child: Text('Error'));
                            //       }
                            //       return snapshot.hasData
                            //           ? new joinEvents(
                            //               list: snapshot.data?.docs,
                            //             )
                            //           : Container();
                            //     },
                            //   ),
                            // ),

                            if (events[i].price! > 0)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 0.0),
                                    child: Container(
                                      height: 35.h,
                                      width: 80.0,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.black.withOpacity(0.051),
                                          borderRadius:
                                              BorderRadius.circular(50.h)),
                                      child: Center(
                                          child: Text(
                                        "\$ " +
                                            (events?[i].price.toString() ?? ""),
                                        style: TextStyle(
                                            color: accentColor,
                                            fontSize: 15.sp,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                            if (events[i].price == 0)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 0.0),
                                    child: Container(
                                      height: 35.h,
                                      width: 80.0,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.black.withOpacity(0.051),
                                          borderRadius:
                                              BorderRadius.circular(50.h)),
                                      child: Center(
                                          child: Text(
                                        ("Free").tr(),
                                        style: TextStyle(
                                            color: accentColor,
                                            fontSize: 15.sp,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                            getVerSpace(16.h),
                          ],
                        ),
                        // height: 133.h,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class TrendingEventCard2 extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  const TrendingEventCard2({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return EventBaru.fromFirestore(e, 1);
          }).toList();
          // String? category = list?[i]['category'].toString();
          // String? date = list?[i]['date'].toString();
          // String? image = list?[i]['image'].toString();
          // String? description = list?[i]['description'].toString();
          // String? id = list?[i]['id'].toString();
          // String? location = list?[i]['location'].toString();
          // double? mapsLangLink = list?[i]['mapsLangLink'];
          // double? mapsLatLink = list?[i]['mapsLatLink'];
          // int? price = list?[i]['price'];
          // String? title = list?[i]['title'].toString();
          // String? type = list?[i]['type'].toString();
          // String? userDesc = list?[i]['userDesc'].toString();
          // String? userName = list?[i]['userName'].toString();
          // String? userProfile = list?[i]['userProfile'].toString();

          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);
          return SizedBox(
            height: 309.h,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('event')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FeaturedEvent2Detail(
                          event: events?[i],
                          // category: category,
                          // date: date,
                          // description: description,
                          // id: id,
                          // image: image,
                          // location: location,
                          // mapsLangLink: mapsLangLink,
                          // mapsLatLink: mapsLatLink,
                          // price: price,
                          // title: title,
                          // type: type,
                          // userDesc: userDesc,
                          // userName: userName,
                          // userProfile: userProfile,
                        )));
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.h, left: 20.h, bottom: 20.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          color: Colors.black12,
                          image: DecorationImage(
                              image: NetworkImage(events?[i].image ?? ''),
                              fit: BoxFit.fill)),
                      height: 190.h,
                      width: 240.0,
                      padding: EdgeInsets.only(left: 12.h, top: 12.h),
                      child: Wrap(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: "#B2000000".toColor(),
                                borderRadius: BorderRadius.circular(10.h)),
                            padding: EdgeInsets.symmetric(
                                vertical: 7.h, horizontal: 10.h),
                            child: getCustomFont(
                                date.toString() ?? "", 13.sp, Colors.white, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      width: 240.0,
                      top: 152.h,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius: BorderRadius.circular(10.h)),
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerSpace(16.h),
                            Container(
                              width: 190.0.w,
                              child: getCustomFont(events?[i].title ?? "",
                                  20.5.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w700,
                                  txtHeight: 1.5.h),
                            ),
                            getVerSpace(3.h),
                            Row(
                              children: [
                                getSvg("Location.svg",
                                    color: Colors.grey[400],
                                    width: 18.h,
                                    height: 18.h),
                                getHorSpace(5.h),
                                Container(
                                  width: 150.0.w,
                                  child: getCustomFont(
                                      events?[i].location ?? "",
                                      15.sp,
                                      greyColor,
                                      1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                )
                              ],
                            ),
                            getVerSpace(10.h),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("JoinEvent")
                                  .doc("user")
                                  .collection(events[i].title ?? '')
                                  .snapshots(),
                              builder: (BuildContext ctx,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.data!.docs.isEmpty) {
                                  return Center(child: Container());
                                }
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error'));
                                }
                                return snapshot.hasData
                                    ? new joinEvents(
                                        list: snapshot.data?.docs,
                                      )
                                    : Container();
                              },
                            ),
                            if (events[i].price! > 0)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 0.0),
                                    child: Container(
                                      height: 35.h,
                                      width: 80.0,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.black.withOpacity(0.051),
                                          borderRadius:
                                              BorderRadius.circular(50.h)),
                                      child: Center(
                                          child: Text(
                                        "\$ " +
                                            (events?[i].price.toString() ?? ""),
                                        style: TextStyle(
                                            color: accentColor,
                                            fontSize: 15.sp,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                            if (events[i].price == 0)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, bottom: 0.0),
                                    child: Container(
                                      height: 35.h,
                                      width: 80.0,
                                      decoration: BoxDecoration(
                                          color:
                                              Colors.black.withOpacity(0.051),
                                          borderRadius:
                                              BorderRadius.circular(50.h)),
                                      child: Center(
                                          child: Text(
                                        ("Free").tr(),
                                        style: TextStyle(
                                            color: accentColor,
                                            fontSize: 15.sp,
                                            fontFamily: 'Gilroy',
                                            fontWeight: FontWeight.w700),
                                        textAlign: TextAlign.center,
                                      )),
                                    )),
                              ),
                            getVerSpace(16.h),
                          ],
                        ),
                        // height: 133.h,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class joinEvents extends StatelessWidget {
  joinEvents({this.list});

  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Container(
              height: 25.0,
              width: 54.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list!.length > 3 ? 3 : list?.length,
                itemBuilder: (context, i) {
                  String? _title = list?[i]['name'].toString();
                  String? _uid = list?[i]['uid'].toString();
                  String? _img = list?[i]['photoProfile'].toString();

                  return Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(70.0)),
                          image: DecorationImage(
                              image: NetworkImage(_img ?? ''),
                              fit: BoxFit.cover)),
                    ),
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 3.0,
            left: 0.0,
          ),
          child: Row(
            children: [
              Container(
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(30.h),
                    border: Border.all(color: Colors.white, width: 1.5.h)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getCustomFont(
                        list?.length.toString() ?? '', 12.sp, Colors.white, 1,
                        fontWeight: FontWeight.w600),
                    getCustomFont(" +", 12.sp, Colors.white, 1,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey notification;
  final GlobalKey search;
  final GlobalKey filter;
  final GlobalKey nearby;
  final GlobalKey country;

  KeysToBeInherited({
    required this.notification,
    required this.search,
    required this.filter,
    required this.nearby,
    required this.country,
    required Widget child,
  }) : super(child: child);

  static KeysToBeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class buildNearHotelList extends StatelessWidget {
  final EventBaru? hotel;

  const buildNearHotelList({this.hotel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: SizedBox(
          height: 196.h,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(PageRouteBuilder(
              //     pageBuilder: (_, __, ___) =>  FeaturedHotel2Detail(
              //       Hotel: Hotels?[i],
              //         )));

              Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new FeaturedEvent2Detail(
                        event: hotel,
                      ),
                  transitionDuration: const Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (_, Animation<double> animation, __, Widget child) {
                    return Opacity(
                      opacity: animation.value,
                      child: child,
                    );
                  }));
            },
            child: Hero(
              tag: 'hero-tagss-${hotel?.id}' ?? '',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 374.w,
                  height: 196.h,
                  margin: EdgeInsets.only(right: 20.h, left: 20.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.h),
                    image: DecorationImage(
                        image: NetworkImage(hotel?.image ?? ''),
                        fit: BoxFit.cover),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 196.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.h),
                            gradient: LinearGradient(
                                colors: [
                                  "#000000".toColor().withOpacity(0.0),
                                  "#000000".toColor().withOpacity(0.88)
                                ],
                                stops: const [
                                  0.0,
                                  1.0
                                ],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft)),
                        padding: EdgeInsets.only(left: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 270.w,
                              child: getCustomFont(
                                  hotel?.title ?? "", 18.sp, Colors.white, 2,
                                  fontWeight: FontWeight.w700,
                                  txtHeight: 1.3.h),
                            ),
                            getVerSpace(4.h),
                            Row(
                              children: [
                                getSvgImage("location.svg",
                                    width: 20.h, height: 20.h),
                                getHorSpace(5.h),
                                Container(
                                  width: 200.w,
                                  child: getCustomFont(hotel?.location ?? "",
                                      15.sp, Colors.white, 1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                ),
                              ],
                            ),
                            getVerSpace(10.h),
                            Container(
                              width: MediaQuery.of(context).size.width / 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     Row(
                                  //       children: <Widget>[
                                  //         Icon(
                                  //           Icons.star,
                                  //           color: Colors.yellow[600],
                                  //           size: 15.0,
                                  //         ),
                                  //         Icon(
                                  //           Icons.star,
                                  //           color: Colors.yellow[600],
                                  //           size: 15.0,
                                  //         ),
                                  //         Icon(
                                  //           Icons.star,
                                  //           color: Colors.yellow[600],
                                  //           size: 15.0,
                                  //         ),
                                  //         Icon(
                                  //           Icons.star,
                                  //           color: Colors.yellow[600],
                                  //           size: 15.0,
                                  //         ),
                                  //         Icon(
                                  //           Icons.star_half,
                                  //           color: Colors.yellow[600],
                                  //           size: 15.0,
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  // SvgPicture.asset("assets/svg/calender.svg",
                                  // color: accentColor, width: 16.h, height: 16.h),
                                  Container(),
                                  // Text(
                                  //   "\$ ${  Hotels?[i].price.toString() ?? ""}",
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: 16.5,
                                  //       fontFamily: "RedHat",
                                  //       fontWeight: FontWeight.w900),
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                  // getCustomFont(
                                  //     date.toString() ?? "", 15.sp, greyColor, 1,
                                  //     fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                                ],
                              ),
                            ),
                            getVerSpace(10.h),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getButton(context, accentColor, "Book Now",
                                      Colors.white, () {}, 14.sp,
                                      weight: FontWeight.w700,
                                      buttonHeight: 40.h,
                                      borderRadius: BorderRadius.circular(14.h),
                                      buttonWidth: 111.h),
                                  Row(
                                    children: [
                                      Text(
                                        'Distance : ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.5.sp,
                                            fontFamily: "RedHat",
                                            fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${hotel?.distance?.toStringAsFixed(2)} KM',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.5.sp,
                                            fontFamily: "RedHat",
                                            fontWeight: FontWeight.w900),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

class TrendingEventCard3 extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  const TrendingEventCard3({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return EventBaru.fromFirestore(e, 1);
          }).toList();
          // String? category = list?[i]['category'].toString();
          // String? date = list?[i]['date'].toString();
          // String? image = list?[i]['image'].toString();
          // String? description = list?[i]['description'].toString();
          // String? id = list?[i]['id'].toString();
          // String? location = list?[i]['location'].toString();
          // double? mapsLangLink = list?[i]['mapsLangLink'];
          // double? mapsLatLink = list?[i]['mapsLatLink'];
          // int? price = list?[i]['price'];
          // String? title = list?[i]['title'].toString();
          // String? type = list?[i]['type'].toString();
          // String? userDesc = list?[i]['userDesc'].toString();
          // String? userName = list?[i]['userName'].toString();
          // String? userProfile = list?[i]['userProfile'].toString();

          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);
          return SizedBox(
            height: 309.h,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('event')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FeaturedEvent2Detail(
                          event: events?[i],
                          // category: category,
                          // date: date,
                          // description: description,
                          // id: id,
                          // image: image,
                          // location: location,
                          // mapsLangLink: mapsLangLink,
                          // mapsLatLink: mapsLatLink,
                          // price: price,
                          // title: title,
                          // type: type,
                          // userDesc: userDesc,
                          // userName: userName,
                          // userProfile: userProfile,
                        )));
              },
              child: Container(
                margin:
                    EdgeInsets.only(right: 20.w, left: 20.w, bottom: 20.0.h),
                child: Stack(
                  children: [
                    // Background image
                    Container(
                      width: 210.w,
                      // height: 400.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10.0,
                              spreadRadius: 4.0,
                              color: Colors.black12.withOpacity(0.035))
                        ],
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(events?[i].image ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Calendar overlay

                    // Bottom info
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              events?[i].title ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 17.0,
                                ),
                                SizedBox(width: 4),
                                Container(
                                  width: 100.w,
                                  // color: Colors.yellow,
                                  child: Text(
                                    events?[i].location ?? "",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "\$${events[i].price}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //  Stack(
                //   alignment: Alignment.topCenter,
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(22.h),
                //           color: Colors.black12,
                //           image: DecorationImage(image: NetworkImage(events?[i].image ?? ''), fit: BoxFit.fill)),
                //       height: 170.h,
                //       width: 240.0.w,
                //       padding: EdgeInsets.only(left: 12.w, top: 12.h),
                //       child: Wrap(
                //         children: [
                //           Container(
                //             decoration:
                //                 BoxDecoration(color: "#B2000000".toColor(), borderRadius: BorderRadius.circular(10.h)),
                //             padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.h),
                //             child: getCustomFont(date.toString() ?? "", 13.sp, Colors.white, 1,
                //                 fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Positioned(
                //       width: 240.0.w,
                //       top: 152.h,
                //       child: Container(
                //         height: 150.h,
                //         decoration: BoxDecoration(
                //             color: Colors.white,
                //             boxShadow: [BoxShadow(color: shadowColor, blurRadius: 27, offset: const Offset(0, 8))],
                //             borderRadius: BorderRadius.circular(10.h)),
                //         padding: EdgeInsets.symmetric(horizontal: 16.h),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             getVerSpace(16.h),
                //             Container(
                //               width: 190.0.w,
                //               child: getCustomFont(events?[i].title ?? "", 17.5.sp, Colors.black, 2,
                //                   fontWeight: FontWeight.w700, txtHeight: 1.1.h),
                //             ),
                //             getVerSpace(3.h),
                //             Row(
                //               children: [
                //                 getSvg("Location.svg", color: Colors.grey[400], width: 18.h, height: 18.h),
                //                 getHorSpace(5.h),
                //                 Container(
                //                   width: 150.0.w,
                //                   child: getCustomFont(events?[i].location ?? "", 15.sp, greyColor, 1,
                //                       fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                //                 )
                //               ],
                //             ),
                //             getVerSpace(10.h),
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               children: [
                //                 StreamBuilder(
                //                   stream: FirebaseFirestore.instance
                //                       .collection("JoinEvent")
                //                       .doc("user")
                //                       .collection(events[i].title ?? '')
                //                       .snapshots(),
                //                   builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                //                     if (snapshot.connectionState == ConnectionState.waiting) {
                //                       return Center(child: CircularProgressIndicator());
                //                     }

                //                     if (snapshot.data!.docs.isEmpty) {
                //                       return Center(child: Container());
                //                     }
                //                     if (snapshot.hasError) {
                //                       return Center(child: Text('Error'));
                //                     }
                //                     return snapshot.hasData
                //                         ? new joinEvents(
                //                             list: snapshot.data?.docs,
                //                           )
                //                         : Container(
                //                             height: 10.0.h,
                //                             width: 54.0.w,
                //                           );
                //                   },
                //                 ),
                //                 if (events[i].price! > 0)
                //                   Align(
                //                     alignment: Alignment.bottomRight,
                //                     child: Padding(
                //                         padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
                //                         child: Container(
                //                           height: 35.h,
                //                           width: 80.0.w,
                //                           decoration: BoxDecoration(
                //                               color: Colors.black.withOpacity(0.051),
                //                               borderRadius: BorderRadius.circular(50.h)),
                //                           child: Center(
                //                               child: Text(
                //                             "\$ " + (events?[i].price.toString() ?? ""),
                //                             style: TextStyle(
                //                                 color: accentColor,
                //                                 fontSize: 15.sp,
                //                                 fontFamily: 'Gilroy',
                //                                 fontWeight: FontWeight.w700),
                //                             textAlign: TextAlign.center,
                //                           )),
                //                         )),
                //                   ),
                //                 if (events[i].price == 0)
                //                   Align(
                //                     alignment: Alignment.bottomRight,
                //                     child: Padding(
                //                         padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
                //                         child: Container(
                //                           height: 35.h,
                //                           width: 80.0.w,
                //                           decoration: BoxDecoration(
                //                               color: Colors.black.withOpacity(0.051),
                //                               borderRadius: BorderRadius.circular(50.h)),
                //                           child: Center(
                //                               child: Text(
                //                             ("Free").tr(),
                //                             style: TextStyle(
                //                                 color: accentColor,
                //                                 fontSize: 15.sp,
                //                                 fontFamily: 'Gilroy',
                //                                 fontWeight: FontWeight.w700),
                //                             textAlign: TextAlign.center,
                //                           )),
                //                         )),
                //                   ),
                //               ],
                //             ),
                //             getVerSpace(16.h),
                //           ],
                //         ),
                //         // height: 133.h,
                //       ),
                //     )
                //   ],
                // ),
              ),
            ),
          );
        });
  }
}
