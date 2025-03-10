import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../widget/Rounded_Button.dart';

import 'package:http/http.dart' as http;

class CreateNotificationScreen extends StatefulWidget {
  const CreateNotificationScreen({super.key});

  @override
  State<CreateNotificationScreen> createState() =>
      _CreateNotificationScreenState();
}

class _CreateNotificationScreenState extends State<CreateNotificationScreen> {
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

  
  void sendNotification(String title, String body) async {
 
    List<String> allTokens = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("UserTokens").get();
snapshot.docs.forEach((doc) {
   Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  if (data != null) {
    String token = data['token'];

    allTokens.add(token);
    
  }
print(allTokens);
  // setState(() {
  //   allTokens.add(token);
  // });
});


        // Send notification to each FCM token
    for (String token in allTokens) {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAe6Ts2VU:APA91bELeOqnREA-0yruuVPGCIEgZESZ7_iFK7LNqFMHUGIHT9VmuKaISotsAZfagEok5QNndb6O3D6eoPQ7V-VFq_MTyOhj6zOYfeLBiMC1kd1IixGtz1t54e7weACj-T8epfHb4Je9',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,

            },
            'priority': 'high',
            'data': 
            // [
              
            // ],
             <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to":token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }}
  }
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
     
        title: Text(
          "Create Notification",
          style: const TextStyle(
              fontFamily: "sofia", fontSize: 19.0, fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      flex: 1,
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(34)),
                                boxShadow: [
                                  BoxShadow(
                                      color: "#2B9CC3C6".toColor(),
                                      blurRadius: 24,
                                      offset: const Offset(0, -2))
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getVerSpace(24),
                                getCustomFont("Title", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7),
                                TextFormField(
                                  controller: nameCtrl,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: 'Title Description',
                                      labelText: 'Enter Title',
                                      counter: Container(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: accentColor, width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          fontFamily: Constant.fontsFamily),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24,
                                      ),
                                      hintStyle: TextStyle(
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          fontFamily: Constant.fontsFamily)),
                                  validator: (String? value) {
                                    if (value!.length == 0)
                                      return "Title can't be empty";
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      name = value;
                                    });
                                  },
                                ),
                                getVerSpace(24),
                                getCustomFont(
                                    "Description", 16, Colors.black, 1,
                                    fontWeight: FontWeight.w600),
                                getVerSpace(7),
                                TextFormField(
                                  decoration: InputDecoration(
                                      hintText:
                                          'Please write description for the notifications',
                                      labelText: 'Enter Description',
                                      counter: Container(),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 20),
                                      isDense: true,
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: accentColor, width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: errorColor, width: 1)),
                                      errorStyle: TextStyle(
                                          color: Colors.red,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          fontFamily: Constant.fontsFamily),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(22),
                                          borderSide: BorderSide(
                                              color: borderColor, width: 1)),
                                      suffixIconConstraints: BoxConstraints(
                                        maxHeight: 24,
                                      ),
                                      hintStyle: TextStyle(
                                          color: greyColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          fontFamily: Constant.fontsFamily)),
                                  controller: emailCtrl,
                                  maxLines: 10,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.length == 0)
                                      return "Desc can't be empty";
                                    return null;
                                  },
                                  onChanged: (String value) {
                                    setState(() {
                                      email = value;
                                    });
                                  },
                                ),
                                getVerSpace(24),

                                getVerSpace(100),
                                
                                RoundedLoadingButton(
                                  animateOnTap: true,
                                  successColor: accentColor,
                                  controller: _btnController,
                                  onPressed: () {
                                    sendNotification(name??'', email??'');
                                             showDialog(
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(37),
                            ),
                            insetPadding: EdgeInsets.symmetric(horizontal: 20),
                            backgroundColor: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                getVerSpace(30),
                                Container(
                                  width: double.infinity,
                                  height: 190,
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(34))),
                                  child: Column(
                                    children: [
                                      getVerSpace(40),
                                      Image.asset(
                                        'assets/images/Sukses.gif',
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(37),
                                      boxShadow: [
                                        BoxShadow(
                                            color: "#2B9CC3C6".toColor(),
                                            offset: const Offset(0, -2),
                                            blurRadius: 24)
                                      ]),
                                  child: Column(
                                    children: [
                                      getVerSpace(30),
                                      getCustomFont(
                                          'User Created', 22, Colors.black, 1,
                                          fontWeight: FontWeight.w700,
                                          txtHeight: 1.5),
                                      getVerSpace(8),
                                      getMultilineCustomFont(
                                          "User succes created",
                                          16,
                                          Colors.black,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.5),
                                      getVerSpace(30),
                                      getButton(context, Colors.redAccent,
                                          "Close", Colors.white, () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }, 18,
                                          weight: FontWeight.w700,
                                          buttonHeight: 60,
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      getVerSpace(30),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        context: context);
                    Navigator.of(context);
                    _btnController.success();
              
                                    // handleSignUpwithEmailPassword();
                                  },
                                  width:
                                      MediaQuery.of(context).size.width * 1.0,
                                  color: accentColor,
                                  elevation: 0,
                                  child: Wrap(
                                    children: const [
                                      Text(
                                        'Create Notification Messages',
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
                                // }, 18,
                                //     weight: FontWeight.w700,
                                //     buttonHeight: 60,
                                //     borderRadius: BorderRadius.circular(22)),
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

  
}
