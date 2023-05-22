import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:event_app/app/view/create_event/create_event_screen.dart';
import 'package:event_app/app/view/home/tab/tab_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../../base/appBar/bar.dart';
// import '../../../base/appBar/item.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

import 'cardSlider/cardSlider.dart';
import 'tab/tab_favourite.dart';
import 'tab/tab_home.dart';
import 'tab/tab_profile.dart';
import 'tab/tab_ticket.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void backClick() {
    Constant.closeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    getFromSharedPreferences();
    super.initState();
  }

  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      role = prefs.getString("role");
    });
  }

  String? role;

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _widgetOptions = [
    const TabHome(),
    const TabFavourite(),
    MapsScreenT1(),
    const TabTicket(),
    const TabProfile()
  ];

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildBottomBar(),
        body: _widgetOptions[_currentIndex]);
  }

  Widget _buildBottomBar() {
    return ConvexAppBar(
      items: [
        TabItem(
            icon: getSvg("home.svg", height: 24.h, width: 24.h),
            activeIcon: getSvg("home2.svg",
                height: 24.h, width: 24.h, color: accentColor)),
        TabItem(
            icon: getSvg(
              "bookmark.svg",
              height: 24.h,
              width: 24.h,
            ),
            activeIcon: getSvg("bookmark2.svg",
                height: 24.h, width: 24.h, color: accentColor)),
        TabItem(
            icon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getSvg("map.svg",
                  height: 24.h, width: 24.h, color: Colors.white),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getSvg("map2.svg",
                  height: 24.h, width: 24.h, color: Colors.white),
            )),
        TabItem(
            icon: getSvg("ticket.svg", height: 24.h, width: 24.h),
            activeIcon: getSvg("ticket2.svg",
                height: 24.h, width: 24.h, color: accentColor)),
        TabItem(
            icon: getSvg("profile.svg", height: 24.h, width: 24.h),
            activeIcon: getSvg("profile2.svg",
                height: 24.h, width: 24.h, color: accentColor))
      ],
      height: 70.h,
      elevation: 5,
      color: accentColor,
      top: -58.h,
      curveSize: 40.h,
      activeColor: accentColor,
      style: TabStyle.fixedCircle,
      backgroundColor: Colors.white,
      initialActiveIndex: _currentIndex,
      onTap: onTabTapped,
    );
  }
}
