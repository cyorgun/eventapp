import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/view/ticket/upcoming_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';

class showCaseTicket extends StatefulWidget {
  const showCaseTicket({super.key});

  @override
  State<showCaseTicket> createState() => _showCaseTicketState();
}

class _showCaseTicketState extends State<showCaseTicket> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) => TabTicket()),
    );
  }
}

class TabTicket extends StatefulWidget {
  const TabTicket({Key? key}) : super(key: key);

  @override
  State<TabTicket> createState() => _TabTicketState();
}

class _TabTicketState extends State<TabTicket>
    with SingleTickerProviderStateMixin {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  late TabController controller;
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  // TicketController pageController = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcaseVisibilityStatus =
          preferences.getBool("favoriteShowcasesssss");

      if (showcaseVisibilityStatus == null) {
        preferences
            .setBool("favoriteShowcasesssss", false)
            .then((bool success) {
          if (success)
            print("Successfull in writing showshoexase");
          else
            print("some bloody problem occured");
        });

        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([
          _one,
          _two,
        ]);
      }
    });

    return KeysToBeInherited(
      notification: _one,
      search: _two,
      child: Column(
        children: [
          buildAppBar(),
          Divider(color: dividerColor, thickness: 1.h, height: 1.h),
          Expanded(
              child: Showcase(
                  key: _one,
                  description: "Click here to view your ticket item.",
                  child: UpComingScreen()))
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return getToolBar(() {},
        title: getCustomFont(("My Ticket").tr(), 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        leading: false);
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey notification;
  final GlobalKey search;

  KeysToBeInherited({
    required this.notification,
    required this.search,
    required Widget child,
  }) : super(child: child);

  static KeysToBeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
