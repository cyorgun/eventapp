import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/modal/modal_event.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../../base/constant.dart';
import '../../chat_logic/pages/chat_page.dart';
import '../../widget/love_icon.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/sign_in_bloc.dart';
import 'buy_ticket.dart';

class FeaturedEvent2Detail extends StatefulWidget {
 Event? event;
   FeaturedEvent2Detail({Key? key,
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
          body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      buildImageWidget(),
                      getVerSpace(77.h),
                      buildTicketPrice(),
                               
                      getVerSpace(20.h), 
                      buildFollowWidget(context),
                      getVerSpace(20.h),
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.h),
                        ReadMoreText(
                          event.description ??"",
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read more...',
                          trimExpandedText: 'Show less',
                          style: TextStyle(
                              color: greyColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.sp,
                              height: 1.5.h),
                          lessStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: accentColor),
                          moreStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: accentColor),
                        ),
                      ),
                      getVerSpace(30.h),
                      Container(
     margin: EdgeInsets.symmetric(horizontal: 20.h),
      height:  206.h,
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.h)),
      child: GoogleMap(
        trafficEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(event.mapsLatLink as double, event.mapsLangLink as double),
          zoom: 12,
        ),
        onMapCreated: _onMapCreated,
       markers: {
  Marker(
    markerId: const MarkerId("marker1"),
    position:  LatLng(event.mapsLatLink as double, event.mapsLangLink as double),
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
                      getVerSpace(22.h),
                       getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: 
              [
                
                  Container(
              height: 50.h,
              width: 50.h,
              margin: EdgeInsets.only(top: 18.h, right: 20.h),
              padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 13.h),
              decoration: BoxDecoration(
                  color: lightColor, borderRadius: BorderRadius.circular(22.h)),
              child: GestureDetector(
                  onTap: () {
                       Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    arguments: ChatPageArguments(
                      peerId: event.title??'',
                      peerAvatar: sb.imageUrl??'',
                      peerNickname: sb.name??'',
                    ),
                  ),
                ),
              );
                  },
                  child: getSvgImage("notification.svg",
                      height: 24.h, width: 24.h)),
            ),
                
                  getButton(context, accentColor, "Buy Ticket", Colors.white, () {
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> new BuyTicket(
           event: event,
          )));
        }, 18.sp,
              weight: FontWeight.w700,
              buttonHeight: 60.h,
              buttonWidth: MediaQuery.of(context).size.width - 120.h,
              borderRadius: BorderRadius.circular(22.h)),
            ],
      ),
    ),
                      getVerSpace(22.h),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
  handleLoveClick() {
     final Event event = widget.event!;
    context.read<BookmarkBloc>().onBookmarkIconClick(event.title);
  }
  Container buildLocationWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      height: 116.h,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("${Constant.assetImagePath}location_image.png"),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(22.h)),
    );
  }

  Widget buildButtonWidget(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getButton(context, accentColor, "Buy Ticket", Colors.white, () {
        Constant.sendToNext(context, Routes.buyTicketRoute);
      }, 18.sp,
          weight: FontWeight.w700,
          buttonHeight: 60.h,
          borderRadius: BorderRadius.circular(22.h)),
    );
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
                    CircleAvatar(backgroundImage: NetworkImage(event.image??''),radius: 20.0),
                  // getAssetImage("image.png", width: 58.h, height: 58.h),
                  getHorSpace(10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getCustomFont(event.userName??'', 18.sp, Colors.black, 1,
                          fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                      getVerSpace(1.h),
                      getCustomFont(event.userDesc??'', 15.sp, greyColor, 1,
                          fontWeight: FontWeight.w500, txtHeight: 1.46.h)
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
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      decoration: BoxDecoration(
          color: lightGrey, borderRadius: BorderRadius.circular(22.h)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          getRichText("Ticket Price ", Colors.black, FontWeight.w600, 15.sp,
             "", greyColor, FontWeight.w500, 13.sp),
          getCustomFont( "\$"+event.price.toString()??"", 20.sp, Colors.black, 1,
              fontWeight: FontWeight.w700)
        ],
      ),
    );
  }

  Stack buildImageWidget() {
    
    final sb = context.watch<SignInBloc>();
     final Event event = widget.event!;
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 327.h,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(22.h)),
              image: DecorationImage(
                  image: NetworkImage(
                  event.image??''),
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
                  GestureDetector(
                    onTap: () {
                      backClick();
                    },
                    child: getSvgImage("arrow_back.svg",
                        width: 24.h, height: 24.h, color: Colors.white),
                  ),
                  Container(
                    width: 45.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
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
            top: 255.h,
            width: 374.w,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.h),
                  boxShadow: [
                    BoxShadow(
                        color: shadowColor,
                        blurRadius: 27,
                        offset: const Offset(0, 8))
                  ]),
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getVerSpace(16.h),
                  getCustomFont(event.title??'', 22.sp, Colors.black, 1,
                      fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                  getVerSpace(10.h),
                  Row(
                    children: [
                      getSvgImage("location.svg",
                          height: 20.h, width: 20.h, color: greyColor),
                      getHorSpace(5.h),
                      getCustomFont(
                        event.location??'',
                        15.sp,
                        greyColor,
                        1,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  ),
                  getVerSpace(10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          getSvgImage("calender.svg",
                              width: 20.h, height: 20.h),
                          getHorSpace(5.h),
                          getCustomFont(
                            event.date??'',
                            15.sp,
                            greyColor,
                            1,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),

                         Expanded(
                           child: StreamBuilder(
                             stream: FirebaseFirestore.instance
                                 .collection("JoinEvent")
                                 .doc("user")
                                 .collection(event.title??'')
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
                      // Row(
                      //   children: [
                      //     Container(
                      //       padding: EdgeInsets.only(right: 67.h),
                      //       child: Stack(
                      //         clipBehavior: Clip.none,
                      //         children: [
                      //           getAssetImage("view1.png",
                      //               width: 36.h, height: 36.h),
                      //           Positioned(
                      //               left: 22.h,
                      //               child: Stack(
                      //                 clipBehavior: Clip.none,
                      //                 children: [
                      //                   getAssetImage("view2.png",
                      //                       height: 36.h, width: 36.h),
                      //                   Positioned(
                      //                       left: 22.h,
                      //                       child: Stack(
                      //                         clipBehavior: Clip.none,
                      //                         children: [
                      //                           getAssetImage("view3.png",
                      //                               height: 36.h, width: 36.h),
                      //                           Positioned(
                      //                               left: 22.h,
                      //                               child: Container(
                      //                                 height: 36.h,
                      //                                 width: 36.h,
                      //                                 decoration: BoxDecoration(
                      //                                     color: accentColor,
                      //                                     borderRadius:
                      //                                         BorderRadius
                      //                                             .circular(
                      //                                                 30.h),
                      //                                     border: Border.all(
                      //                                         color:
                      //                                             Colors.white,
                      //                                         width: 1.5.h)),
                      //                                 alignment:
                      //                                     Alignment.center,
                      //                                 child: getCustomFont(
                      //                                     "+50",
                      //                                     12.sp,
                      //                                     Colors.white,
                      //                                     1,
                      //                                     fontWeight:
                      //                                         FontWeight.w600),
                      //                               ))
                      //                         ],
                      //                       ))
                      //                 ],
                      //               )),
                      //         ],
                      //       ),
                      //     )
                  
                  
                 
                      //   ],
                      // )
                    ],
                  ),
                  getVerSpace(16.h),
        
                ],
              ),
            ))
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
                itemCount:  list!.length > 3 ? 3 : list?.length,
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
                                  image: NetworkImage(_img??''),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ],
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0.0, left: 130.0,),
          child: Row(
            children: [
                 Positioned(
                                                    left: 22.h,
                                                    child: Container(
                                                      height: 36.h,
                                                      width: 36.h,
                                                      decoration: BoxDecoration(
                                                          color: accentColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.h),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1.5.h)),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: 
                                                                  [getCustomFont(
                                                            list?.length.toString() ??'',
                                                            12.sp,
                                                            Colors.white,
                                                            1,
                                                            fontWeight:
                                                                  FontWeight.w600),
                                                                  getCustomFont(
                                                             " +",
                                                            12.sp,
                                                            Colors.white,
                                                            1,
                                                            fontWeight:
                                                                  FontWeight.w600),
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


