import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/view/login/login_screens.dart';
import 'package:event_app/app/widget/Rounded_Button.dart';
import 'package:event_app/base/constant.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/snacbar.dart';
import '../../provider/sign_in_provider.dart';
import '../../routes/app_routes.dart';
import '../select_interest/select_interest_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var phoneController = TextEditingController();
  var nameCtrl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _btnController = new RoundedLoadingButtonController();

  bool offsecureText = true;

  late String email;
  late String pass;
  late String phone;
  String? name;

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

  Future handleSignUpwithEmailPassword() async {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      await AppService().checkInternet().then((hasInternet) {
        if (hasInternet == false) {
          openSnacbar(_scaffoldKey, ('no internet').tr());
        } else {
          setState(() {
            // signUpStarted = true;
          });
          sb.signUpWithEmailPassword(name, email, pass, phone).then((_) async {
            if (sb.hasError == false) {
              sb.getTimestamp().then((value) => sb
                  .saveToFirebase()
                  .then((value) => sb.increaseUserCount())
                  .then((value)  {
                            setState(() {
                              // signUpCompleted = true;
                            });
                            Navigator.popAndPushNamed(context, Routes.selectInterestRoute);
                          }));
            } else {
              setState(() {
                // signUpStarted = false;
              });
              _btnController.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    ('Failed Login Please Check Your Mail and Password!').tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              openSnacbar(_scaffoldKey, sb.errorCode);
            }
          });
        }
      });
    } else {
      _btnController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(accentColor);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SafeArea(
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
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 30.h,
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          getVerSpace(30.h),
                          getCustomFont(
                              ("Sign Up").tr(), 24.sp, Colors.black, 1,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                              txtHeight: 1.5.h),
                          getVerSpace(8.h),
                          getVerSpace(30.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(34.h)),
                                boxShadow: [
                                  BoxShadow(
                                      color: "#2B9CC3C6".toColor(),
                                      blurRadius: 24,
                                      offset: const Offset(0, -2))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getVerSpace(24.h),
                                getCustomFont(
                                    ("Full Name").tr(), 16.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7.h),
                                TextFormField(
                                  controller: nameCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: ('Full Name').tr(),
                                      labelText: ('Enter Name').tr(),
                                      counter: Container(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.h)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.h)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: accentColor, width: 1.h)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.h)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.h)),
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5.h,
                                          fontFamily: Constant.fontsFamily),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.h)),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24.h,
                                      ),
                                      hintStyle: TextStyle(
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                          fontFamily: Constant.fontsFamily)),
                                  validator: (String? value) {
                                    if (value!.length == 0)
                                      return ("Name can't be empty").tr();
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                                getVerSpace(24.h),
                                getCustomFont(
                                    ("Email").tr(), 16.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7.h),
                                TextFormField(
                                  decoration: InputDecoration(
                                      hintText: ('username@mail.com').tr(),
                                      labelText: ('Enter Email').tr(),
                                      counter: Container(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.h)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.h)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: accentColor, width: 1.h)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.h)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1.h)),
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5.h,
                                          fontFamily: Constant.fontsFamily),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22.h),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1.h)),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24.h,
                                      ),
                                      hintStyle: TextStyle(
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.sp,
                                          fontFamily: Constant.fontsFamily)),
                                  controller: emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (String? value) {
                                    if (value!.length == 0)
                                      return ("Email can't be empty").tr();
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                ),
                                getVerSpace(24.h),
                                getCustomFont(("Phone Number").tr(), 16.sp,
                                    Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7.h),

                                getDefaultTextFiledWithLabel2(context,
                                    ("Phone Number").tr(), phoneController,
                                    isEnable: false,
                                    height: 60.h,
                                    validator: (String? value) {
                                      if (value!.isEmpty)
                                        return ("Phone can't be empty").tr();
                                      return null;
                                    },
                                    isprefix: true,
                                    onChanged: (String value) {
                                      setState(() {
                                        phone = value;
                                      });
                                    },
                                    // prefix: GestureDetector(
                                    //   onTap: () {},
                                    //   child: Row(
                                    //     children: [
                                    //       getHorSpace(18.h),
                                    //       getHorSpace(12.h),
                                    //       getCustomFont(
                                    //           "",
                                    //           16.sp,
                                    //           greyColor,
                                    //           1,
                                    //           fontWeight:
                                    //               FontWeight.w500),
                                    //       getHorSpace(5.h),
                                    //       getSvgImage("arrow_down.svg",
                                    //           width: 24.h,
                                    //           height: 24.h),
                                    //       getHorSpace(5.h),
                                    //     ],
                                    //   ),
                                    // ),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[0-9.,]')),
                                    ],
                                    constraint: BoxConstraints(
                                        maxWidth: 135.h, maxHeight: 24.h)),

                                getVerSpace(24.h),
                                getCustomFont(
                                    ("Password").tr(), 16.sp, Colors.black, 1,
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
                                        borderRadius:
                                            BorderRadius.circular(22.h),
                                        borderSide: BorderSide(
                                            color: borderColor, width: 1.h)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h),
                                        borderSide: BorderSide(
                                            color: borderColor, width: 1.h)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h),
                                        borderSide: BorderSide(
                                            color: accentColor, width: 1.h)),
                                    errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h),
                                        borderSide: BorderSide(
                                            color: errorColor, width: 1.h)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h),
                                        borderSide: BorderSide(
                                            color: errorColor, width: 1.h)),
                                    errorStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5.h,
                                        fontFamily: Constant.fontsFamily),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h),
                                        borderSide: BorderSide(
                                            color: borderColor, width: 1.h)),
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
                                    hintText: ("Enter Password").tr(),
                                  ),
                                  obscureText: offsecureText,
                                  controller: passCtrl,
                                  validator: (String? value) {
                                    if (value!.isEmpty)
                                      return ("Password can't be empty").tr();
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      pass = value;
                                    });
                                  },
                                ),
                                getVerSpace(36.h),
                                RoundedLoadingButton(
                                  animateOnTap: true,
                                  successColor: accentColor,
                                  controller: _btnController,
                                  onPressed: () {
                                    handleSignUpwithEmailPassword();
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 1.0,
                                  color: accentColor,
                                  elevation: 0,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        ('Sign Up').tr(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                // getButton(
                                //     context, accentColor, "Sign Up", Colors.white,
                                //     () {
                                //   handleSignUpwithEmailPassword();
                                // }, 18.sp,
                                //     weight: FontWeight.w700,
                                //     buttonHeight: 60.h,
                                //     borderRadius: BorderRadius.circular(22.h)),
                                getVerSpace(40.h),
                                GestureDetector(
                                  child: getRichText(
                                      ("Already have an account? / ").tr(),
                                      Colors.black,
                                      FontWeight.w500,
                                      15.sp,
                                      ("Login").tr(),
                                      Colors.black,
                                      FontWeight.w700,
                                      14.sp),
                                  onTap: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            LoginScreen()));
                                  },
                                ),
                                getVerSpace(30.h),
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getDefaultTextFiledWithLabel2(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool withSufix = false,
      bool minLines = false,
      bool isPass = false,
      bool isEnable = true,
      bool isprefix = false,
      Widget? prefix,
      double? height,
      String? suffiximage,
      Function? imagefunction,
      List<TextInputFormatter>? inputFormatters,
      FormFieldValidator<String>? validator,
      BoxConstraints? constraint,
      ValueChanged<String>? onChanged,
      double vertical = 20,
      double horizontal = 18,
      int? length,
      String obscuringCharacter = '•',
      GestureTapCallback? onTap,
      bool isReadonly = false}) {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          readOnly: isReadonly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          enabled: true,
          inputFormatters: inputFormatters,
          maxLines: (minLines) ? null : 1,
          controller: textEditingController,
          obscuringCharacter: obscuringCharacter,
          autofocus: false,
          obscureText: isPass,
          keyboardType: TextInputType.number,
          showCursor: true,
          cursorColor: accentColor,
          maxLength: length,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              fontFamily: Constant.fontsFamily),
          decoration: InputDecoration(
              counter: Container(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: vertical.h, horizontal: horizontal.h),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: borderColor, width: 1.h)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: borderColor, width: 1.h)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: accentColor, width: 1.h)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: errorColor, width: 1.h)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: errorColor, width: 1.h)),
              errorStyle: TextStyle(
                  color: errorColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.5.h,
                  fontFamily: Constant.fontsFamily),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22.h),
                  borderSide: BorderSide(color: borderColor, width: 1.h)),
              suffixIconConstraints: BoxConstraints(
                maxHeight: 24.h,
              ),
              suffixIcon: withSufix == true
                  ? GestureDetector(
                      onTap: () {
                        imagefunction;
                      },
                      child: getPaddingWidget(
                        EdgeInsets.only(right: 18.h),
                        getSvgImage(suffiximage.toString(),
                            width: 24.h, height: 24.h),
                      ))
                  : null,
              prefixIconConstraints: constraint,
              prefixIcon: isprefix == true ? prefix : null,
              hintText: s,
              hintStyle: TextStyle(
                  color: greyColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  fontFamily: Constant.fontsFamily)),
        );
      },
    );
  }
}
