import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:evente/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EventpublishDialog extends StatefulWidget {
  const EventpublishDialog({Key? key}) : super(key: key);

  @override
  State<EventpublishDialog> createState() => _EventpublishDialogState();
}

class _EventpublishDialogState extends State<EventpublishDialog> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(37.h),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          getVerSpace(30.h),
          Container(
            width: double.infinity,
            height: 190.h,
            margin: EdgeInsets.symmetric(horizontal: 30.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(34.h))),
            child: Column(
              children: [
                getVerSpace(40.h),
                Image.asset(
                  'assets/images/Sukses.gif',
                  width: 150,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(37.h),
                boxShadow: [
                  BoxShadow(
                      color: "#2B9CC3C6".toColor(),
                      offset: const Offset(0, -2),
                      blurRadius: 24)
                ]),
            child: Column(
              children: [
                getVerSpace(30.h),
                getCustomFont("Event Published", 22.sp, Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                getVerSpace(8.h),
                getMultilineCustomFont(
                    "Your event successfully published.", 16.sp, Colors.black,
                    fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                getVerSpace(30.h),
                getButton(context, accentColor, "Finish", Colors.white, () {
                  Navigator.pop(context);
                  //  Get.back();
                  controller.onChange(1.obs);
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

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  HomeController controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(37 ),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20 ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          getVerSpace(30 ),
          Container(
            width: double.infinity,
            height: 190 ,
            margin: EdgeInsets.symmetric(horizontal: 30 ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(34 ))),
            child: Column(
              children: [
                getVerSpace(40 ),
                Icon(Icons.error,size: 120.0,color: Colors.red,),

              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30 ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(37 ),
                boxShadow: [
                  BoxShadow(
                      color: "#2B9CC3C6".toColor(),
                      offset: const Offset(0, -2),
                      blurRadius: 24)
                ]),
            child: Column(
              children: [
                getVerSpace(30 ),
                getCustomFont('QR Code is not valid', 22 , Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5 ),
                getVerSpace(8 ),
                getMultilineCustomFont(
                    "Please scan valid QR Code.", 16 , Colors.black,
                    fontWeight: FontWeight.w500, txtHeight: 1.5 ),
                getVerSpace(30 ),
                getButton(context, Colors.redAccent, "Close", Colors.white, () {
                  Navigator.pop(context);
                }, 18 ,
                    weight: FontWeight.w700,
                    buttonHeight: 60 ,
                    borderRadius: BorderRadius.circular(22 )),
                getVerSpace(30 ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
