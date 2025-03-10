import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/widget_utils.dart';
import '../../routes/app_routes.dart';
import '../../widget/empty_screen.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool _isAllSelected = true;
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
  bool _isCategoryOtherSelected = false;
  bool _isFiltersExpanded = true;
  String? _selectedLocation;
  DateTime? _selectedDate;
  QuerySnapshot? _filteredEvents;

  void _resetFilters() {
    setState(() {
      _isAllSelected = true;
      _isCategoryASelected = false;
      _isCategoryBSelected = false;
      _isCategoryCSelected = false;
      _isCategoryDSelected = false;
      _isCategoryESelected = false;
      _isCategoryFSelected = false;
      _isCategoryGSelected = false;
      _isCategoryHSelected = false;
      _isCategoryISelected = false;
      _isCategoryJSelected = false;
      _isCategoryKSelected = false;
      _isCategoryLSelected = false;
      _isCategoryOtherSelected = false;
      _selectedLocation = null;
      _selectedDate = null;
      _filteredEvents = null;
    });
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _applyFilters() async {
    Query query = FirebaseFirestore.instance.collection('event');

    if (!_isAllSelected) {
      query = query.where('category', whereIn: [
        if (_isCategoryASelected) 'game',
        if (_isCategoryBSelected) 'football',
        if (_isCategoryCSelected) 'comedy',
        if (_isCategoryDSelected) 'konser',
        if (_isCategoryESelected) 'festival',
        if (_isCategoryFSelected) 'study',
        if (_isCategoryGSelected) 'party',
        if (_isCategoryHSelected) 'olympic',
        if (_isCategoryISelected) 'culture',
        if (_isCategoryJSelected) 'swimming',
        if (_isCategoryKSelected) 'tour',
        if (_isCategoryLSelected) 'trophy',
        if (_isCategoryOtherSelected) 'tour',
      ]);
    }

    if (_selectedLocation != null && _selectedLocation!.isNotEmpty) {
      query = query.where('location', isEqualTo: _selectedLocation!.toLowerCase());
    }

    if (_selectedDate != null) {
      query = query.where('date', isEqualTo: Timestamp.fromDate(_selectedDate!));
    }

    QuerySnapshot querySnapshot = await query.get();
    setState(() {
      _filteredEvents = querySnapshot;
      _isFiltersExpanded = false;
    });
  }


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
          children: [
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isFiltersExpanded = !_isFiltersExpanded;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      ("Filters").tr(),
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 18.0),
                    ),
                    Icon(_isFiltersExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up)
                  ],
                ),
              ),
            ),
            if (_isFiltersExpanded) ...[
            SizedBox(
              height: 20.0,
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 12.0,
              children: [
                buildCategoryWidget("All", _isAllSelected, (newValue) {
                  _resetFilters();
                }),
                buildCategoryWidget("Game", _isCategoryASelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryASelected = newValue;
                  });
                }),
                buildCategoryWidget("Football", _isCategoryBSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryBSelected = newValue;
                  });
                }),
                buildCategoryWidget("Comedy", _isCategoryCSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryCSelected = newValue;
                  });
                }),
                buildCategoryWidget("Konser", _isCategoryDSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryDSelected = newValue;
                  });
                }),
                buildCategoryWidget("Festival", _isCategoryESelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryESelected = newValue;
                  });
                }),
                buildCategoryWidget("Study", _isCategoryFSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryFSelected = newValue;
                  });
                }),
                buildCategoryWidget("Party", _isCategoryGSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryGSelected = newValue;
                  });
                }),
                buildCategoryWidget("Olympic", _isCategoryHSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryHSelected = newValue;
                  });
                }),
                buildCategoryWidget("Culture", _isCategoryISelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryISelected = newValue;
                  });
                }),
                buildCategoryWidget("Swimming", _isCategoryJSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryJSelected = newValue;
                  });
                }),
                buildCategoryWidget("Tour", _isCategoryKSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryKSelected = newValue;
                  });
                }),
                buildCategoryWidget("Trophy", _isCategoryLSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryLSelected = newValue;
                  });
                }),
                buildCategoryWidget("Other", _isCategoryOtherSelected, (newValue) {
                  setState(() {
                    _isAllSelected = false;
                    _isCategoryOtherSelected = newValue;
                  });
                }),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "cityNameInput".tr(),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child:GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.black45),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? "dateInput".tr()
                              : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        Icon(Icons.calendar_today, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _applyFilters,
                child: Text("applyFilters".tr()),
              ),
            SizedBox(
              height: 10.0,
            ),],
            Expanded(
              child: _filteredEvents == null
                  ? Center(child: Text("noFiltersApplied".tr()))
                  : ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: _filteredEvents!.docs.length,
                  itemBuilder: (context, i) {
                    final events = _filteredEvents!.docs.map((e) {
                      return EventBaru.fromFirestore(e, 1);
                    }).toList();
                    DateTime? dateTime = events![i].date?.toDate();
                    String date =
                    DateFormat('d MMMM, yyyy').format(dateTime!);

                    return InkWell(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('event')
                            .doc(_filteredEvents!.docs[i].id)
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
                                  events[i].image != null ? Container(
                                    height: 102,
                                    width: 102,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              events[i].image!,
                                            ),
                                            fit: BoxFit.cover)),
                                  ) : Container(),
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
            ),
          ],
        ),
      ),
    );
  }

  Container buildCategoryWidget(String title, bool isSelected, Function(bool) onChanged) {
    return Container(
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
                      value: isSelected,
                      onChanged: (value) {
                        onChanged(value!);
                      },
                    ),
                    Expanded(
                      child: Text(
                        (title).tr(),
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontFamily: 'Gilroy', fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              );
  }
}
