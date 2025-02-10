import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';
import '../view/featured_event/featured_event_detail2.dart';

class Card4 extends StatelessWidget {
  final EventBaru events;
  final String heroTag;

  const Card4({Key? key, required this.events, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? dateTime = events!.date?.toDate();
    String date = DateFormat('d MMMM, yyyy').format(dateTime!);
    return InkWell(
        child: Container(
          height: 150.0,
          margin: EdgeInsets.only(bottom: 20.h, left: 20.0, right: 20.0),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: shadowColor,
                    blurRadius: 27,
                    offset: const Offset(0, 8))
              ],
              borderRadius: BorderRadius.circular(22.h)),
          padding:
              EdgeInsets.only(top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 102,
                      width: 102,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          image: DecorationImage(
                              image: NetworkImage(
                                events?.image ?? '',
                              ),
                              fit: BoxFit.cover)),
                    ),
                    // Image.network(event.image??'',height: 82,width: 82,),
                    // getAssetImage(event.image ?? "",
                    //     width: 82.h, height: 82.h),
                    getHorSpace(10.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200.w,
                            child: getCustomFont(
                                events?.title ?? "", 20.5.sp, Colors.black, 1,
                                fontWeight: FontWeight.w700,
                                txtHeight: 1.5.h,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  getSvg("calender.svg",
                                      color: accentColor,
                                      width: 16.h,
                                      height: 16.h),
                                  getHorSpace(5.h),
                                  getCustomFont(date.toString() ?? "", 15.sp,
                                      greyColor, 1,
                                      fontWeight: FontWeight.w500,
                                      txtHeight: 1.5.h),
                                ],
                              ),
                              getVerSpace(2.h),
                              Row(
                                children: [
                                  getSvg("Location.svg",
                                      color: accentColor,
                                      width: 18.h,
                                      height: 18.h),
                                  getHorSpace(5.h),
                                  Container(
                                    width: 150.w,
                                    child: getCustomFont(events?.location ?? "",
                                        15.sp, greyColor, 1,
                                        fontWeight: FontWeight.w500,
                                        txtHeight: 1.5.h),
                                  ),
                                ],
                              ),
                              getVerSpace(7.h),
                              Row(
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection("JoinEvent")
                                        .doc("user")
                                        .collection(events.title ?? '')
                                        .snapshots(),
                                    builder: (BuildContext ctx,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      return snapshot.hasData
                                          ? new joinEvents(
                                              list: snapshot.data?.docs,
                                            )
                                          : Container();
                                    },
                                  ),
                                  Container(
                                    height: 35.h,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                        color: accentColor.withOpacity(0.051),
                                        borderRadius:
                                            BorderRadius.circular(50.h)),
                                    child: Center(
                                        child: Text(
                                      "\$ " + (events?.price.toString() ?? ""),
                                      style: TextStyle(
                                          color: accentColor,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new FeaturedEvent2Detail(
                    event: events,
                  )));
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
