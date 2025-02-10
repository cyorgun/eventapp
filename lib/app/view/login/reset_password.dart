import 'package:event_app/app/dialog/pass_change_dialog.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  ResetController controller = Get.put(ResetController());

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
        title: getSvgImage("event_logo.svg", width: 72.h, height: 35.h),
      ),
      body: SafeArea(
        child: Column(
          children: [
            getDivider(
              dividerColor,
              1.h,
            ),
            getVerSpace(60.h),
            getCustomFont("Reset Password", 24.sp, Colors.black, 1,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                txtHeight: 1.5.h),
            getVerSpace(8.h),
            getMultilineCustomFont(
                "Enter your new password for reset password!",
                16.sp,
                Colors.black,
                txtHeight: 1.5.h,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500),
            getVerSpace(38.h),
            Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(34.h)),
                      boxShadow: [
                        BoxShadow(
                            color: "#2B9CC3C6".toColor(),
                            blurRadius: 24,
                            offset: const Offset(0, -2))
                      ]),
                  child: Form(
                    key: controller.resetFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        getVerSpace(30.h),
                        getCustomFont("Old Password", 16.sp, Colors.black, 1,
                            fontWeight: FontWeight.w600),
                        getVerSpace(7.h),
                        getDefaultTextFiledWithLabel(context,
                            "Enter old password", controller.oldPassController,
                            isEnable: false, height: 60.h, validator: (email) {
                          if (email!.isEmpty) {
                            return "Please enter old password.";
                          }
                          return null;
                        },
                            suffiximage: "show.svg",
                            withSufix: true,
                            isPass: true),
                        getVerSpace(24.h),
                        getCustomFont("New Password", 16.sp, Colors.black, 1,
                            fontWeight: FontWeight.w600),
                        getVerSpace(7.h),
                        getDefaultTextFiledWithLabel(context,
                            "Enter new password", controller.newPassController,
                            isEnable: false, height: 60.h, validator: (email) {
                          if (email!.isEmpty) {
                            return "Please enter new password.";
                          }
                          return null;
                        },
                            suffiximage: "show.svg",
                            withSufix: true,
                            isPass: true),
                        getVerSpace(24.h),
                        getCustomFont(
                            "Confirm Password", 16.sp, Colors.black, 1,
                            fontWeight: FontWeight.w600),
                        getVerSpace(7.h),
                        getDefaultTextFiledWithLabel(
                            context,
                            "Enter confirm password",
                            controller.confPassController,
                            isEnable: false,
                            height: 60.h, validator: (email) {
                          if (email!.isEmpty) {
                            return "Please enter confirm password.";
                          }
                          return null;
                        },
                            suffiximage: "show.svg",
                            withSufix: true,
                            isPass: true),
                        getVerSpace(36.h),
                        getButton(context, accentColor, "Submit", Colors.white,
                            () {
                          showDialog(
                              builder: (context) {
                                return const PassChangeDialog();
                              },
                              context: context);
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
