import 'package:event_app/app/view/ticket/upcoming_screen.dart';
import 'package:event_app/base/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../ticket/past_screen.dart';

class TabTicket extends StatefulWidget {
  const TabTicket({Key? key}) : super(key: key);

  @override
  State<TabTicket> createState() => _TabTicketState();
}

class _TabTicketState extends State<TabTicket>
    with SingleTickerProviderStateMixin {
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
    return Column(
      children: [
        buildAppBar(),
        Divider(color: dividerColor, thickness: 1.h, height: 1.h),
        Expanded(child: UpComingScreen())
      ],
    );
  }

  AppBar buildAppBar() {
    return getToolBar(() {},
        title: getCustomFont("My Ticket", 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        leading: false);
  }
}
