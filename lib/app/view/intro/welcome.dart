import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'package:evente/evente.dart';
import '../../../base/constant.dart';
import '../../dialog/snacbar copy.dart';
import '../../routes/app_routes.dart';
import '../bloc/sign_in_bloc.dart';

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
    final sb = context.read<SignInBloc>();
    sb.setGuestUser();
    // nextScreen(context, DonePage());
  }

  handleGoogleSignIn() async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await AppService().checkInternet().then((hasInternet) async {
      if (hasInternet == false) {
        openSnacbar(scaffoldKey, 'check your internet connection!');
      } else {
        await sb.signInWithGoogle().then((_) {
          if (sb.hasError == true) {
            openSnacbar(scaffoldKey, 'something is wrong. please try again.');
            _googleController.reset();
          } else {
            sb.checkUserExists().then((value) {
              if (value == true) {
                sb
                    .getUserDatafromFirebase(sb.uid)
                    .then((value) => sb.guestSignout())
                    .then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _googleController.success();
                              handleAfterSignIn();
                            })));
              } else {
                sb.getTimestamp().then((value) => sb
                    .saveToFirebase()
                    .then((value) => sb.increaseUserCount())
                    .then((value) => sb.guestSignout())
                    .then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _googleController.success();
                              handleAfterSignIn();
                            }))));
              }
            });
          }
        });
      }
    });
  }

  // void handleFacebbokLogin() async {
  //   final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
  //   await AppService().checkInternet().then((hasInternet) async {
  //     if (hasInternet == false) {
  //       openSnacbar(scaffoldKey, 'check your internet connection!');
  //     } else {
  //       await sb.signInwithFacebook().then((_) {
  //         if (sb.hasError == true) {
  //           openSnacbar(scaffoldKey, 'error fb login');
  //           _facebookController.reset();
  //         } else {
  //           sb.checkUserExists().then((value) {
  //             if (value == true) {
  //               sb
  //                   .getUserDatafromFirebase(sb.uid)
  //                   .then((value) => sb.guestSignout())
  //                   .then((value) => sb
  //                       .saveDataToSP()
  //                       .then((value) => sb.setSignIn().then((value) {
  //                             _facebookController.success();
  //                             handleAfterSignIn();
  //                           })));
  //             } else {
  //               sb.getTimestamp().then((value) => sb
  //                   .saveToFirebase()
  //                   .then((value) => sb.increaseUserCount())
  //                   .then((value) => sb.guestSignout().then((value) => sb
  //                       .saveDataToSP()
  //                       .then((value) => sb.setSignIn().then((value) {
  //                             _facebookController.success();
  //                             handleAfterSignIn();
  //                           })))));
  //             }
  //           });
  //         }
  //       });
  //     }
  //   });
  // }

  handleAppleSignIn() async {
    final sb = context.read<SignInBloc>();
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
                    .getUserDatafromFirebase(sb.uid)
                    .then((value) => sb.guestSignout())
                    .then((value) => sb
                        .saveDataToSP()
                        .then((value) => sb.setSignIn().then((value) {
                              _appleController.success();
                              handleAfterSignIn();
                            })));
              } else {
                sb.getTimestamp().then((value) => sb
                    .saveToFirebase()
                    .then((value) => sb.increaseUserCount())
                    .then((value) => sb.saveDataToSP().then((value) => sb
                        .guestSignout()
                        .then((value) => sb.setSignIn().then((value) {
                              _appleController.success();
                              handleAfterSignIn();
                            })))));
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

  gotoNextScreen() {   Constant.sendToNext(
                                context, Routes.selectInterestRoute);
    
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
                            Icon(FontAwesome.google, size: 25, color: Colors.white,),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Sign In with Google',
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
                            Icon(Icons.mail, size: 25, color: Colors.white,),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Sign In with Email',
                              style: TextStyle(
                                  fontFamily: Constant.fontsFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        controller: _facebookController,
                        onPressed: () => 
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.loginRoute, (route) => false),
                        width: MediaQuery.of(context).size.width * 0.80,
                        color: Colors.red[600],
                        elevation: 0,
                        //borderRadius: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Platform.isAndroid ? Container() : _appleSignInButton()
                    ],
                  ),
                ),
                Text(
                  "don't have social accounts and email account?",
                  style: TextStyle(
                      fontFamily: Constant.fontsFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]),
                ),
                TextButton(
                  child: Text(
                    'Sign Up with Email here',
                    style: TextStyle(
                        fontFamily: Constant.fontsFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blueAccent
                    ),
                  ),
                  onPressed: () {

                                  Constant.sendToNext(
                                      context, Routes.signUpRoute);
                  },
                ),
                SizedBox(
                  height: 15,
                ),
              ],
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
                    Icon(FontAwesome.apple, size: 25, color: Colors.white,),
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
