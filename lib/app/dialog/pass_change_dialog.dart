import 'package:event_app/app/view/login/login_screens.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PassChangeDialog extends StatefulWidget {
  const PassChangeDialog({Key? key}) : super(key: key);

  @override
  State<PassChangeDialog> createState() => _PassChangeDialogState();
}

class _PassChangeDialogState extends State<PassChangeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(37.h)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          getVerSpace(30.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.h),
            padding: EdgeInsets.only(top: 29.h, bottom: 47.h),
            width: double.infinity,
            decoration: BoxDecoration(
                color: lightColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(34.h))),
            child: getAssetImage("unlock.png", height: 114.h, width: 114.h),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(37.h),
                boxShadow: [
                  BoxShadow(
                      color: "#2B9CC3C6".toColor(),
                      blurRadius: 24,
                      offset: const Offset(0, -2))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getVerSpace(30.h),
                getCustomFont("Password Changed", 22.sp, Colors.black, 1,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                    txtHeight: 1.5.h),
                getVerSpace(8.h),
                getMultilineCustomFont(
                    "Your password has been successfully changed!",
                    16.sp,
                    Colors.black,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                    txtHeight: 1.5.h),
                getVerSpace(30.h),
                getButton(context, accentColor, "Ok", Colors.white, () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen()));
                }, 18.sp,
                    weight: FontWeight.w700,
                    buttonHeight: 60.h,
                    borderRadius: BorderRadius.circular(22.h)),
                getVerSpace(30.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
