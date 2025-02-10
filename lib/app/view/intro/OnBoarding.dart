import 'package:event_app/app/widget/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../widget/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'welcome.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

var _fontHeaderStyle = TextStyle(
    fontFamily: Constant.fontsFamily,
    fontSize: 23.0,
    fontWeight: FontWeight.w900,
    color: Colors.black87,
    letterSpacing: 1.5);

var _fontDescriptionStyle = TextStyle(
    fontFamily: Constant.fontsFamily,
    fontSize: 16.0,
    color: Colors.black26,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w400);

///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Exploring Upcoming Events',
        style: _fontHeaderStyle,
        textAlign: TextAlign.center,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'exploring upcoming events can be a fun and rewarding activity for anyone looking to occupy.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/images/onBoarding1.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Exploring Nearby Events',
        textAlign: TextAlign.center,
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'Exploring nearby events is a great way to support local businesses and discover hidden gems in your community.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/images/onBoarding2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Search Around Maps',
        textAlign: TextAlign.center,
        style: _fontHeaderStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
            'Searching for events around maps is a great way to find activities and events that are close by and fit your interests.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/images/onBoarding3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
];

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text(
        "SKIP",
        style: _fontDescriptionStyle.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w800,
            fontFamily: Constant.fontsFamily,
            letterSpacing: 1.0),
      ),
      doneText: Text(
        "DONE",
        style: _fontDescriptionStyle.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w800,
            fontFamily: Constant.fontsFamily,
            letterSpacing: 1.0),
      ),
      onTapDoneButton: () async {
        Navigator.of(context).push(
            PageRouteBuilder(pageBuilder: (_, __, ___) => new WelcomePage()));
        // Get.toNamed(Routes.loginRoute);
      },
    );
  }
}
