import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/view/home/home_screen.dart';
import 'package:event_app/app/view/intro/welcome.dart';
import 'package:flutter/material.dart';

import '../../../base/constant.dart';

class MultipleLanguageScreen extends StatefulWidget {
  const MultipleLanguageScreen();

  _MultipleLanguageScreenState createState() => _MultipleLanguageScreenState();
}

class _MultipleLanguageScreenState extends State<MultipleLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          ('changeLanguage'),
          style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 17.5,
              fontFamily: "Gilroy",
              letterSpacing: 1.2,
              color: Colors.black),
        ).tr(),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: <Widget>[
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        Navigator.pop(_);
                                        context.setLocale(
                                            const Locale('en', 'US'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag: "assets/images/america.png",
                  title: ('english').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: Text(('changeLanguage').tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w800))
                            .tr(),
                        content: Text(
                          ('descCard').tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Gilroy",
                            color: Colors.black54,
                            fontWeight: FontWeight.w300,
                          ),
                        ).tr(),
                        actions: [
                          Column(
                            children: [
                              Container(
                                height: 1.0,
                                width: double.infinity,
                                color: Colors.black12,
                              ),
                              Center(
                                child: TextButton(
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.blue),
                                  ).tr(),
                                  onPressed: () {
                                    Navigator.pop(_);
                                    context.setLocale(
                                        const Locale('tr', 'TR'));
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ));
                },
                child: CardName(
                  flag: "assets/images/turkey.png",
                  title: ('turkish').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        Navigator.pop(_);
                                        context.setLocale(
                                            const Locale('en', 'ES'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag:
                      "assets/images/spain.png",
                  title: ('spanish').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        Navigator.pop(_);
                                        context.setLocale(
                                            const Locale('fr', 'CH'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag:
                      "assets/images/france.png",
                  title: ('french').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        Navigator.pop(_);
                                        context.setLocale(
                                            const Locale('de', 'DE'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag: "assets/images/germany.png",
                  title: ('germany').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        Navigator.pop(_);
                                        context.setLocale(
                                            const Locale('hi', 'IN'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag: "assets/images/india.png",
                  title: ('india').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        // Close;
                                        Navigator.pop(_);
                                        // Navigator.of(context).pop();
                                        context.setLocale(
                                            const Locale('ar', 'DZ'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag: "assets/images/arabic.png",
                  title: ('arabic').tr(),
                )),
            InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w800))
                                .tr(),
                            content: Text(
                              ('descCard').tr(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                              ),
                            ).tr(),
                            actions: [
                              Column(
                                children: [
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black12,
                                  ),
                                  Center(
                                    child: TextButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(color: Colors.blue),
                                      ).tr(),
                                      onPressed: () {
                                        // Close;
                                        Navigator.pop(_);
                                        // Navigator.of(context).pop();
                                        context.setLocale(
                                            const Locale('fi', 'FI'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: CardName(
                  flag: "assets/images/finland.png",
                  title: ('finland').tr(),
                )),
          ]),
        ),
      ),
    );
  }
}

class CardName extends StatelessWidget {
  final String title, flag;

  CardName(
      {required this.title,
      required this.flag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Container(
        height: 80.0,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10.0,
                  spreadRadius: 0.0)
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Row(children: <Widget>[
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.black12.withOpacity(0.06),
                  spreadRadius: 10.0,
                )
              ]),
              child: Image.asset(
                flag,
                width: 41.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.3),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
