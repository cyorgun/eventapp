import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:event_app/app/view/home/home_screen.dart';

class MultipleLanguageScreen extends StatefulWidget {
  MultipleLanguageScreen({Key? key}) : super(key: key);

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
        title:  Text(
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
              Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new HomeScreen()));
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
    
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
            
              InkWell(
                  onTap: () {
                   
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                              title:  Text(('changeLanguage').tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Gilroy",
                                        color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w800))
                                  .tr(),
                              content:  Text(
                                ('descCard').tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Gilroy",
                                        color: Colors.black54,
                                    fontWeight: FontWeight.w300,),
                              ).tr(),
                              actions: [
                                Column(
                                  children: [
                                    
                                Container(height: 1.0,width: double.infinity,color: Colors.black12,),
                                    Center(
                                      child: TextButton(
                                        child:  Text("Ok",style: TextStyle(color: Colors.blue),).tr(),
                                        onPressed: () {
                                          
                                          Navigator.pop(_);
                                          context.setLocale(const Locale('en', 'US'));
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                  },
                  child: cardName(
                    flag: "https://thumbs2.imgbox.com/83/76/MhtndBd1_t.png",
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
                                        context.setLocale(const Locale('en', 'ES'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: cardName(
                  flag2: true,
                  width: 30.0,
                  flag: "https://www.countryflags.com/wp-content/uploads/spain-flag-png-xl.png",
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
                                        context.setLocale(const Locale('fr', 'CH'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: cardName(
                  flag: "https://img.freepik.com/free-vector/illustration-france-flag_53876-27099.jpg",
                  flag2: true,
                  width: 25.0,
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
                                        context.setLocale(const Locale('de', 'DE'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: cardName(
                  flag: "assets/images/germany.png",
                  title: ('germany').tr(),
                  flag1: false,
                )),

                        InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(('changeLanguage').tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w800))
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
                                        context.setLocale(const Locale('hi', 'IN'));
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ));
                },
                child: cardName(
                  flag: "assets/images/india.png",
                  title: ('india').tr(),
                  flag1: false,
                )),
            
                                InkWell(
                  onTap: () {
          
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                              title:  Text(('changeLanguage').tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w800))
                                  .tr(),
                              content:  Text(
                                ('descCard').tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        color: Colors.black54,
                                    fontWeight: FontWeight.w300,),
                              ).tr(),
                              actions: [
                                Column(
                                  children: [
                                    
                                Container(height: 1.0,width: double.infinity,color: Colors.black12,),
                                    Center(
                                      child: TextButton(
                                        child:  Text("Ok",style: TextStyle(color: Colors.blue),).tr(),
                                        onPressed: () {
                                          // Close;
                                          Navigator.pop(_);
                                          // Navigator.of(context).pop();
                                          context.setLocale(const Locale('ar', 'DZ'));
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                  },
                  child: cardName(
                    flag: "https://thumbs2.imgbox.com/83/f5/y4BZ7a3i_t.png",
                    title: ('arabic').tr(),
                  )),
                            InkWell(
                  onTap: () {
          
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                              title:  Text(('changeLanguage').tr(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w800))
                                  .tr(),
                              content:  Text(
                                ('descCard').tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        color: Colors.black54,
                                    fontWeight: FontWeight.w300,),
                              ).tr(),
                              actions: [
                                Column(
                                  children: [
                                    
                                Container(height: 1.0,width: double.infinity,color: Colors.black12,),
                                    Center(
                                      child: TextButton(
                                        child:  Text("Ok",style: TextStyle(color: Colors.blue),).tr(),
                                        onPressed: () {
                                          // Close;
                                          Navigator.pop(_);
                                          // Navigator.of(context).pop();
                                          context.setLocale(const Locale('fi', 'FI'));
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                  },
                  child: cardName(
                  flag: "assets/images/finland.png",
                  title: ('finland').tr(),
                  flag1: false,
                  )),
              // InkWell(
              //     onTap: () {
          
              //       showDialog(
              //           context: context,
              //           builder: (_) => AlertDialog(
              //             backgroundColor: Colors.white,
              //                 title:  Text(('changeLanguage').tr(),
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           color: Colors.black,
              //                             fontSize: 18.0,
              //                             fontWeight: FontWeight.w800))
              //                     .tr(),
              //                 content:  Text(
              //                   ('descCard').tr(),
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                           color: Colors.black54,
              //                       fontWeight: FontWeight.w300,),
              //                 ).tr(),
              //                 actions: [
              //                   Column(
              //                     children: [
                                    
              //                   Container(height: 1.0,width: double.infinity,color: Colors.black12,),
              //                       Center(
              //                         child: TextButton(
              //                           child:  Text("Ok",style: TextStyle(color: Colors.blue),).tr(),
              //                           onPressed: () {
              //                             // Close;
              //                             Navigator.pop(_);
              //                             // Navigator.of(context).pop();
              //                             context.setLocale(const Locale('ar', 'DZ'));
              //                           },
              //                         ),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ));
              //     },
              //     child: cardName(
              //       flag: "https://thumbs2.imgbox.com/83/f5/y4BZ7a3i_t.png",
              //       title: ('arabic').tr(),
              //     )),
            
              // InkWell(
              //     onTap: () {
              //       showDialog(
              //           context: context,
              //           builder: (_) => AlertDialog(
              //             backgroundColor: Colors.white,
              //                 title:  Text(('changeLanguage').tr(),
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           color: Colors.black,
              //                             fontSize: 18.0,
              //                             fontWeight: FontWeight.w800))
              //                     .tr(),
              //                 content:  Text(
              //                   ('descCard').tr(),
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                           color: Colors.black54,
              //                       fontWeight: FontWeight.w300,),
              //                 ).tr(),
              //                 actions: [
              //                   Column(
              //                     children: [
                                    
              //                   Container(height: 1.0,width: double.infinity,color: Colors.black12,),
              //                       Center(
              //                         child: TextButton(
              //                           child:  Text("Ok",style: TextStyle(color: Colors.blue),).tr(),
              //                           onPressed: () {
              //                             context.setLocale(const Locale('Fi', 'Fi'));
              //                             Navigator.pop(context);
              //                           },
              //                         ),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ));
              //     },
              //     child:  cardName(
              //       flag: "https://thumbs2.imgbox.com/83/76/MhtndBd1_t.png",
              //       title: ('Finnish').tr(),
              //     )
                  
              //     ),
      
              //        InkWell(
              //     onTap: () {
              //       showDialog(
              //           context: context,
              //           builder: (_) => AlertDialog(
              //             backgroundColor: Colors.white,
              //                 title:  Text(('changeLanguage').tr(),
              //                         textAlign: TextAlign.center,
              //                         style: TextStyle(
              //                           color: Colors.black,
              //                             fontSize: 18.0,
              //                             fontWeight: FontWeight.w800))
              //                     .tr(),
              //                 content:  Text(
              //                   ('descCard').tr(),
              //                   textAlign: TextAlign.center,
              //                   style: TextStyle(
              //                           color: Colors.black54,
              //                       fontWeight: FontWeight.w300,),
              //                 ).tr(),
              //                 actions: [
              //                   Column(
              //                     children: [
                                    
              //                   Container(height: 1.0,width: double.infinity,color: Colors.black12,),
              //                       Center(
              //                         child: TextButton(
              //                           child:  Text("Ok",style: TextStyle(color: Colors.blue),).tr(),
              //                           onPressed: () {
              //                             context.setLocale(const Locale('id', 'ID'));
              //                             Navigator.pop(context);
              //                           },
              //                         ),
              //                       ),
              //                     ],
              //                   )
              //                 ],
              //               ));
              //     },
              //     child:  cardName(
              //       flag: "https://thumbs2.imgbox.com/83/76/MhtndBd1_t.png",
              //       title: ('indonesia').tr(),
              //     )),
              //
              ]   ),
  
        ),
      ),
    );
  }
}


class cardName extends StatelessWidget {
  
  double? width = 0;
  String title, flag;
  bool flag1 = true;
  bool? flag2 = true;
  cardName({ this.width, this.flag2, required this.title, required this.flag, this.flag1 = true});

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
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.0, spreadRadius: 0.0)]),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Row(children: <Widget>[
            flag1
                ? Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black12.withOpacity(0.06),
                        spreadRadius: 10.0,
                      )
                    ]),
                    child: Image.network(
                      flag,
                      height: flag2 == true ?  width :41.0,
                 
                      // width: 100.0,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black12.withOpacity(0.06),
                        spreadRadius: 10.0,
                      )
                    ]),
                    child: Image.asset(
                      flag,
                      height: 41.0,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500, letterSpacing: 1.3),
              ),
            )
          ]),
        ),
      ),
    );
  }
}