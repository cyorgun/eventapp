// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors

import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DeleteDialog extends StatefulWidget {
  final index;

  const DeleteDialog(this.index);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
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
            height: 134.h,
            margin: EdgeInsets.symmetric(horizontal: 30.h),
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            decoration: BoxDecoration(
              color: lightColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(34.h)),
            ),
            child: Column(
              children: [
                getVerSpace(40.h),
                getMultilineCustomFont(
                    "Are you sure you want to delete this card?",
                    18.sp,
                    Colors.black,
                    fontWeight: FontWeight.w600,
                    txtHeight: 1.5.h,
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(37.h),
                boxShadow: [
                  BoxShadow(
                      color: "#2B9CC3C6".toColor(),
                      blurRadius: 24,
                      offset: const Offset(0, -2))
                ]),
            padding: EdgeInsets.symmetric(horizontal: 30.h),
            child: Column(
              children: [
                getVerSpace(30.h),
                Row(
                  children: [
                    Expanded(
                        child: getButton(
                            context, Colors.white, "No", accentColor, () {
                      Get.back();
                    }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            isBorder: true,
                            borderColor: accentColor,
                            borderWidth: 1.h,
                            borderRadius: BorderRadius.circular(22.h))),
                    getHorSpace(20.h),
                    Expanded(
                        child: getButton(
                            context, accentColor, "Yes", Colors.white, () {
                      setState(() {});
                      Get.back();
                    }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h))),
                  ],
                ),
                getVerSpace(30.h),
              ],
            ),
          )
        ],
      ),
    );
  }
}
