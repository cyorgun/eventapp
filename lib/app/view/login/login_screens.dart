import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../controller/controller.dart';
import '../../dialog/snacbar copy.dart';
import '../../routes/app_routes.dart';
import '../../service/app_service.dart';
import '../bloc/sign_in_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool rememberMe = true;
  void backClick() {
    Constant.closeApp();
  }

  LoginController controlller = Get.put(LoginController());

  final formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  bool signInStart = false;
  late String email;
  late String pass;
  // Icon lockIcon = LockIcon().lock;
  bool offsecureText = true;
  Widget _title() {
    return Text(
      "Welcome Back!",
      style: TextStyle(
        fontFamily: Constant.fontsFamily,
        fontSize: 33,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  Widget _subtitle() {
    return Text(
      "Sign in to your account",
      style: TextStyle(
        fontFamily: Constant.fontsFamily,
        wordSpacing: -0.5,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  handleSignInwithemailPassword() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      await AppService().checkInternet().then((hasInternet) {
        if (hasInternet == false) {
          openSnacbar(_scaffoldKey, 'no internet');
        } else {
          setState(() {
            signInStart = true;
          });
          sb.signInwithEmailPassword(email, pass).then((_) async {
            if (sb.hasError == false) {
              sb
                  .getUserDatafromFirebase(sb.uid)
                  .then((value) => sb.guestSignout())
                  .then((value) => sb
                      .saveDataToSP()
                      .then((value) => sb.setSignIn().then((value) {
                            setState(() {
                              // signInComplete = true;
                            });

                            Constant.sendToNext(
                                context, Routes.homeScreenRoute);
                          })));
            } else {
              _btnController.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent,
                  content: Text(
                    'Failed Login Please Check Your Mail and Password!',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
              setState(() {
                signInStart = false;
              });
              openSnacbar(_scaffoldKey, sb.errorCode);
            }
          });
        }
      });
    } else {
      _btnController.reset();
    }
  }

  final _btnController = new RoundedLoadingButtonController();
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

  Widget _textField(controller, title, bool isPassword) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            obscureText: isPassword,
            keyboardType: TextInputType.emailAddress,
            controller: controller,
            autofocus: false,
            decoration: InputDecoration(
              hintText: "Enter your $title",
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _rememberCheck() {
    return Row(
      children: <Widget>[
        Container(
            child: Checkbox(
          value: rememberMe,
          onChanged: (bool? value) {},
        )),
        _remember()
      ],
    );
  }

  Widget _remember() {
    return Text(
      "Remember me",
      style: TextStyle(
        fontFamily: "Sofia",
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }

  Widget _forget() {
    return Text(
      "Forgot Password?",
      style: TextStyle(
          fontFamily: "Sofia",
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8E9873)),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          color: Color(0xFF8E9873)),
      child: Text(
        'Sign In ',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget _signupTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "Not an account yet? ",
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xff00234B),
          ),
          children: [
            TextSpan(
              text: "Sign Up",
              style: TextStyle(color: Color(0xFF8E9873), fontSize: 16),
            ),
          ]),
    );
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
          key: _scaffoldKey,
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: 0,
                      right: 0,
                      height: 150,
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.asset('assets/images/login1.png'))),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.asset('assets/images/login2.png')),
                        height: 120,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 160,
                        ),
                        _title(),
                        SizedBox(
                          height: 5,
                        ),
                        _subtitle(),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              getVerSpace(30.h),
                              getCustomFont("Email", 16.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600),
                              getVerSpace(20.h),
                              TextFormField(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    fontFamily: Constant.fontsFamily),
                                decoration: InputDecoration(
                                    hintText: 'username@mail.com',
                                    labelText: 'Enter Email',
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
                                  if (value!.isEmpty)
                                    return "Email can't be empty";
                                  return null;
                                },
                                onChanged: (String value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              getCustomFont("Password", 16.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600),
                              SizedBox(
                                height: 20,
                              ),
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
                                      borderSide: BorderSide(
                                          color: borderColor, width: 1.h)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22.h),
                                      borderSide: BorderSide(
                                          color: borderColor, width: 1.h)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22.h),
                                      borderSide: BorderSide(
                                          color: accentColor, width: 1.h)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22.h),
                                      borderSide: BorderSide(
                                          color: errorColor, width: 1.h)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22.h),
                                      borderSide: BorderSide(
                                          color: errorColor, width: 1.h)),
                                  errorStyle: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5.h,
                                      fontFamily: Constant.fontsFamily),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(22.h),
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
                                  hintText: "Enter Password",
                                ),
                                obscureText: offsecureText,
                                controller: passCtrl,
                                validator: (String? value) {
                                  if (value!.isEmpty)
                                    return "Password can't be empty";
                                  return null;
                                },
                                onChanged: (String value) {
                                  setState(() {
                                    pass = value;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  Constant.sendToNext(
                                      context, Routes.forgotPasswordRoute);
                                },
                                child: getCustomFont(
                                    "Forgot Password?", 14.sp, Colors.black, 1,
                                    fontWeight: FontWeight.w700,
                                    textAlign: TextAlign.end),
                              ),
                              getVerSpace(65.h),
                              RoundedLoadingButton(
                                animateOnTap: true,
                                successColor: accentColor,
                                controller: _btnController,
                                onPressed: () {
                                  handleSignInwithemailPassword();
                                },
                                width: MediaQuery.of(context).size.width * 1.0,
                                color: accentColor.withOpacity(0.9),
                                elevation: 0,
                                child: Wrap(
                                  children: const [
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                child: getRichText(
                                    "If you are new / ",
                                    Colors.black,
                                    FontWeight.w500,
                                    15.sp,
                                    "Create New Account",
                                    Colors.black,
                                    FontWeight.w700,
                                    14.sp),
                                onTap: () {
                                  Constant.sendToNext(
                                      context, Routes.signUpRoute);
                                },
                              ),
                              getVerSpace(38.h)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          )),
    );
  }
}
