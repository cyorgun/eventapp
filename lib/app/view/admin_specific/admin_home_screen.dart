import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';
import '../create_event/create_event_screen.dart';
import 'Event_List_Screen.dart';
import 'dashboard.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  @override
  void initState() {
    super.initState();
    final sb = context.read<SignInProvider>();
    sb.verifyUserSubscription();
  }

  void backClick() {
    Constant.closeApp();
  }

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _widgetOptions = [
    Dashboard(),
    CreateEventScreen(fromAdmin: true),
    EventListScreen(),
    //  AddNotificationScreen(),
    //  DataMapScreen()
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
            icon: getSvg("home.svg", height: 24  , width: 24  ),
            activeIcon: getSvg("home2.svg",
                height: 24  , width: 24  , color: accentColor)),
        TabItem(
             icon: Icon(Icons.add, size: 50  , color: Colors.white70),
            activeIcon:  Icon(Icons.add, size: 50  , color: Colors.white),),
        TabItem(
               icon:  Icon(Icons.assistant_outlined, size: 26  , color: Colors.black54),
            activeIcon: Icon(Icons.assistant, size: 26  , color: accentColor),),
        // TabItem(
        //      icon: getSvg("home.svg", height: 24  , width: 24  ),
        //     activeIcon: getSvg("home2.svg",
        //         height: 24  , width: 24  , color: accentColor)),
        // TabItem(
        //        icon: getSvg("home.svg", height: 24  , width: 24  ),
        //     activeIcon: getSvg("home2.svg",
        //         height: 24  , width: 24  , color: accentColor)),
      ],
      height: 50  ,
      elevation: 5,
      color: accentColor,
      top: -38  ,
      curveSize: 0  ,
      activeColor: accentColor,
      style: TabStyle.fixedCircle,
      backgroundColor: Colors.white,
      initialActiveIndex: _currentIndex,
      onTap: onTabTapped,
    );
  }
}
