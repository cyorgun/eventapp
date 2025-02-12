// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../base/pref_data.dart';
import '../provider/bookmark_provider.dart';
import '../provider/sign_in_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _decideRoute();
  }

  gotoHomePage() async {
    final SignInProvider sb = context.read<SignInProvider>();
    final BookmarkProvider b = context.read<BookmarkProvider>();
    if (sb.isSignedIn == true) {
      await sb.getUserDataFromFirebase(sb.uid);
      //await b.getInterestDataFromFirebase(sb.uid);
    }
    Timer(const Duration(seconds: 2), () {
      Navigator.popAndPushNamed(context, Routes.homeScreenRoute);
    });
  }

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  _decideRoute() async {
    final SignInProvider sb = context.read<SignInProvider>();
    bool isIntro = await PrefData.isFirstTime();
    //bool isSelect = await PrefData.getSelectInterest();
    if (isIntro) {
      Navigator.popAndPushNamed(context, Routes.onboardingPage);
    } else if (!sb.isSignedIn) {
      Navigator.popAndPushNamed(context, Routes.welcomePage);
    } /*else if (!isSelect) {
      Navigator.pushNamed(context, Routes.selectInterestRoute);
    } */else {
      gotoHomePage();
    }
  }

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
              height: 300.0,
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
