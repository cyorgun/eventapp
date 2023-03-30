import 'package:event_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/pref_data.dart';
import '../../../base/widget_utils.dart';
import '../bloc/sign_in_bloc.dart';
import '../profile/change_password.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
        appBar: getToolBar(
          () {
            backClick();
          },
          title: getCustomFont("Settings", 24.sp, Colors.black, 1,
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
                      getCustomFont("Account Settings", 16.sp, greyColor, 1,
                          fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      getVerSpace(12.h),
                      settingContainer(() {
                        Constant.sendToNext(context, Routes.editProfileRoute);
                      }, "Edit Profile", "edit_profile.svg"),
                      getVerSpace(20.h),
                      settingContainer(
                          () {
                            Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> ChangePassword()));
                          }, "Change Password", "change_password.svg"),
                      getVerSpace(30.h),
                      getCustomFont("Preferences", 16.sp, greyColor, 1,
                          fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      getVerSpace(12.h),
                      settingContainer(() {
                        Constant.sendToNext(
                            context, Routes.notificationScreenRoute);
                      }, "Notification", "notification-image.svg"),
                      getVerSpace(20.h),
                      settingContainer(() {
                        Constant.sendToNext(context, Routes.myCardScreenRoute);
                      }, "My Cards", "card.svg"),
                      getVerSpace(20.h),
                      settingContainer(() {
                        Constant.sendToNext(context, Routes.privacyScreenRoute);
                      }, "Privacy", "privacy.svg"),
                      getVerSpace(20.h),
                      settingContainer(() {
                        Constant.sendToNext(context, Routes.helpScreenRoute);
                      }, "Help", "info.svg"),
                    ],
                  )),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                getButton(
                    context, accentColor, "Logout", Colors.white, ()
                    async{
                await context.read<SignInBloc>().userSignout()
                .then((value) => context.read<SignInBloc>().afterUserSignOut())
                .then((value){
                  Constant.sendToNext(
                      context, Routes.loginRoute);
                }
                );
                
                
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
      ),
    );
  }
}
