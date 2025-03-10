import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:event_app/app/view/create_event/create_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// import '../../../base/app_bar/bar.dart';
// import '../../../base/app_bar/item.dart';
import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';
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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final sb = context.read<SignInProvider>();
    sb.verifyUserSubscription();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _widgetOptions = [
    const TabHome(),
    const TabFavourite(),
    const CreateEventScreen(fromAdmin: false),
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
              child: getSvg("add.svg",
                  height: 24.h, width: 24.h, color: Colors.white),
            ),
            activeIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getSvg("add.svg",
                  height: 24.h, width: 24.h, color: Colors.lightBlue),
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
