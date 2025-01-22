import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';
import 'package:easy_localization/easy_localization.dart';

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
                              decoration: BoxDecoration(
                                  color: lightColor,
                                  borderRadius: BorderRadius.circular(187.h)),
                              padding: EdgeInsets.all(27.h),
                              child: getAssetImage("onBoarding3.png",
                                   width: 214.h,boxFit: BoxFit.cover),
                            ),
                            getCustomFont(
                                ("Item Empty").tr(), 20.sp, Colors.black, 1,
                                fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                            getVerSpace(8.h),
                            getMultilineCustomFont(
                                ("Sorry, we couldn't find any results for your item.").tr(),
                                16.sp,
                                Colors.black,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.center,
                                txtHeight: 1.5.h)
              ],
            ),
                );
  }
}