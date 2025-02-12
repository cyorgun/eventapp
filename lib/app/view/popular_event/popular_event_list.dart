import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/view/featured_event/featured_event_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../routes/app_routes.dart';
import '../../widget/empty_screen.dart';
import '../home/search_screen.dart';
import '../home/tab/tab_home.dart';

class PopularEventList extends StatefulWidget {
  const PopularEventList({Key? key}) : super(key: key);

  @override
  State<PopularEventList> createState() => _PopularEventListState();
}

class _PopularEventListState extends State<PopularEventList> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    setStatusBarColor(Colors.white);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
            title: getCustomFont(
              ("Popular Event").tr(),
              22.sp,
              Colors.black,
              1,
              fontWeight: FontWeight.w700,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: InkWell(
                    onTap: (() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new SearchPage()));
                    }),
                    child: getSvg('search.svg',
                        color: accentColor, height: 20.0, width: 20.0)),
              ),
            ]),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("event")
                  .orderBy('count', descending: true)
                  .snapshots(),
              builder:
                  (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: EmptyScreen());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }

                return snapshot.hasData
                    ? TrendingEventCard(
                        list: snapshot.data?.docs,
                      )
                    : Container();
              },
            ),
          ),
        ));
  }
}

class buildFeatureEventList2 extends StatelessWidget {
  final List<DocumentSnapshot>? list;

  const buildFeatureEventList2({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list?.length,
      itemBuilder: (context, i) {
        final events = list?.map((e) {
          return EventBaru.fromFirestore(e, 1);
        }).toList();
        //  String? category = list?[i]['category'].toString();
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

        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: events?[i]);
          },
          child: Container(
            width: 374.h,
            height: 190.h,
            margin: EdgeInsets.only(right: 20.h, left: 20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.h),
              image: DecorationImage(
                  image: NetworkImage(events?[i].image ?? ''),
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
                      getCustomFont(
                          events?[i].userName ?? "", 20.sp, Colors.white, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      getVerSpace(4.h),
                      Row(
                        children: [
                          getSvgImage("location.svg",
                              width: 20.h, height: 20.h),
                          getHorSpace(5.h),
                          getCustomFont(
                              events?[i].location ?? "", 15.sp, Colors.white, 1,
                              fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                        ],
                      ),
                      getVerSpace(22.h),
                      getButton(context, accentColor, ("Book Now").tr(),
                          Colors.white, () {}, 14.sp,
                          weight: FontWeight.w700,
                          buttonHeight: 40.h,
                          borderRadius: BorderRadius.circular(14.h),
                          buttonWidth: 111.h)
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
