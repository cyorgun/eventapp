import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';
import '../view/featured_event/featured_event_detail2.dart';
import '../view/home/tab/tab_home.dart';

class Card4 extends StatelessWidget {
  final Event events;
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
        padding: EdgeInsets.only(top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
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
                                color: accentColor, width: 16.h, height: 16.h),
                            getHorSpace(5.h),
                            getCustomFont(
                                date.toString() ?? "", 15.sp, greyColor, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          ],
                        ),
                        getVerSpace(2.h),
                        Row(
                          children: [
                            getSvg("Location.svg",
                                color: accentColor, width: 18.h, height: 18.h),
                            getHorSpace(5.h),
                            Container(
                          width: 150.w,
                              child: getCustomFont(
                                  events?.location ?? "", 15.sp, greyColor, 1,
                                  fontWeight: FontWeight.w500, txtHeight: 1.5.h),
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
                  borderRadius: BorderRadius.circular(50.h)),
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
      }
    );
  }
}
