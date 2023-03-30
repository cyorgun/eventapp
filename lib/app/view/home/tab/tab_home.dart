import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/controller/controller.dart';
import 'package:event_app/app/data/data_file.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/bloc/sign_in_bloc.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/constant.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../chat_logic/pages/chat_page.dart';
import '../../../dialog/loading_cards.dart';
import '../../../modal/modal_event.dart';
import '../../../modal/modal_event_category.dart';
import '../../../modal/modal_feature_event.dart';
import '../../../modal/modal_popular_event.dart';
import '../../../modal/modal_trending_event.dart';
import '../../bloc/event_bloc.dart';
import '../../featured_event/featured_event_detail2.dart';
import '../search_screen.dart';

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> {
  HomeScreenController controller = Get.put(HomeScreenController());
  List<ModalEventCategory> eventCategoryLists = DataFile.eventCategoryList;
  List<ModalTrendingEvent> trendingEventLists = DataFile.trendingEventList;
  List<ModalPopularEvent> popularEventLists = DataFile.popularEventList;
  List<ModalFeatureEvent> featureEventLists = DataFile.featureEventList;

  @override
  void initState() {
    super.initState();
    getFromSharedPreferences();
    if (this.mounted) {
      context.read<EventBloc>().data.isNotEmpty
          ? print('data already loaded')
          : context.read<EventBloc>().getDataPopular(mounted);
    }
    if (this.mounted) {
      context.read<EventBloc>().data2.isNotEmpty
          ? print('data already loaded 2')
          : context.read<EventBloc>().getDataTrending(mounted);
    }
  }

  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      role = prefs.getString("role");
    });
  }

  String? role;

  @override
  Widget build(BuildContext context) {
    final cb = context.watch<EventBloc>();
    final sb = context.watch<SignInBloc>();
    setStatusBarColor(accentColor);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/background.jpg',),fit: BoxFit.cover)
              ),
                child: Column(children: [
                  const SizedBox(height: 35.0,),
                  buildAppBar(),
            getVerSpace(63.h),
            getVerSpace(4.h),
                ])),
                
        Padding(
          padding: const EdgeInsets.only(top:130.0),
          child: buildSearchWidget(context),
        ),
          ],
        ),
        SizedBox(height: 30.0,),
        Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Featured Events", 20.sp, Colors.black, 1,
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
                if (role == "users") const Text("dsadsadsadasdsa"),
                getVerSpace(12.h),
                Container(
                  height: 194.h,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("event")
                        .where('type', isEqualTo: 'feature')
                        .snapshots(),
                    builder: (BuildContext ctx,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.hasData
                          ? buildFeatureEventList(
                              list: snapshot.data?.docs,
                            )
                          : Container();
                    },
                  ),
                ),
                // buildFeatureEventList(context),
                getVerSpace(24.h),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Trending Events", 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      GestureDetector(
                        onTap: () {
                          Constant.sendToNext(
                              context, Routes.trendingScreenRoute);
                        },
                        child: getCustomFont("View All", 15.sp, greyColor, 1,
                            fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      )
                    ],
                  ),
                ),
                getVerSpace(12.h),
                Container(
                  height: 300.0,
                  child: DefaultTabController(
                    length: 5,
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(
                            45.0), // here the desired height
                        // ignore: unnecessary_new
                        child: new AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                            centerTitle: true,
                            automaticallyImplyLeading: false,
                            title: TabBar(
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.tab,
                              unselectedLabelColor: Colors.black,
                              labelColor: Colors.white,
                              labelStyle: const TextStyle(fontSize: 19.0),
                              // ignore: unnecessary_new
                              // ignore: prefer_const_constr
                              indicator: BubbleTabIndicator(
                                indicatorHeight: 45.0,
                                indicatorColor: accentColor,
                                tabBarIndicatorSize: TabBarIndicatorSize.tab,
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
                                        const Text(
                                          "All",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
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
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetImage(
                                                    "event1.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Art",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
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
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetImage(
                                                    "event2.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Music",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
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
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetImage(
                                                    "event3.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Sporth",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
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
                                              padding: const EdgeInsets.only(
                                                  top: 2.0, bottom: 2.0),
                                              child: Container(
                                                height: 44.h,
                                                width: 44.h,
                                                decoration: BoxDecoration(
                                                    color: lightAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.h)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 9.h,
                                                    vertical: 9.h),
                                                child: getAssetImage(
                                                    "event1.png",
                                                    height: 26.h,
                                                    width: 26.h),
                                              ),
                                            ),
                                            getHorSpace(6.h),
                                          ],
                                        ),
                                        const Text(
                                          "Art",
                                          style: TextStyle(
                                              fontFamily: Constant.fontsFamily,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600),
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
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("event")
                                    .where('type', isEqualTo: 'trending')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingEventCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("event")
                                    .where('type', isEqualTo: 'trending')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingEventCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("event")
                                    .where('type', isEqualTo: 'trending')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingEventCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("event")
                                    .where('type', isEqualTo: 'trending')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingEventCard(
                                          list: snapshot.data?.docs,
                                        )
                                      : Container();
                                },
                              ),
                            ),
                            Container(
                              height: 290.0,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("event")
                                    .where('type', isEqualTo: 'trending')
                                    .snapshots(),
                                builder: (BuildContext ctx,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  return snapshot.hasData
                                      ? TrendingEventCard(
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
                //           ? TrendingEventCard(
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
                getVerSpace(20.h),
                // buildTrendingEventList(),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getCustomFont("Popular Events", 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      GestureDetector(
                        onTap: () {
                          Constant.sendToNext(
                              context, Routes.popularEventListRoute);
                        },
                        child: getCustomFont("View All", 15.sp, greyColor, 1,
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
                      .where('type', isEqualTo: 'popular')
                      .snapshots(),
                  builder: (BuildContext ctx,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.hasData
                        ? buildPopularEventList(
                            list: snapshot.data?.docs,
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
    );
  }

  // Widget buildPopularEventList(Event event) {
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

  SizedBox buildTrendingCategoryList() {
    return SizedBox(
      height: 50.h,
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: eventCategoryLists.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          ModalEventCategory modalEventCategory = eventCategoryLists[index];
          return GestureDetector(
            onTap: () {
              controller.onChange(index.obs);
            },
            child: GetX<HomeScreenController>(
              init: HomeScreenController(),
              builder: (controller) => Container(
                margin:
                    EdgeInsets.only(right: 12.h, left: index == 0 ? 20.h : 0),
                height: 50.h,
                decoration: BoxDecoration(
                    color: controller.select.value == index
                        ? accentColor
                        : lightColor,
                    borderRadius: BorderRadius.circular(22.h)),
                alignment: Alignment.center,
                child: modalEventCategory.image == ""
                    ? getPaddingWidget(
                        EdgeInsets.symmetric(
                          horizontal: 20.h,
                        ),
                        getCustomFont(
                            modalEventCategory.name ?? "",
                            16.sp,
                            controller.select.value == index
                                ? Colors.white
                                : Colors.black,
                            1,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center),
                      )
                    : Row(
                        children: [
                          Row(
                            children: [
                              getPaddingWidget(
                                EdgeInsets.only(
                                    left: 3.h, top: 3.h, bottom: 3.h),
                                Container(
                                  height: 44.h,
                                  width: 44.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(20.h)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 9.h, vertical: 9.h),
                                  child: getAssetImage(
                                      modalEventCategory.image ?? "",
                                      height: 26.h,
                                      width: 26.h),
                                ),
                              ),
                              getHorSpace(10.h),
                            ],
                          ),
                          getCustomFont(
                            modalEventCategory.name ?? '',
                            16.sp,
                            controller.select.value == index
                                ? Colors.white
                                : Colors.black,
                            1,
                            fontWeight: FontWeight.w600,
                          ),
                          getHorSpace(13.h)
                        ],
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  // SizedBox buildFeatureEventList(BuildContext context) {
  //   return SizedBox(
  //     height: 196.h,
  //     child: ListView.builder(
  //       primary: false,
  //       shrinkWrap: true,
  //       scrollDirection: Axis.horizontal,
  //       itemCount: featureEventLists.length,
  //       itemBuilder: (context, index) {
  //         ModalFeatureEvent modalFeatureEvent = featureEventLists[index];
  //         return Container(
  //           width: 374.h,
  //           height: 196.h,
  //           margin: EdgeInsets.only(right: 20.h, left: index == 0 ? 20.h : 0),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(22.h),
  //             image: DecorationImage(
  //                 image: AssetImage(Constant.assetImagePath +
  //                     modalFeatureEvent.image.toString()),
  //                 fit: BoxFit.fill),
  //           ),
  //           child: GestureDetector(
  //             onTap: () {
  //               Constant.sendToNext(context, Routes.featuredEventDetailRoute);
  //             },
  //             child: Stack(
  //               children: [
  //                 Container(
  //                   height: 196.h,
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(22.h),
  //                       gradient: LinearGradient(
  //                           colors: [
  //                             "#000000".toColor().withOpacity(0.0),
  //                             "#000000".toColor().withOpacity(0.88)
  //                           ],
  //                           stops: const [
  //                             0.0,
  //                             1.0
  //                           ],
  //                           begin: Alignment.centerRight,
  //                           end: Alignment.centerLeft)),
  //                   padding: EdgeInsets.only(left: 24.h),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       getCustomFont(modalFeatureEvent.name ?? "", 20.sp,
  //                           Colors.white, 1,
  //                           fontWeight: FontWeight.w700, txtHeight: 1.5.h),
  //                       getVerSpace(4.h),
  //                       Row(
  //                         children: [
  //                           getSvgImage("location.svg",
  //                               width: 20.h, height: 20.h),
  //                           getHorSpace(5.h),
  //                           getCustomFont(modalFeatureEvent.location ?? "",
  //                               15.sp, Colors.white, 1,
  //                               fontWeight: FontWeight.w500, txtHeight: 1.5.h),
  //                         ],
  //                       ),
  //                       getVerSpace(22.h),
  //                       getButton(context, accentColor, "Book Now",
  //                           Colors.white, () {}, 14.sp,
  //                           weight: FontWeight.w700,
  //                           buttonHeight: 40.h,
  //                           borderRadius: BorderRadius.circular(14.h),
  //                           buttonWidth: 111.h)
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget buildSearchWidget(BuildContext context) {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getDefaultTextFiledWithLabel(
          context, "Search events...", controller.searchController,
          isEnable: false, onTap: () {
        Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (_, __, ___) => SearchPage()));
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
          horizontal: 16),
    );
  }

  Widget buildAppBar() {
    final sb = context.watch<SignInBloc>();
    return getPaddingWidget(
      EdgeInsets.only(left: 20.h),
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
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Gilroy',
                      color: Colors.white
                    ),
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
              Text(sb.name ?? '',style: TextStyle(
                
                      fontSize: 24,
                      fontFamily: 'Gilroy',
                      fontWeight: FontWeight.bold,
                      color: Colors.white
              ),),
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
                  Constant.sendToNext(context, Routes.notificationScreenRoute);
                },
                child:
                    getSvgImage("notification.svg", height: 24.h, width: 24.h)),
          ),
        ],
      ),
    );
  }
}

class buildPopularEventList extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const buildPopularEventList({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return Event.fromFirestore(e);
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

          return InkWell(
            onTap: () {
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
              padding: EdgeInsets.only(
                  top: 7.h, left: 7.h, bottom: 6.h, right: 20.h),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 82,
                          width: 82,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont(
                                events?[i].title ?? "", 18.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                            getVerSpace(4.h),
                            getCustomFont(
                                events?[i].date ?? '', 15.sp, greyColor, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.46.h)
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
                    child: Row(
                      children: [
                        getCustomFont('\$ ', 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                        getCustomFont(events?[i].price.toString() ?? '', 15.sp,
                            accentColor, 1,
                            fontWeight: FontWeight.w600, txtHeight: 1.46.h),
                      ],
                    ),
                  )
                ],
              ),
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
            return Event.fromFirestore(e);
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

          return InkWell(
            onTap: () {
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
              width: 374.h,
              height: 196.h,
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
                            events?[i].title ?? "", 20.sp, Colors.white, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        getVerSpace(4.h),
                        Row(
                          children: [
                            getSvgImage("location.svg",
                                width: 20.h, height: 20.h),
                            getHorSpace(5.h),
                            getCustomFont(events?[i].location ?? "", 15.sp,
                                Colors.white, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                          ],
                        ),
                        getVerSpace(22.h),
                        getButton(context, accentColor, "Book Now",
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
      ),
    );
  }
}

class TrendingEventCard extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const TrendingEventCard({this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return Event.fromFirestore(e);
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

          return SizedBox(
            height: 289.h,
            child: GestureDetector(
              onTap: () {
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
                margin: EdgeInsets.only(right: 20.h, left: 20.h),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          image: DecorationImage(
                              image: NetworkImage(events?[i].image ?? ''),
                              fit: BoxFit.fill)),
                      height: 170.h,
                      width: 248.h,
                      padding: EdgeInsets.only(left: 12.h, top: 12.h),
                      child: Wrap(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: "#B2000000".toColor(),
                                borderRadius: BorderRadius.circular(12.h)),
                            padding: EdgeInsets.symmetric(
                                vertical: 4.h, horizontal: 10.h),
                            child: getCustomFont(
                                events?[i].date ?? "", 13.sp, Colors.white, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.69.h),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      width: 230.h,
                      top: 132.h,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 27,
                                  offset: const Offset(0, 8))
                            ],
                            borderRadius: BorderRadius.circular(22.h)),
                        padding: EdgeInsets.symmetric(horizontal: 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getVerSpace(16.h),
                            getCustomFont(
                                events?[i].title ?? "", 18.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                            getVerSpace(3.h),
                            Row(
                              children: [
                                getSvgImage("location.svg",
                                    width: 20.h,
                                    height: 20.h,
                                    color: greyColor),
                                getHorSpace(5.h),
                                getCustomFont(events?[i].location ?? "", 15.sp,
                                    greyColor, 1,
                                    fontWeight: FontWeight.w500,
                                    txtHeight: 1.5.h)
                              ],
                            ),
                            getVerSpace(10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          events?[i].userProfile ?? ''),
                                      radius: 10.0,
                                    ),
                                    // getAssetImage(
                                    //     event.sponser ?? '',
                                    //     height: 30.h,
                                    //     width: 30.h),
                                    getHorSpace(8.h),
                                    Container(
                                      width: 80.0,
                                      child: getCustomFont(
                                          overflow: TextOverflow.ellipsis,
                                          events?[i].userName ?? '',
                                          15.sp,
                                          greyColor,
                                          1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.46.h),
                                    )
                                  ],
                                ),
                                getButton(context, accentColor, "Join",
                                    Colors.white, () {}, 14.sp,
                                    weight: FontWeight.w700,
                                    buttonHeight: 40.h,
                                    borderRadius: BorderRadius.circular(14.h),
                                    buttonWidth: 70.h)
                              ],
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
