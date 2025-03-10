import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/view/home/filtering_screen.dart';
import 'package:event_app/app/view/home/tab/tab_maps.dart';
import 'package:event_app/base/color_data.dart';
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

import '../../../provider/event_provider.dart';
import '../../../provider/sign_in_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../widget/empty_screen.dart';
import '../../category/category_screen.dart';
import '../../notification/notification_screen.dart';
import '../search_screen.dart';

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

    final cb = context.watch<EventProvider>();
    final sb = context.watch<SignInProvider>();
    setStatusBarColor(Colors.white);
    return Scaffold(
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
                                  Container(
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
                                ],
                              ),
                            ),
                            getVerSpace(63.h),
                            getVerSpace(4.h),
                          ])),
                      Padding(
                        padding: const EdgeInsets.only(top: 130.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: getPaddingWidget(
                                  EdgeInsets.only(left: 20, right: 10),
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Row(
                                          children: [
                                            getSvg("search.svg",
                                                height: 24.h, width: 24.h),
                                            getHorSpace(12.h),
                                            Expanded(
                                              child: Text(
                                                "Search events".tr(),
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontFamily: 'Gilroy'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              MapsScreenT1()));
                                },
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
                                    child: getSvg("map.svg",
                                        height: 24.h, width: 24.h),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                      PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              FilterScreen()));
                                },
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  getVerSpace(30.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont(
                            ("Featured Events").tr(), 20.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        /*InkWell(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    TrendingScreen()));
                          },
                          child: getCustomFont(
                              ("View All").tr(), 15.sp, greyColor, 1,
                              fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                        )*/
                      ],
                    ),
                  ),
                  getVerSpace(10.h),
                  /*Container(
                    height: 198.h,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("event")
                          .where('type', isEqualTo: "company")
                          .limit(7)
                          .snapshots(),
                      builder: (BuildContext ctx,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingCard(
                            height: 200.0,
                          );
                        }

                        else if (snapshot.data!.docs.isEmpty) {
                          return Center(child: EmptyScreen());
                        }
                        else if (snapshot.hasError) {
                          return Center(child: Text('Error'));
                        }
                        else {
                          var eventsSnapshot = snapshot.data?.docs ?? [];
                          return eventsSnapshot.isNotEmpty
                            ? buildFeaturedEventList(list: eventsSnapshot)
                            : Container();}
                      },
                    ),
                  ),*/
                  Center(child: Text("Very soon!".tr()),),
                  getVerSpace(20.h),
                  getPaddingWidget(
                    EdgeInsets.symmetric(horizontal: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont(
                            ("User Events").tr(), 20.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    CategoryScreen()));
                          },
                          child: getCustomFont(
                              ("View All").tr(), 15.sp, greyColor, 1,
                              fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                        )
                      ],
                    ),
                  ),
                  getVerSpace(12.h),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("event")
                        .where('type', isEqualTo: 'user')
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
                          ? buildUserEventList(
                              list: snapshot.data?.docs,
                            )
                          : Container();
                    },
                  ),
                  getVerSpace(10.h),
                ],
              ))
        ],
      ),
    );
  }

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
                        "Search events".tr(),
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
          Container(
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
        ],
      ),
    );
  }
}

class buildUserEventList extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  buildUserEventList({this.list});

  @override
  Widget build(BuildContext context) {
    list?.sort((a, b) {
      int countA = a['count'] ?? 0; // Null olursa 0 kabul et
      int countB = b['count'] ?? 0;
      return countB.compareTo(countA); // Büyükten küçüğe sıralama
    });
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return EventBaru.fromFirestore(e,1);
          }).toList();
          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy', context.locale.toString()).format(dateTime!);

          return Container(
            margin: EdgeInsets.only(
                bottom: 20.h, left: 20.0, right: 20.0),
            child: InkWell(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('event')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: events[i]);
              },
              child: Stack(
                children: [
                  Container(
                    height: 100.0,
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                        children: [
                          events[i].image != null ? Row(
                            children: [
                              Image.network(events[i].image!, width: 50, height: 50,),
                              SizedBox(width: 16)
                            ],
                          ) : Container(),
                          Column(
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
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
            ),
          );
        });
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
          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy', context.locale.toString()).format(dateTime!);
          return SizedBox(
            height: 309.h,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('event')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: events[i]);

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
          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy', context.locale.toString()).format(dateTime!);
          return SizedBox(
            height: 309.h,
            child: GestureDetector(
              onTap: () {
                FirebaseFirestore.instance
                    .collection('event')
                    .doc(list?[i].id)
                    .update({'count': FieldValue.increment(1)});
                Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: events[i]);
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

class buildFeaturedEventList extends StatelessWidget {
  final List<DocumentSnapshot> list;

  const buildFeaturedEventList({required this.list});

  String getDate(Timestamp? timestamp, BuildContext context) {
    DateTime? dateTime = timestamp?.toDate();
    if (dateTime == null) {
      return "";
    } else {
      String date = DateFormat('d MMMM, yyyy', context.locale.toString()).format(dateTime);
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.take(5).length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final event = EventBaru.fromFirestore(list[index],1);
        return  Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: SizedBox(
              height: 196.h,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.featuredEventDetailRoute,
                    arguments: event,
                  );
                },
                child: Hero(
                  tag: 'hero-tagss-${event?.id}' ?? '',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 374.w,
                      height: 196.h,
                      margin: EdgeInsets.only(right: 20.h, left: 20.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.h),
                        image: DecorationImage(
                            image: NetworkImage(event?.image ?? ''),
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
                                      event?.title ?? "", 18.sp, Colors.white, 2,
                                      fontWeight: FontWeight.w700,
                                      txtHeight: 1.3.h),
                                ),
                                getVerSpace(4.h),
                                Container(
                                  width: 200.w,
                                  child: getCustomFont(getDate(event?.date, context),
                                      15.sp, Colors.white, 1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
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
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      getButton(context, accentColor, "Book Now",
                                          Colors.white, () {}, 14.sp,
                                          weight: FontWeight.w700,
                                          buttonHeight: 40.h,
                                          borderRadius: BorderRadius.circular(14.h),
                                          buttonWidth: 111.h),
                                      Container(
                                        color: Colors.black38,
                                        padding: EdgeInsets.all(4),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            getSvgImage("location.svg",
                                                width: 20.h, height: 20.h),
                                            getHorSpace(5.h),
                                            Container(
                                              margin: EdgeInsets.only(right: 8),
                                              child: getCustomFont(event?.location ?? "",
                                                  15.sp, Colors.white, 1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0, left: 295.0, right: 10),
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
                                  getCustomFont(event?.count.toString() ?? "",
                                      13.sp, Colors.white, 1,
                                      fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
