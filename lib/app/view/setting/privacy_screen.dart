import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  void backClick() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: getToolBar(() {
          backClick();
        },
            title: getCustomFont(
              "Privacy",
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
                      getMultilineCustomFont(
                          "   At our company, we take user privacy very seriously, especially in the context of our event mobile app. We understand that our users trust us with their personal information, and we strive to uphold that trust by implementing strict privacy policies and security measures. Our event mobile app is designed to collect only the data necessary to provide our users with a seamless event experience, such as event registration information, schedule preferences, and contact details for event organizers. We use industry-standard security protocols to protect this information, including encryption and multi-factor authentication, to ensure that our users' data is kept safe and confidential.",
                          16.sp,
                          Colors.black,
                          fontWeight: FontWeight.w500,
                          txtHeight: 1.46.h,
                          textAlign: TextAlign.start),
                            getVerSpace(10.h),
                      getMultilineCustomFont(
                          "   Furthermore, we believe in giving our users control over their own privacy settings. Our event mobile app includes granular privacy settings that allow users to choose which information they want to share with other attendees, event organizers, and sponsors. We also make it easy for users to opt-out of any marketing communications they do not wish to receive.",
                          16.sp,
                          Colors.black,
                          fontWeight: FontWeight.w500,
                          txtHeight: 1.46.h,
                          textAlign: TextAlign.start),
                                 getVerSpace(10.h),
                      getMultilineCustomFont(
                          "   Finally, we never share our users' personal information with third parties, except where required by law. We believe in being transparent about our data collection and sharing practices, and we provide detailed privacy policies that explain how we collect, use, and share our users' data. We are committed to maintaining the highest standards of data security and privacy for our users, and we will continue to innovate and improve our event mobile app to ensure that it meets the evolving needs of our users in a privacy-respecting way.",
                          16.sp,
                          Colors.black,
                          fontWeight: FontWeight.w500,
                          txtHeight: 1.46.h,
                          textAlign: TextAlign.start)
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
