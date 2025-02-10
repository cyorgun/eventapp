import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var emailCtrl = TextEditingController();
  late String _email;

  void handleSubmit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      resetPassword(_email);
    }
  }

  Future<void> resetPassword(String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueAccent,
          content: Text(
            'An email has been sent to $email. \n\nGo to that link & reset your password.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // app_bar: getToolBar(
      //   () {
      //     ;
      //   },
      //   title: Container(),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                height: 150,
                child: Opacity(
                    opacity: 0.7,
                    child: Image.asset('assets/images/login1.png'))),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      ;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 30.h,
                      ),
                    )),
                getVerSpace(70.h),
                Center(
                  child: getCustomFont(
                      ("Forgot Password?").tr(), 24.sp, Colors.black, 1,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      txtHeight: 1.5.h),
                ),
                getVerSpace(8.h),
                getVerSpace(20.h),
                getMultilineCustomFont(
                    ("Please input your email to receive a new password to create a new password via email.")
                        .tr(),
                    16.sp,
                    Colors.black,
                    txtHeight: 1.5.h,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500),
                getVerSpace(68.h),
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
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            getVerSpace(30.h),
                            getCustomFont(
                                ("Email").tr(), 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600),
                            getVerSpace(7.h),
                            getDefaultTextFiledWithLabel(
                                onChanged: (String value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                context,
                                ("Enter email").tr(),
                                emailCtrl,
                                isEnable: false,
                                height: 60.h,
                                validator: (email) {
                                  if (email!.isEmpty) {
                                    return ("Please enter email address.").tr();
                                  }
                                  return null;
                                }),
                            getVerSpace(36.h),
                            Spacer(),
                            getButton(context, accentColor, ("Submit").tr(),
                                Colors.white, () {
                              handleSubmit();
                            }, 18.sp,
                                weight: FontWeight.w700,
                                buttonHeight: 60.h,
                                borderRadius: BorderRadius.circular(22.h)),
                            getVerSpace(36.h),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
