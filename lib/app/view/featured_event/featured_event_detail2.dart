import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import 'package:evente/evente.dart';
import '../../../base/constant.dart';
import '../../chat_logic/pages/chat_page.dart';
import '../../widget/empty_screen.dart';
import '../../widget/love_icon.dart';
import 'package:evente/evente.dart';
import '../../widget/map_sheet.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/sign_in_bloc.dart';
import '../home/tab/tab_home.dart';
import 'buy_ticket.dart';

class FeaturedEvent2Detail extends StatefulWidget {
  Event? event;
  FeaturedEvent2Detail({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  State<FeaturedEvent2Detail> createState() => _FeaturedEvent2DetailState();
}

class _FeaturedEvent2DetailState extends State<FeaturedEvent2Detail> {
  void backClick() {
    Constant.backToPrev(context);
  }

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final Event event = widget.event!;

    return WillPopScope(
        onWillPop: () async {
          backClick();
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: ListView(
                  children: [
                    buildImageWidget(),
                  ],
                ),
              ),
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
                        Center(
                          child: Container(
                            height: 55.h,
                            width: 55.h,
                            margin: EdgeInsets.only(top: 0.h, right: 20.h),
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
                                      builder: (context) => ChatPage(
                                        arguments: ChatPageArguments(
                                          peerId: event.title ?? '',
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
                        ),
                        getButton(
                            context, accentColor, "Buy Ticket", Colors.white,
                            () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new BuyTicket(
                                    event: event,
                                  )));
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            buttonWidth:
                                MediaQuery.of(context).size.width - 148.h,
                            borderRadius: BorderRadius.circular(22.h)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  handleLoveClick() {
    final Event event = widget.event!;
    context.read<BookmarkBloc>().onBookmarkIconClick(event.title);
  }

  Widget buildFollowWidget(BuildContext context) {
    final Event event = widget.event!;
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Container(
        // decoration: BoxDecoration(
        //     color: lightGrey, borderRadius: BorderRadius.circular(22.h)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                      backgroundImage: NetworkImage(event.image ?? ''),
                      radius: 20.0),
                  // getAssetImage("image.png", width: 58.h, height: 58.h),
                  getHorSpace(10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(
                          event.userName ?? '', 18.sp, Colors.black, 1,
                          fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                    ],
                  )
                ],
              ),
              // getButton(context, Colors.white, "Follow", accentColor, () {}, 14.sp,
              //     weight: FontWeight.w700,
              //     buttonHeight: 40.h,
              //     buttonWidth: 76.h,
              //     isBorder: true,
              //     borderColor: accentColor,
              //     borderWidth: 1.h,
              //     borderRadius: BorderRadius.circular(14.h))
            ],
          ),
        ),
      ),
    );
  }

  Container buildTicketPrice() {
    final Event event = widget.event!;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      decoration: BoxDecoration(
          color: accentColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(22.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              getSvgImage("ticket.svg",
                  width: 24.h, height: 24.h, color: Colors.black),
              getHorSpace(5.h),
              getRichText("Ticket Price ", Colors.black, FontWeight.w600, 15.sp,
                  "", greyColor, FontWeight.w500, 13.sp),
            ],
          ),
          getCustomFont(
              "\$" + event.price.toString() ?? "", 20.sp, Colors.black, 1,
              fontWeight: FontWeight.w700)
        ],
      ),
    );
  }

  Widget buildImageWidget() {
    final sb = context.watch<SignInBloc>();
    final Event event = widget.event!;

    DateTime? dateTime = event.date?.toDate();
    String date = DateFormat('d MMMM, yyyy').format(dateTime!);
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 327.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  // borderRadius:
                  //     BorderRadius.vertical(bottom: Radius.circular(22.h)),
                  image: DecorationImage(
                      image: NetworkImage(event.image ?? ''),
                      fit: BoxFit.cover)),
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
                            backClick();
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
                                timestamp: event.title),
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
        Positioned(
            top: 295.h,
            // width: 374.w,
            child: Container(
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
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
                      getSvg("Location.svg",
                          height: 20.h, width: 20.h, color: accentColor),
                      getHorSpace(5.h),
                      Container(
                        width: 300.w,
                        child: getCustomFont(
                          event.location ?? '',
                          17.sp,
                          greyColor,
                          1,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         getSvg(
                  //           "calender.svg",
                  //           width: 20.h,
                  //           height: 20.h,
                  //           color: accentColor,
                  //         ),
                  //         getHorSpace(5.h),
                  //         getCustomFont(
                  //           date ?? '',
                  //           17.sp,
                  //           greyColor,
                  //           1,
                  //           fontWeight: FontWeight.w500,
                  //         )
                  //       ],
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Row(
                  //           children: [
                  //             getSvg("time.svg",
                  //                 width: 19.h,
                  //                 height: 19.h,
                  //                 color: accentColor),
                  //             getHorSpace(5.h),
                  //             getCustomFont(
                  //               event.time ?? '',
                  //               17.sp,
                  //               greyColor,
                  //               1,
                  //               fontWeight: FontWeight.w500,
                  //             )
                  //           ],
                  //         ),
                  //         Container(
                  //           width: 100.w,
                  //           height: 30.h,
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  getVerSpace(15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont(
                        'People Joined :',
                        17.sp,
                        greyColor,
                        1,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        width: 20.w,
                        height: 30.h,
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("JoinEvent")
                              .doc("user")
                              .collection(event.title ?? '')
                              .snapshots(),
                          builder: (BuildContext ctx,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            return snapshot.hasData
                                ? new joinEvent(
                                    list: snapshot.data?.docs,
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),

                  getVerSpace(20.h),
                  buildTicketPrice(),
                  getVerSpace(20.h),
                  getCustomFont('Description', 19.sp, Colors.black, 1,
                      fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                  getVerSpace(20.h),
                  getPaddingWidget(
                    EdgeInsets.symmetric(horizontal: 20.h),
                    ReadMoreText(
                      event.description ?? "",
                      trimLines: 8,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Read more...',
                      trimExpandedText: 'Show less',
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

                  // getVerSpace(20.h),
                  // buildFollowWidget(context),
                  // getVerSpace(20.h),

                  getVerSpace(45.h),
                  Stack(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.h),
                          height: 206.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22.h)),
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
                          padding: const EdgeInsets.only(left:5.0),
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
                                      'Navigate',
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
                  getVerSpace(45.h),
                  getPaddingWidget(
                    EdgeInsets.only(right: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont("Upcoming Events", 19.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        GestureDetector(
                          onTap: () {
                            Constant.sendToNext(
                                context, Routes.featureEventListRoute);
                          },
                          child: getCustomFont("View All", 15.sp, greyColor, 1,
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                  getVerSpace(16.h),
                ],
              ),
            )),

        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: getPaddingWidget(
        //     EdgeInsets.symmetric(horizontal: 20.h),
        //     Container(
        //       color: Colors.white,
        //       child: Row(
        //         children: [
        //           Center(
        //             child: Container(
        //               height: 55.h,
        //               width: 55.h,
        //               margin: EdgeInsets.only(top: 0.h, right: 20.h),
        //               padding: EdgeInsets.symmetric(
        //                   vertical: 13.h, horizontal: 13.h),
        //               decoration: BoxDecoration(
        //                   color: accentColor.withOpacity(0.09),
        //                   borderRadius: BorderRadius.circular(22.h)),
        //               child: GestureDetector(
        //                   onTap: () {
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                         builder: (context) => ChatPage(
        //                           arguments: ChatPageArguments(
        //                             peerId: event.title ?? '',
        //                             peerAvatar: sb.imageUrl ?? '',
        //                             peerNickname: sb.name ?? '',
        //                           ),
        //                         ),
        //                       ),
        //                     );
        //                   },
        //                   child: getSvg("message.svg",
        //                       color: accentColor, height: 24.h, width: 24.h)),
        //             ),
        //           ),
        //           getButton(context, accentColor, "Buy Ticket", Colors.white,
        //               () {
        //             Navigator.of(context).push(PageRouteBuilder(
        //                 pageBuilder: (_, __, ___) => new BuyTicket(
        //                       event: event,
        //                     )));
        //           }, 18.sp,
        //               weight: FontWeight.w700,
        //               buttonHeight: 60.h,
        //               buttonWidth: MediaQuery.of(context).size.width - 148.h,
        //               borderRadius: BorderRadius.circular(22.h)),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class joinEvent extends StatelessWidget {
  joinEvent({this.list});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Container(
              height: 35.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list!.length > 3 ? 3 : list?.length,
                itemBuilder: (context, i) {
                  String? _title = list?[i]['name'].toString();
                  String? _uid = list?[i]['uid'].toString();
                  String? _img = list?[i]['photoProfile'].toString();

                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Container(
                          height: 27.0,
                          width: 27.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(
                                  image: NetworkImage(_img ?? ''),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 0.0,
            left: 130.0,
          ),
          child: Row(
            children: [
              Positioned(
                  left: 22.h,
                  child: Container(
                    height: 36.h,
                    width: 36.h,
                    decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(30.h),
                        border: Border.all(color: Colors.white, width: 1.5.h)),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getCustomFont(list?.length.toString() ?? '', 12.sp,
                            Colors.white, 1,
                            fontWeight: FontWeight.w600),
                        getCustomFont(" +", 12.sp, Colors.white, 1,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                  )),

              // Text(
              //   list?.length.toString()??'',
              //   style: TextStyle(fontFamily: "Popins"),
              // ),
              //  Text(
              //   " People Join",
              //   style: TextStyle(fontFamily: "Popins"),
              // ),
            ],
          ),
        )
      ],
    );
  }
}
