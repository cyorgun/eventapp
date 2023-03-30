import 'package:event_app/app/view/create_event/create_event_screen.dart';
import 'package:event_app/app/view/home/tab/tab_maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/appBar/bar.dart';
import '../../../base/appBar/item.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../controller/controller.dart';

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
  
  CreateEventController createEventController =
      Get.put(CreateEventController());
  HomeController controller = Get.put(HomeController());
  

  @override
  Widget build(BuildContext context) {
     final List<Widget> _widgetOptions = <Widget>[
    const TabHome(),
    const TabFavourite(),
       const CreateEventScreen(),
    // const TabTicket(),
     MapsScreenT1(),
    const TabProfile()
  ];

       final List<Widget> _widgetOptions2 = <Widget>[
    const TabHome(),
    const TabFavourite(),
     users(),
    const TabTicket(),
    const TabProfile()
  ];
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        if (controller.index.value != 0) {
          controller.onChange(0.obs);
        } else {
          backClick();
        }

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        bottomNavigationBar:  role == "user"? _buildBottomBar() : _buildBottomBar2(),
        body: SafeArea(
          child: GetX<HomeController>(
            init: HomeController(),
            builder: (controller) => role == "user"? _widgetOptions[controller.index.value]:_widgetOptions2[controller.index.value],
          ),
        ),
      ),
    );
  }

  Widget users(){
return  
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                 Padding(
                   padding: const EdgeInsets.only(top:15.0),
                   child: getCustomFont("Add Event", 20.sp, Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                 ),
             
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 208.h,
                        width: 208.h,
                        padding: EdgeInsets.symmetric(horizontal: 52.h, vertical: 47.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(187.h),
                            color: lightColor),
                        child:
                            getAssetImage("valentine.png", height: 114.h, width: 114.h),
                      ),
                      getVerSpace(28.h),
                      getCustomFont("Role Admin", 20.sp, Colors.black, 1,
                          fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                      getVerSpace(8.h),
                      getMultilineCustomFont(
                          "This screen for admin", 16.sp, Colors.black,
                          fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                    ],
                  ),
                ),
              ),
              
              Text(""),
            ],
          );
  }

  Widget _buildBottomBar() {
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) => ConvexAppBar(
        items: [
          TabItem(
              icon: getSvgImage("home.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("home_bold.svg", height: 24.h, width: 24.h)),
          TabItem(
              icon: getSvgImage("favourite.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("favourite_bold.svg", height: 24.h, width: 24.h)),
           TabItem(
              icon: getSvgImage("add.svg", height: 24.h, width: 24.h),
              activeIcon: getSvgImage("add.svg", height: 24.h, width: 24.h)),
          TabItem(
              icon: getSvgImage("ticket.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("ticket_bold.svg", height: 24.h, width: 24.h)),
          TabItem(
              icon: getSvgImage("profile.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("profile_bold.svg", height: 24.h, width: 24.h))
        ],
        height: 88.h,
        elevation: 5,
        color: accentColor,
        top: -33.h,
        curveSize: 85.h,
        initialActiveIndex: controller.index.value,
        activeColor: accentColor,
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        onTap: (count) {
          controller.onChange(count.obs);
        },
      ),
    );
  }


  
  Widget _buildBottomBar2() {
    return GetX<HomeController>(
      init: HomeController(),
      builder: (controller) => ConvexAppBar(
        items: [
          TabItem(
              icon: getSvgImage("home.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("home_bold.svg", height: 24.h, width: 24.h)),
          TabItem(
              icon: getSvgImage("favourite.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("favourite_bold.svg", height: 24.h, width: 24.h)),
            TabItem(
              icon: getSvgImage("add.svg", height: 24.h, width: 24.h),
              activeIcon: getSvgImage("add.svg", height: 24.h, width: 24.h)),
       
         
          TabItem(
              icon: getSvgImage("ticket.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("ticket_bold.svg", height: 24.h, width: 24.h)),
          TabItem(
              icon: getSvgImage("profile.svg", height: 24.h, width: 24.h),
              activeIcon:
                  getSvgImage("profile_bold.svg", height: 24.h, width: 24.h))
        ],
        height: 88.h,
        elevation: 5,
        color: accentColor,
        top: -33.h,
        curveSize: 85.h,
        initialActiveIndex: controller.index.value,
        activeColor: accentColor,
        style: TabStyle.fixedCircle,
        backgroundColor: Colors.white,
        onTap: (count) {
          controller.onChange(count.obs);
        },
      ),
    );
  }

}
