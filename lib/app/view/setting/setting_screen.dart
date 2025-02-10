import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/view/login/login_screens.dart';
import 'package:event_app/app/view/notification/notification_screen.dart';
import 'package:event_app/app/view/profile/edit_profile.dart';
import 'package:event_app/app/view/setting/help_screen.dart';
import 'package:event_app/app/view/setting/privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';
import '../profile/change_password.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: getToolBar(
        () {
          Navigator.of(context).pop();
        },
        title: getCustomFont(("Settings").tr(), 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
      ),
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
                  primary: true,
                  shrinkWrap: true,
                  children: [
                    getVerSpace(20.h),
                    getCustomFont(
                        ("Account Settings").tr(), 16.sp, greyColor, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                    getVerSpace(12.h),
                    settingContainer(() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => EditProfile()));

                      // Constant.sendToNext(context, Routes.editProfileRoute);
                    }, ("Edit Profile").tr(), "edit_profile.svg"),
                    getVerSpace(20.h),
                    settingContainer(() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ChangePassword()));
                    }, ("Change Password").tr(), "change_password.svg"),
                    getVerSpace(30.h),
                    getCustomFont(("Preferences").tr(), 16.sp, greyColor, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                    getVerSpace(12.h),
                    settingContainer(() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => NotificationScreen()));

                      // Constant.sendToNext(
                      //     context, Routes.notificationScreenRoute);
                    }, ("Notification").tr(), "notification-image.svg"),
                    getVerSpace(20.h),
                    settingContainer(() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => PrivacyScreen()));

                      // Constant.sendToNext(context, Routes.myCardScreenRoute);
                    }, ("My Cards").tr(), "card.svg"),
                    getVerSpace(20.h),
                    settingContainer(() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => PrivacyScreen()));

                      // Constant.sendToNext(context, Routes.privacyScreenRoute);
                    }, ("Privacy").tr(), "privacy.svg"),
                    getVerSpace(20.h),
                    settingContainer(() {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => HelpScreen()));

                      // Constant.sendToNext(context, Routes.helpScreenRoute);
                    }, ("Help").tr(), "info.svg"),
                  ],
                )),
            getPaddingWidget(
              EdgeInsets.symmetric(horizontal: 20.h),
              getButton(context, accentColor, ("Logout").tr(), Colors.white,
                  () async {
                await context
                    .read<SignInProvider>()
                    .userSignout()
                    .then((value) =>
                        context.read<SignInProvider>().afterUserSignOut())
                    .then((value) {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LoginScreen()));

                  // Constant.sendToNext(
                  //     context, Routes.loginRoute);
                });
              },
                  //      {
                  //   PrefData.setIsSignIn(false);
                  //   Constant.sendToNext(
                  //       context, Routes.loginRoute);
                  // },

                  18.sp,
                  weight: FontWeight.w700,
                  buttonHeight: 60.h,
                  borderRadius: BorderRadius.circular(22.h)),
            ),
            getVerSpace(30.h)
          ],
        ),
      ),
    );
  }
}
