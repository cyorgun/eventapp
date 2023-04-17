import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/view/home/tab/tab_home.dart';
import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../base/widget_utils.dart';
import '../../modal/modal_event.dart';
import '../../widget/empty_screen.dart';
import '../featured_event/featured_event_detail2.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _isCategoryASelected = false;
  bool _isCategoryBSelected = false;
  bool _isCategoryCSelected = false;
  bool _isCategoryDSelected = false;
  bool _isCategoryESelected = false;
  bool _isCategoryFSelected = false;
  bool _isCategoryGSelected = false;
  bool _isCategoryHSelected = false;
  bool _isCategoryISelected = false;
  bool _isCategoryJSelected = false;
  bool _isCategoryKSelected = false;
  bool _isCategoryLSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Filter Event By Category',
          style: TextStyle(
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontSize: 17.0),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 1.0, right: 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Category",
                style: TextStyle(
                    fontFamily: "Gilroy",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 12.0,
              children: [
        
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryBSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryBSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Game',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryCSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryCSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Football',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryDSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryDSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Comedy',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryESelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryESelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Konser',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
           
            
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryHSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryHSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Festival',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryISelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryISelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Study',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryJSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryJSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Party',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryKSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryKSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Olympic',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Row(
                    children: [
                      Checkbox(
                        activeColor: accentColor,
                        value: _isCategoryLSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryLSelected = value!;
                          });
                        },
                      ),
                      Text(
                        'Culture',
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Result",
                style: TextStyle(
                    fontFamily: "Gilroy",
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('event')
                  .where('category', whereIn: [
                    '',
                    if (_isCategoryBSelected) 'game',
                    if (_isCategoryCSelected) 'football',
                    if (_isCategoryDSelected) 'comedy',
                    if (_isCategoryESelected) 'konser',
                    if (_isCategoryHSelected) 'festival',
                    if (_isCategoryISelected) 'study',
                    if (_isCategoryJSelected) 'party',
                    if (_isCategoryKSelected) 'olympic',
                    if (_isCategoryLSelected) 'culture',
                  ]

                      //  whereIn: [
                      //   if (_isCategoryASelected) 'Category A',
                      //   if (_isCategoryBSelected) 'Category B',
                      //   if (_isCategoryCSelected) 'Category C',
                      // ]
                      )
                  .where(
                    'category',
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: EmptyScreen());
                }

                return Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, i) {
                        final events = snapshot.data?.docs.map((e) {
                          return Event.fromFirestore(e);
                        }).toList();
                        DateTime? dateTime = events![i].date?.toDate();
                        String date =
                            DateFormat('d MMMM, yyyy').format(dateTime!);

                        return InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('event')
                                .doc(snapshot.data!.docs[i].id)
                                .update({'count': FieldValue.increment(1)});
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    FeaturedEvent2Detail(
                                      event: events?[i],
                                    )));
                          },
                          child: Container(
                            height: 150.0,
                            margin: EdgeInsets.only(
                                bottom: 20.h, left: 20.0, right: 20.0),
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
                                        height: 102,
                                        width: 102,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20.0)),
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            getCustomFont(
                                                events?[i].title ?? "",
                                                20.5.sp,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.w700,
                                                txtHeight: 1.5.h),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              children: [
                                                getSvg("calender.svg",
                                                    color: accentColor,
                                                    width: 16.h,
                                                    height: 16.h),
                                                getHorSpace(5.h),
                                                getCustomFont(
                                                    date.toString() ?? "",
                                                    15.sp,
                                                    greyColor,
                                                    1,
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
                                                getCustomFont(
                                                    events?[i].location ?? "",
                                                    15.sp,
                                                    greyColor,
                                                    1,
                                                    fontWeight: FontWeight.w500,
                                                    txtHeight: 1.5.h),
                                              ],
                                            ),
                                            getVerSpace(7.h),
                                            StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection("JoinEvent")
                                                  .doc("user")
                                                  .collection(
                                                      events[i].title ?? '')
                                                  .snapshots(),
                                              builder: (BuildContext ctx,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshot) {
                                                return snapshot.hasData
                                                    ? new joinEvents(
                                                        list:
                                                            snapshot.data?.docs,
                                                      )
                                                    : Container();
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
                                    "\$ " + (events?[i].price.toString() ?? ""),
                                    style: TextStyle(
                                        color: accentColor,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
