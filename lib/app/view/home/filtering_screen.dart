import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/widget_utils.dart';
import '../../routes/app_routes.dart';
import '../../widget/empty_screen.dart';
import '../featured_event/featured_event_detail.dart';

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
  bool _isCategoryMSelected = false;
  bool _isCategoryNSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          ('Filter Event By Category').tr(),
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
                ("Category").tr(),
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
                        ('Game').tr(),
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
                        ('Football').tr(),
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
                        ('Comedy').tr(),
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
                        ('Konser').tr(),
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
                        ('Festival').tr(),
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
                        ('Study').tr(),
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
                        ('Party').tr(),
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
                        ('Olympic').tr(),
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
                        ('Culture').tr(),
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
                        value: _isCategoryMSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryMSelected = value!;
                          });
                        },
                      ),
                      Text(
                        ('Swimming').tr(),
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
                        value: _isCategoryNSelected,
                        onChanged: (value) {
                          setState(() {
                            _isCategoryNSelected = value!;
                          });
                        },
                      ),
                      Text(
                        ('Tour').tr(),
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
                ("Result").tr(),
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
                    if (_isCategoryMSelected) 'swimming',
                    if (_isCategoryNSelected) 'tour',
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
                          return EventBaru.fromFirestore(e, 1);
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
                            Navigator.pushNamed(context, Routes.featuredEventDetailRoute, arguments: events[i]);

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
                                            Container(
                                              width: 200.w,
                                              child: getCustomFont(
                                                  events?[i].title ?? "",
                                                  20.5.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w700,
                                                  txtHeight: 1.5.h),
                                            ),
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
                                                Container(
                                                  width: 150.w,
                                                  child: getCustomFont(
                                                      events?[i].location ?? "",
                                                      15.sp,
                                                      greyColor,
                                                      1,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      txtHeight: 1.5.h),
                                                ),
                                              ],
                                            ),
                                            getVerSpace(7.h),
                                            Row(
                                              children: [
                                                StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection("JoinEvent")
                                                      .doc("user")
                                                      .collection(
                                                          events[i].title ?? '')
                                                      .snapshots(),
                                                  builder: (BuildContext ctx,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          snapshot) {
                                                    return snapshot.hasData
                                                        ? new joinEvents(
                                                            list: snapshot
                                                                .data?.docs,
                                                          )
                                                        : Container();
                                                  },
                                                ),
                                                if (events[i].price! > 0)
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 0.0,
                                                                bottom: 0.0),
                                                        child: Container(
                                                          height: 35.h,
                                                          width: 80.0,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.051),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.h)),
                                                          child: Center(
                                                              child: Text(
                                                            "\$ " +
                                                                (events?[i]
                                                                        .price
                                                                        .toString() ??
                                                                    ""),
                                                            style: TextStyle(
                                                                color:
                                                                    accentColor,
                                                                fontSize: 15.sp,
                                                                fontFamily:
                                                                    'Gilroy',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                        )),
                                                  ),
                                                if (events[i].price == 0)
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 0.0,
                                                                bottom: 0.0),
                                                        child: Container(
                                                          height: 35.h,
                                                          width: 80.0,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.051),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.h)),
                                                          child: Center(
                                                              child: Text(
                                                            ("Free").tr(),
                                                            style: TextStyle(
                                                                color:
                                                                    accentColor,
                                                                fontSize: 15.sp,
                                                                fontFamily:
                                                                    'Gilroy',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                            textAlign: TextAlign
                                                                .center,
                                                          )),
                                                        )),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
