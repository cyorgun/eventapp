import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/controller/controller.dart';
import 'package:event_app/app/view/featured_event/featured_event_detail2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../modal/modal_event.dart';
import '../../modal/modal_popular_event.dart';
import '../home/search_screen.dart';
import '../home/tab/tab_home.dart';

class PopularEventList extends StatefulWidget {
  const PopularEventList({Key? key}) : super(key: key);

  @override
  State<PopularEventList> createState() => _PopularEventListState();
}

class _PopularEventListState extends State<PopularEventList> {
  void backClick() {
    Constant.backToPrev(context);
  }

  PopularEventController controller = Get.put(PopularEventController());

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: getToolBar(() {
          backClick();
        },
            title: getCustomFont(
              "All Popular Events",
              24.sp,
              Colors.black,
              1,
              fontWeight: FontWeight.w700,
            )),
        body: SafeArea(
          child: Column(
            children: [
              getDivider(
                dividerColor,
                1.h,
              ),
              getVerSpace(16.h),
              buildSearchWidget(context),
              getVerSpace(24.h),
   StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("event")
                      .where('type', isEqualTo: 'popular')
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? new buildPopularEventList(
                            list: snapshot.data?.docs,
                          )
                        : Container();
                  },
                ),
              // Expanded(
              //     child: GetBuilder<PopularEventController>(
              //   init: PopularEventController(),
              //   builder: (controller) => ListView.builder(
              //     padding: EdgeInsets.symmetric(horizontal: 20.h),
              //     itemCount: controller.newPopularEventLists.length,
              //     primary: false,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       ModalPopularEvent modalPopularEvent =
              //           controller.newPopularEventLists[index];
              //       return Container(
              //         margin: EdgeInsets.only(bottom: 20.h),
              //         decoration: BoxDecoration(
              //             color: Colors.white,
              //             boxShadow: [
              //               BoxShadow(
              //                   color: shadowColor,
              //                   blurRadius: 27,
              //                   offset: const Offset(0, 8))
              //             ],
              //             borderRadius: BorderRadius.circular(22.h)),
              //         padding: EdgeInsets.only(
              //             top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Row(
              //                 children: [
              //                   getAssetImage(modalPopularEvent.image ?? "",
              //                       width: 82.h, height: 82.h),
              //                   getHorSpace(10.h),
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       getCustomFont(modalPopularEvent.name ?? "",
              //                           18.sp, Colors.black, 1,
              //                           fontWeight: FontWeight.w600,
              //                           txtHeight: 1.5.h),
              //                       getVerSpace(4.h),
              //                       getCustomFont(modalPopularEvent.date ?? '',
              //                           15.sp, greyColor, 1,
              //                           fontWeight: FontWeight.w500,
              //                           txtHeight: 1.46.h)
              //                     ],
              //                   )
              //                 ],
              //               ),
              //             ),
              //             Container(
              //               height: 34.h,
              //               decoration: BoxDecoration(
              //                   color: lightAccent,
              //                   borderRadius: BorderRadius.circular(12.h)),
              //               alignment: Alignment.center,
              //               padding: EdgeInsets.symmetric(horizontal: 12.h),
              //               child: getCustomFont(modalPopularEvent.price ?? '',
              //                   15.sp, accentColor, 1,
              //                   fontWeight: FontWeight.w600, txtHeight: 1.46.h),
              //             )
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ))
   
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchWidget(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getDefaultTextFiledWithLabel(
          context, "Search events...", controller.searchController,
          isEnable: false,
            onTap: () {
                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> new SearchPage()));
    
          },
          isprefix: true,
          prefix: Row(
            children: [
              getHorSpace(18.h),
              getSvgImage("search.svg", height: 24.h, width: 24.h),
            ],
          ),
          constraint: BoxConstraints(maxHeight: 24.h, maxWidth: 55.h),
          vertical: 18,
          horizontal: 16,
          onChanged: controller.onItemChanged),
    );
  }
}



class buildPopularEventList2 extends StatelessWidget {
    final List<DocumentSnapshot>? list;
  const buildPopularEventList2({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
      itemBuilder: (context,i){
          final events = list?.map((e) {
            return Event.fromFirestore(e);
          }).toList();

        //  String? category = list?[i]['category'].toString();
        //   String? date = list?[i]['date'].toString();
        //   String? image = list?[i]['image'].toString();
        //   String? description = list?[i]['description'].toString();
        //   String? id = list?[i]['id'].toString();
        //   String? location = list?[i]['location'].toString();
        //   double? mapsLangLink = list?[i]['mapsLangLink'];
        //   double? mapsLatLink = list?[i]['mapsLatLink'];
        //   int? price = list?[i]['price'];
        //   String? title = list?[i]['title'].toString();
        //   String? type = list?[i]['type'].toString();
        //   String? userDesc = list?[i]['userDesc'].toString();
        //   String? userName = list?[i]['userName'].toString();
        //   String? userProfile = list?[i]['userProfile'].toString();


        return InkWell(
            onTap: (){

Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> FeaturedEvent2Detail(
   event: events?[i],

)));
          },
          child: Container(
                        margin: EdgeInsets.only(bottom: 20.h),
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
                            Expanded(
                              child: Row(
                                children: [
                                  getAssetImage(events?[i].image ?? "",
                                      width: 82.h, height: 82.h),
                                  getHorSpace(10.h),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      getCustomFont(events?[i].title ?? "",
                                          18.sp, Colors.black, 1,
                                          fontWeight: FontWeight.w600,
                                          txtHeight: 1.5.h),
                                      getVerSpace(4.h),
                                      getCustomFont(events?[i].date ?? '',
                                          15.sp, greyColor, 1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.46.h)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 34.h,
                              decoration: BoxDecoration(
                                  color: lightAccent,
                                  borderRadius: BorderRadius.circular(12.h)),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 12.h),
                              child: getCustomFont(events?[i].price.toString() ?? '',
                                  15.sp, accentColor, 1,
                                  fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                            )
                          ],
                        ),
                      ),
        );
      },
    );
  }
}