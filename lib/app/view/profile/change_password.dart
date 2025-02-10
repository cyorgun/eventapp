import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/dialog/pass_change_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late String passold;

  var formKey = GlobalKey<FormState>();
  late String pass2;
  var passOldCtrl = TextEditingController();
  var pass2Ctrl = TextEditingController();

  bool offsecureText = true;
  bool offsecureText2 = true;

  void lockPressed() {
    if (offsecureText == true) {
      setState(() {
        offsecureText = false;
        // lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText = true;
        // lockIcon = LockIcon().lock;
      });
    }
  }

  void lockPressed2() {
    if (offsecureText2 == true) {
      setState(() {
        offsecureText2 = false;
        // lockIcon = LockIcon().open;
      });
    } else {
      setState(() {
        offsecureText2 = true;
        // lockIcon = LockIcon().lock;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInProvider>();
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: getToolBar(
        () {
          Navigator.of(context).pop();
        },
        title: getCustomFont(("Change Password").tr(), 20.sp, Colors.black, 1,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            txtHeight: 1.5.h),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Column(
            children: [
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        getVerSpace(30.h),
                        getCustomFont(
                            ("Old Password").tr(), 16.sp, Colors.black, 1,
                            fontWeight: FontWeight.w600),
                        getVerSpace(7.h),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              fontFamily: Constant.fontsFamily),
                          decoration: InputDecoration(
                            counter: Container(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.h)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.h)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: accentColor, width: 1.h)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.h)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.h)),
                            errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.5.h,
                                fontFamily: Constant.fontsFamily),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.h)),
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 24.h,
                            ),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  lockPressed();
                                },
                                child: getPaddingWidget(
                                  EdgeInsets.only(right: 18.h),
                                  getSvgImage("show.svg".toString(),
                                      width: 24.h, height: 24.h),
                                )),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 12.h,
                            ),
                            hintText: ("Enter Old Password").tr(),
                          ),
                          obscureText: offsecureText,
                          controller: passOldCtrl,
                          validator: (String? value) {
                            if (value!.isEmpty)
                              return ("Password can't be empty").tr();
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              passold = value;
                            });
                          },
                        ),

                        getVerSpace(24.h),
                        getCustomFont(
                            ("New Password").tr(), 16.sp, Colors.black, 1,
                            fontWeight: FontWeight.w600),
                        getVerSpace(7.h),
                        TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              fontFamily: Constant.fontsFamily),
                          decoration: InputDecoration(
                            counter: Container(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.h)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.h)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: accentColor, width: 1.h)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.h)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: errorColor, width: 1.h)),
                            errorStyle: TextStyle(
                                color: Colors.red,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                height: 1.5.h,
                                fontFamily: Constant.fontsFamily),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22.h),
                                borderSide:
                                    BorderSide(color: borderColor, width: 1.h)),
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 24.h,
                            ),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  lockPressed2();
                                },
                                child: getPaddingWidget(
                                  EdgeInsets.only(right: 18.h),
                                  getSvgImage("show.svg".toString(),
                                      width: 24.h, height: 24.h),
                                )),
                            prefixIconConstraints: BoxConstraints(
                              maxHeight: 12.h,
                            ),
                            hintText: ("Enter Password").tr(),
                          ),
                          obscureText: offsecureText2,
                          controller: pass2Ctrl,
                          validator: (String? value) {
                            if (value!.isEmpty)
                              return ("Password can't be empty").tr();
                            return null;
                          },
                          onChanged: (String value) {
                            setState(() {
                              pass2 = value;
                            });
                          },
                        ),

                        // getVerSpace(24.h),
                        // getCustomFont(
                        //     "Confirm Password", 16.sp, Colors.black, 1,
                        //     fontWeight: FontWeight.w600),
                        // getVerSpace(7.h),
                        // getDefaultTextFiledWithLabel(
                        //     context,
                        //     "Enter confirm password",
                        //     controller.confPassController,
                        //     isEnable: false,
                        //     height: 60.h, validator: (email) {
                        //   if (email!.isEmpty) {
                        //     return "Please enter confirm password.";
                        //   }
                        //   return null;
                        // },
                        //     suffiximage: "show.svg",
                        //     withSufix: true,
                        //     isPass: true),
                        Spacer(),
                        getVerSpace(36.h),
                        getButton(
                            context, accentColor, ("Submit").tr(), Colors.white,
                            () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            final user =
                                await FirebaseAuth.instance.currentUser;
                            final cred = EmailAuthProvider.credential(
                                email: user!.email!, password: passold);

                            user
                                .reauthenticateWithCredential(cred)
                                .then((value) {
                              user.updatePassword(pass2).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blue,
                                    content: Text(
                                      ('Success Change Password!').tr(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                                showDialog(
                                    builder: (context) {
                                      return const PassChangeDialog();
                                    },
                                    context: context);
                                Navigator.of(context).pop();
                                //Success, do something
                              }).catchError((error) {
                                //Error, show something
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text(
                                      ('Failed  Please Check Your Password!')
                                          .tr(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              });
                            }).catchError((err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.redAccent,
                                  content: Text(
                                    ('Failed  Please Check Your Password!')
                                        .tr(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            });
                          } else {}
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),

                        getVerSpace(24.h),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
