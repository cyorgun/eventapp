import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Constant {
  static String assetImagePath = "assets/images/";
  static String assetSvgPath = "assets/svg/";
  static bool isDriverApp = false;
  static const String fontsFamily = "Gilroy";
  static const String fromLogin = "getFromLoginClick";
  static const String homePos = "getTabPos";
  static const int stepStatusNone = 0;
  static const int stepStatusActive = 1;
  static const int stepStatusDone = 2;
  static const int stepStatusWrong = 3;

  static double getPercentSize(double total, double percent) {
    return (percent * total) / 100;
  }

  static getCurrency(BuildContext context) {
    return "ETH";
  }

  static double getToolbarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  static double getToolbarTopHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static closeApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }
}

const flutterWavePublicKey = 'FLWPUBK_TEST-eb3edef083c890a7e22dc7eec9e0daa5-X';
const flutterWaveSecretKey = 'FLWSECK_TEST-d2759023efce6198a853b8e2dd3beb55-X';
const flutterWaveEncryptionKey = 'FLWSECK_TEST8497cc2db86c';
