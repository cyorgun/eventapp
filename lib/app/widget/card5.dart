import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/widget/join_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';
import '../provider/bookmark_provider.dart';
import '../provider/sign_in_provider.dart';
import '../routes/app_routes.dart';
import '../view/featured_event/featured_event_detail.dart';
import 'love_icon.dart';

class Card5 extends StatelessWidget {
  final EventBaru events;
  final String heroTag;

  const Card5({Key? key, required this.events, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInProvider>();
    DateTime? dateTime = events!.date?.toDate();
    String date = DateFormat('d MMMM, yyyy').format(dateTime!);

    handleLoveClick() {
      context.read<BookmarkProvider>().onBookmarkIconClick(events.id, context.read<SignInProvider>().uid);
    }

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: events);
      },
      child: Container(
        width: 374.h,
        // height: 196.h,
        margin: EdgeInsets.only(right: 10.h, left: 10.h, top: 0.0, bottom: 0.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.h),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: shadowColor, blurRadius: 27, offset: const Offset(0, 8))
          ],
          // image: DecorationImage(
          //     image: NetworkImage(events?[i].image ?? ''),
          //     fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              height: 196.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.h),
              ),
              padding: EdgeInsets.only(left: 24.h),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      height: 120.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        image: DecorationImage(
                            image: NetworkImage(events?.image ?? ''),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 130.0,
                              child: getCustomFont(
                                  events?.title ?? "", 20.5.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                  txtHeight: 1.5.h),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 10.0),
                                child: Container(
                                  width: 45.0,
                                  height: 45.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      color: Colors.white),
                                  child: IconButton(
                                      icon: BuildLoveIcon(
                                          collectionName: 'event',
                                          uid: sb.uid,
                                          eventId: events.id),
                                      onPressed: () {
                                        handleLoveClick();
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
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
                              width: 150.0,
                              child: getCustomFont(
                                  events?.location ?? "", 15.sp, greyColor, 1,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.5.h),
                            ),
                          ],
                        ),
                        getVerSpace(7.h),
                        NumberWidget(count: events.joinEvent?.length)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 15.0),
                  child: Container(
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
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
