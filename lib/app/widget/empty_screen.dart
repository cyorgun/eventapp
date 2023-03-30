import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 
                     Container(
                              height: 208.h,
                              width: 208.h,
                              decoration: BoxDecoration(
                                  color: lightColor,
                                  borderRadius: BorderRadius.circular(187.h)),
                              padding: EdgeInsets.all(27.h),
                              child: getAssetImage("bell.png",
                                  height: 114.h, width: 114.h),
                            ),
                            getVerSpace(28.h),
                            getCustomFont(
                                "No Item Yet!", 20.sp, Colors.black, 1,
                                fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                            getVerSpace(8.h),
                            getMultilineCustomFont(
                                "Not have item data",
                                16.sp,
                                Colors.black,
                                fontWeight: FontWeight.w500,
                                txtHeight: 1.5.h)
              ],
            ),
                );
  }
}