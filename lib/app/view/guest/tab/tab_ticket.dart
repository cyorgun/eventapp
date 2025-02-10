import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/view/ticket/upcoming_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../../provider/sign_in_provider.dart';
import '../../intro/welcome.dart';

class GuestTabTicket extends StatefulWidget {
  const GuestTabTicket({Key? key}) : super(key: key);

  @override
  State<GuestTabTicket> createState() => _GuestTabTicketState();
}

class _GuestTabTicketState extends State<GuestTabTicket>
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
    final sb = context.watch<SignInProvider>();
    return Column(
      children: [
        buildAppBar(),
        Divider(color: dividerColor, thickness: 1.h, height: 1.h),
        if (sb.name == null)
          Column(
            children: [
              SizedBox(
                height: 100.h,
              ),
              getAssetImage("guest.png", height: 300.0, width: 400.0),
              getVerSpace(28.h),
              getCustomFont(("Guest User").tr(), 22.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(8.h),
              getMultilineCustomFont(("Please login to view this screen").tr(),
                  18.sp, Colors.black,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => WelcomePage()));
                  },
                  child: Container(
                    height: 45.0,
                    width: 130,
                    decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(50.0))),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          Expanded(child: UpComingScreen())
      ],
    );
  }

  AppBar buildAppBar() {
    return getToolBar(() {},
        title: getCustomFont(("My Ticket").tr(), 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        leading: false);
  }
}
