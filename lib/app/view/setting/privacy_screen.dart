import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: getToolBar(() {
        Navigator.of(context).pop();
      },
          title: getCustomFont(
            ("Privacy").tr(),
            24.sp,
            Colors.black,
            1,
            fontWeight: FontWeight.w700,
          )),
      body: SafeArea(
        child: Column(
          children: [
            getDivider(
              dividerColor,
              1.h,
            ),
            Expanded(
                flex: 1,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  children: [
                    getVerSpace(10.h),
                    getMultilineCustomFont(("lorem2").tr(), 16.sp, Colors.black,
                        fontWeight: FontWeight.w500,
                        txtHeight: 1.46.h,
                        textAlign: TextAlign.start),
                    getVerSpace(10.h),
                    getMultilineCustomFont(("lorem3").tr(), 16.sp, Colors.black,
                        fontWeight: FontWeight.w500,
                        txtHeight: 1.46.h,
                        textAlign: TextAlign.start),
                    getVerSpace(10.h),
                    getMultilineCustomFont(("lorem4").tr(), 16.sp, Colors.black,
                        fontWeight: FontWeight.w500,
                        txtHeight: 1.46.h,
                        textAlign: TextAlign.start)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
