import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/view/intro/welcome.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../chatroom_logic/pages/chatroom_page.dart';
import '../../provider/bookmark_provider.dart';
import '../../provider/sign_in_provider.dart';
import '../../routes/app_routes.dart';
import '../../widget/join_number_widget.dart';
import '../../widget/love_icon.dart';
import '../../widget/map_sheet.dart';

class FeaturedEventDetail extends StatefulWidget {
  const FeaturedEventDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<FeaturedEventDetail> createState() => _FeaturedEventDetailState();
}

class _FeaturedEventDetailState extends State<FeaturedEventDetail> {
  late GoogleMapController mapController;
  late EventBaru event;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  bool isJoined(String? uid) {
    if (uid == null) {
      return false;
    }
    return event.joinEvent?.contains(uid) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)?.settings.arguments as EventBaru;
    final sb = context.watch<SignInProvider>();
    final isOwnEvent = sb.uid == event.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: buildImageWidget(),
          ),
          if (sb.name == null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => WelcomePage()));
                  },
                  child: Container(
                    height: 55.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: Center(
                      child: Text(
                        "Login to buy ticket",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            )
          else if (!isOwnEvent)
            Align(
              alignment: Alignment.bottomCenter,
              child: getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 0.h),
                Container(
                  color: Colors.white,
                  height: 60.0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20.0,
                      ),
                      isJoined(sb.uid) ? Center(
                        child: Container(
                          height: 55.h,
                          width: 55.h,
                          margin: EdgeInsets.only(top: 0.h, right: 10.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 13.h),
                          decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(22.h)),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatroomPage(
                                      arguments: ChatPageArguments(
                                        peerName: event.title ?? '',
                                        peerId: event.id ?? '',
                                        peerAvatar: sb.imageUrl ?? '',
                                        peerNickname: sb.name ?? '',
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: getSvg("message.svg",
                                  color: accentColor,
                                  height: 24.h,
                                  width: 24.h)),
                        ),
                      ) : Container(),
                      Center(
                        child: Container(
                          height: 55.h,
                          width: 55.h,
                          margin: EdgeInsets.only(top: 0.h, right: 10.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 13.h, horizontal: 13.h),
                          decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.09),
                              borderRadius: BorderRadius.circular(22.h)),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.chatRoute, arguments: {
                                  'userId': sb.uid,
                                  'eventId': event.id,
                                });
                              },
                              child: Icon(Icons.message, color: accentColor,)),
                        ),
                      ),
                      Expanded(
                        child: buildBuyTicketWidget(context, sb, event),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Container()
        ],
      ),
    );
  }

  Container buildBuyTicketWidget(BuildContext context, SignInProvider sb, EventBaru event) {
    if (event.joinEvent == null || !event.joinEvent!.contains(sb.uid)) {
      return Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: getButton(context, accentColor, ("Buy Ticket").tr(),
            Colors.white, () {
              Navigator.pushNamed(context, Routes.buyTicketRoute, arguments: event);
            }, 18.sp,
            weight: FontWeight.w700,
            buttonHeight: 60.h,
            borderRadius: BorderRadius.circular(22.h)),
      );
    }
    else {
      return Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: getButton(context, fadedAccentColor, ("You already have this ticket").tr(),
            Colors.white, () {}, 18.sp,
            weight: FontWeight.w700,
            buttonHeight: 60.h,
            borderRadius: BorderRadius.circular(22.h)),
      );
    }
  }

  handleLoveClick() {
    final SignInProvider sb = context.read<SignInProvider>();
    context.read<BookmarkProvider>().onBookmarkIconClick(event.id, sb.uid);
  }

  Container buildTicketPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      decoration: BoxDecoration(
          color: accentColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(22.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // getSvgImage("ticket.svg",
              //     width: 24.h, height: 24.h, color: Colors.black),

              getAssetImage("tiket.png", width: 28.h, height: 28.h),
              getHorSpace(5.h),
              getRichText(("Ticket Price ").tr(), Colors.black, FontWeight.w600,
                  15.sp, "", greyColor, FontWeight.w500, 13.sp),
            ],
          ),
          event.price == 0
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
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
                )
              : getCustomFont(
                  "\$" + event.price.toString() ?? "", 20.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700),
        ],
      ),
    );
  }

  Widget buildImageWidget() {
    final sb = context.watch<SignInProvider>();

    DateTime? dateTime = event.date?.toDate();
    String date = DateFormat('d MMMM, yyyy', context.locale.toString()).format(dateTime!);
    return ListView(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 327.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: event.image != null ? DecorationImage(
                      image: NetworkImage(event.image ?? ''),
                      fit: BoxFit.cover) : null),
              alignment: Alignment.topCenter,
              child: Container(
                height: 183.h,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          darkShadow.withOpacity(0.6),
                          lightShadow.withOpacity(0.0)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 1.0])),
                child: getPaddingWidget(
                  EdgeInsets.only(top: 26.h, right: 20.h, left: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            color: Colors.white),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: getSvgImage("arrow_back.svg",
                                width: 24.h, height: 24.h, color: Colors.black),
                          ),
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            color: Colors.white),
                        child: IconButton(
                            icon: BuildLoveIcon(
                                collectionName: 'event',
                                uid: sb.uid,
                                eventId: event.id),
                            onPressed: () {
                              handleLoveClick();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 300.h,
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.h),
                      boxShadow: [
                        BoxShadow(
                            color: shadowColor,
                            blurRadius: 27,
                            offset: const Offset(0, 8))
                      ]),
                ))
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.h),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerSpace(0.h),
              Center(
                child: Container(
                  height: 8.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                ),
              ),
              getVerSpace(20.h),
              Row(
                children: [
                  getCustomFont(
                    date ?? '',
                    15.sp,
                    greyColor,
                    1,
                    fontWeight: FontWeight.w500,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      height: 5.0,
                      width: 3.0,
                      color: greyColor.withOpacity(0.5),
                    ),
                  ),
                  getCustomFont(
                    event.time ?? '',
                    15.sp,
                    greyColor,
                    1,
                    fontWeight: FontWeight.w500,
                  )
                ],
              ),
              getCustomFont(event.title ?? '', 27.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(10.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 19.0,
                    backgroundColor: Colors.grey.withOpacity(0.11),
                    child: getAssetImage("calendar.png",
                        width: 22.h, height: 22.h),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(
                        date ?? '',
                        15.sp,
                        Colors.black,
                        1,
                        fontWeight: FontWeight.w700,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      //   child: Container(
                      //     height: 5.0,
                      //     width: 3.0,
                      //     color: greyColor.withOpacity(0.5),
                      //   ),
                      // ),
                      getCustomFont(
                        event.time ?? '',
                        15.sp,
                        greyColor,
                        1,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: 15,
              ),

              Row(
                children: [
                  CircleAvatar(
                    radius: 19.0,
                    backgroundColor: Colors.grey.withOpacity(0.11),
                    child: getAssetImage("location.png",
                        width: 22.h, height: 22.h),
                  ),
                  getHorSpace(10.h),
                  Container(
                    width: 310.w,
                    // color: Colors.yellow,
                    child: getCustomFont(
                      event.location ?? '',
                      17.sp,
                      Colors.black,
                      3,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),

              getVerSpace(20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  getCustomFont(
                    ('People Joined :').tr(),
                    17.sp,
                    Colors.black,
                    1,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  NumberWidget(count: event.joinEvent?.length),
                ],
              ),
              getVerSpace(15.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  getCustomFont(
                    ('Capacity :').tr(),
                    17.sp,
                    Colors.black,
                    1,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  NumberWidget(count: event.capacity, isExactNumber: true),
                ],
              ),
              getVerSpace(15.h),
              buildTicketPrice(),

              getVerSpace(20.h),
              getCustomFont(('Description').tr(), 19.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(20.h),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                ReadMoreText(
                  event.description ?? "",
                  trimLines: 8,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: ('Read more...').tr(),
                  trimExpandedText: ('Show less').tr(),
                  style: TextStyle(
                      fontFamily: 'Gilroy',
                      color: greyColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      height: 1.5.h),
                  lessStyle: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: accentColor),
                  moreStyle: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: accentColor),
                ),
              ),

              getVerSpace(45.h),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.h),
                    height: 150.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.h)),
                    child: GoogleMap(
                      trafficEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(event.mapsLatLink as double,
                            event.mapsLangLink as double),
                        zoom: 12,
                      ),
                      onMapCreated: _onMapCreated,
                      markers: {
                        Marker(
                          markerId: const MarkerId("marker1"),
                          position: LatLng(event.mapsLatLink as double,
                              event.mapsLangLink as double),
                          draggable: true,
                          onDragEnd: (value) {
                            // value is the new position
                          },
                          // To do: custom marker icon
                        ),

                        // Marker(
                        //   markerId: const MarkerId("marker2"),
                        //   position: const LatLng(37.415768808487435, -122.08440050482749),
                        // ),
                      },
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                  InkWell(
                    onTap: (() {
                      MapsSheet.show(
                        context: context,
                        onMapTap: (map) {
                          map.showDirections(
                            destination: Coords(event.mapsLatLink as double,
                                event.mapsLangLink as double),
                            directionsMode: DirectionsMode.driving,
                          );
                        },
                      );
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Container(
                        height: 150.h,
                        width: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.navigation_rounded,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              RotatedBox(
                                quarterTurns:
                                    3, // mengatur rotasi sebesar 90 derajat
                                child: Text(
                                  ('Navigate').tr(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: 'Gilroy',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              getVerSpace(80.h),
              /*getPaddingWidget(
                EdgeInsets.only(right: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCustomFont(
                        ("Upcoming Events").tr(), 19.sp, Colors.black, 1,
                        fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                                FeaturedEventDetail()));
                      },
                      child: getCustomFont(
                          ("View All").tr(), 15.sp, greyColor, 1,
                          fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                    )
                  ],
                ),
              ),
              getVerSpace(15.h),

              Container(
                height: 330.h,
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
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
              getVerSpace(16.h),*/
            ],
          ),
        ),
      ],
    );
  }
}
