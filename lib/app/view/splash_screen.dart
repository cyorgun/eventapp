// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/bloc/bookmark_bloc.dart';
import 'package:event_app/app/view/home/home_screen.dart';
import 'package:event_app/base/constant.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../base/color_data.dart';
import '../../base/pref_data.dart';
import 'intro/welcome.dart';
import 'bloc/sign_in_bloc.dart';
import 'intro/OnBoarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    afterSplash();
    // _getIsFirst();
  }
afterSplash(){
    final SignInBloc sb = context.read<SignInBloc>();
    Future.delayed(Duration(milliseconds: 2500)).then((value){
      sb.isSignedIn == true 
      ? gotoHomePage()
      : gotoSignInPage();
      // : WelcomePage();
    });
  }


  gotoHomePage () {
    final SignInBloc sb = context.read<SignInBloc>();
    final BookmarkBloc b = context.read<BookmarkBloc>();
    if(sb.isSignedIn == true){ 
      sb.getDataFromSp();
      b.getDataToSP();
    }
    Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=>new HomeScreen()));
        // Constant.sendToNext(context, Routes.homeScreenRoute);
  }


  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  gotoSignInPage (){
    //  Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=>new WelcomePage()));
     Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=>new OnBoarding()));
  }

  // _getIsFirst() async {
  //   bool isSignIn = await PrefData.getIsSignIn();
  //   bool isIntro = await PrefData.getIsIntro();
  //   bool isSelect = await PrefData.getSelectInterest();
  //   if (isIntro) {
  //     Constant.sendToNext(context, Routes.introRoute);
  //   } else if (!isSignIn) {
  //     Constant.sendToNext(context, Routes.loginRoute);
  //   } else if (!isSelect) {
  //     Constant.sendToNext(context, Routes.selectInterestRoute);
  //   } else {
  //     Timer(const Duration(seconds: 3), () {
  //       Constant.sendToNext(context, Routes.homeScreenRoute);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 270.0,
              height: 100.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logoSplash.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,
              height:300.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          FutureBuilder<PackageInfo>(
              future: _getPackageInfo(),
              builder: (context, snapshot) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 300.0,
                    height: 45 * 2,
                    child: Center(
                      child: Text(
                        'Version ${snapshot.data?.version ?? ''}',
                      ),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
