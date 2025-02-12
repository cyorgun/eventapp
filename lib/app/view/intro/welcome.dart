import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/view/signup/signup_screen.dart';
import 'package:event_app/app/widget/Rounded_Button.dart';
import 'package:event_app/base/color_data.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../../base/constant.dart';
import '../../dialog/snacbar copy.dart';
import '../../provider/sign_in_provider.dart';
import '../../routes/app_routes.dart';
import '../Multiple_Language/multiple_language_screen.dart';
import '../select_interest/select_interest_screen.dart';

class WelcomePage extends StatefulWidget {
  final String? tag;

  const WelcomePage({Key? key, this.tag}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _googleController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _facebookController =
      new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _appleController =
      new RoundedLoadingButtonController();
  final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();

  handleSkip() {
    // nextScreen(context, DonePage());
  }

  @override
  void initState() {
    super.initState();

    checkAndRequestLocationPermission();
    getFromSharedPreferences();
  }

  handleGoogleSignIn() async {
    final SignInProvider sb =
        Provider.of<SignInProvider>(context, listen: false);

    final scaffoldState = scaffoldKey.currentState;
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, ('check your internet connection!').tr());
      } else {
        await sb.signInWithGoogle().then((_) {
          if (sb.hasError == true) {
            openSnacbar(
                scaffoldKey, ('something is wrong. please try again.').tr());
            _googleController.reset();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(('something is wrong. please try again.').tr()),
              ),
            );
          } else {
            sb.checkUserExists().then((value) {
              openSnacbar(
                  scaffoldKey, (value.toString()));
              if (value == true) {
                sb
                    .getUserDataFromFirebase(sb.uid)
                    .then((value)  {
                              _googleController.success();
                              handleAfterSignIn();
                            });
              } else {
                openSnacbar(
                    scaffoldKey, (value.toString() + "2"));
                sb.getTimestamp().then((value) => sb
                    .saveToFirebase()
                    .then((value) {
                              _googleController.success();
                              handleAfterSignIn();
                            }));
              }
            });
          }
        });
      }
    });
  }

  Position? userPosition;
  late List<EventBaru> nearbyEvents = [];

  void getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      role = prefs.getString("role");
    });
  }

  String? role;

  Future<Position> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<void> checkAndRequestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isDenied) {
      // Menampilkan pesan mengapa izin diperlukan
      requestLocationPermission();
    } else if (status.isPermanentlyDenied) {
      // Pengguna telah menolak izin secara permanen
      // Anda dapat memberikan pilihan untuk membuka pengaturan aplikasi lagi atau menutup aplikasi.
      requestLocationPermission();
    }
  }

  Future<void> requestLocationPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasPermission = prefs.getBool('hasLocationPermissions') ?? false;

    if (hasPermission == false) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Container(
                  color: Colors.white,
                  height: 480,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/location.gif',
                        width: double.infinity,
                        height: 200.0,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Location Permission",
                        style: TextStyle(
                            fontSize: 16 + 1,
                            fontWeight: FontWeight.w800,
                            fontFamily: "RedHat"),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "This app collects location data to enable access location to allow location for show near event, when the app is closed not in use.",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black26,
                            fontFamily: "RedHat"),
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                await Permission.location.request();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                              ),
                              onPressed: () async {
                                await Permission.location.request();
                                prefs.setBool('hasLocationPermission', true);
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
    }
  }

  handleAppleSignIn() async {
    final sb = context.read<SignInProvider>();
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'check your internet connection!');
      } else {
        await sb.signInWithApple().then((_) {
          if (sb.hasError == true) {
            openSnacbar(scaffoldKey, 'something is wrong. please try again.');
            _appleController.reset();
          } else {
            sb.checkUserExists().then((value) {
              if (value == true) {
                sb
                    .getUserDataFromFirebase(sb.uid)
                    .then((value) {
                              _appleController.success();
                              handleAfterSignIn();
                            });
              } else {
                sb.getTimestamp().then((value) => sb
                    .saveToFirebase()
                    .then((value) {
                              _appleController.success();
                              handleAfterSignIn();
                            }));
              }
            });
          }
        });
      }
    });
  }

  handleAfterSignIn() {
    setState(() {
      Future.delayed(Duration(milliseconds: 1000)).then((f) {
        gotoNextScreen();
      });
    });
  }

  gotoNextScreen() {
    Navigator.of(context).push(
        PageRouteBuilder(pageBuilder: (_, __, ___) => SelectInterestScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Image(
                        //     image: AssetImage(Config().splashIcon),
                        //     height: 130,
                        //   ),
                        SizedBox(
                          height: 50,
                        ),
                        Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 270.0,
                                    height: 100.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/logoSplash.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedLoadingButton(
                        child: Wrap(
                          children: [
                            Icon(
                              FontAwesome.google,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              ('Sign In with Google').tr(),
                              style: TextStyle(
                                  fontFamily: Constant.fontsFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        controller: _googleController,
                        onPressed: () => handleGoogleSignIn(),
                        width: MediaQuery.of(context).size.width * 0.80,
                        color: Colors.blueAccent,
                        elevation: 0,
                        //borderRadius: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedLoadingButton(
                        child: Wrap(
                          children: [
                            Icon(
                              Icons.mail,
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              ('Sign In with Email').tr(),
                              style: TextStyle(
                                  fontFamily: Constant.fontsFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        controller: _facebookController,
                        onPressed: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                Routes.loginRoute, (route) => false),
                        width: MediaQuery.of(context).size.width * 0.80,
                        color: Colors.red[600],
                        elevation: 0,
                        //borderRadius: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Platform.isAndroid ? Container() : _appleSignInButton()
                    ],
                  ),
                ),
                Text(
                  ("don't have social accounts and email account?").tr(),
                  style: TextStyle(
                      fontFamily: Constant.fontsFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                TextButton(
                  child: Text(
                    ('Sign Up with Email here').tr(),
                    style: TextStyle(
                        fontFamily: Constant.fontsFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => SignUpScreen()));
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 20.0),
              child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              MultipleLanguageScreen()));
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.black12, width: 1.0)),
                      child: Center(
                        child: Image.asset(
                          "assets/images/worldwide.png",
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<bool> _appleSignInButton() {
    return FutureBuilder<bool>(
      future: _isAvailableFuture,
      builder: (context, AsyncSnapshot isAvailableSnapshot) {
        if (!isAvailableSnapshot.hasData) {
          return Container();
        }

        return !isAvailableSnapshot.data
            ? Container()
            : RoundedLoadingButton(
                child: Wrap(
                  children: [
                    Icon(
                      FontAwesome.apple,
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      ' Sign In with Apple',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                  ],
                ),
                controller: _appleController,
                onPressed: () => handleAppleSignIn(),
                width: MediaQuery.of(context).size.width * 0.80,
                color: Colors.grey[800],
                elevation: 0,
                //borderRadius: 10,
              );
      },
    );
  }
}
