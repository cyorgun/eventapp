import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/controller/controller.dart';
import 'package:event_app/app/modal/modal_event.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/ticket_confirm_dialog.dart';
import '../bloc/sign_in_bloc.dart';
import '../ticket/ticket_detail.dart';
import 'package:http/http.dart' as http;

class BuyTicket extends StatefulWidget {
 Event? event;
  BuyTicket({
    Key? key,
   this.event
  }) : super(key: key);

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  void backClick() {
    Constant.backToPrev(context);
  }
  BuyTicketController controller = Get.put(BuyTicketController());

  int _itemCount = 1;

  Map<String, dynamic>? paymentIntent;
  //  var prices = price?? 0
  int? prices;
  int? totalPrice;

  @override
  void initState() {
    prices = widget.event?.price ?? 0;
    totalPrice = widget.event?.price ?? 0;
  }

  @override
  Widget build(BuildContext context) {

     final Event event = widget.event!;
    final sb = context.watch<SignInBloc>();
      void addData() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("JoinEvent")
            .doc("user")
            .collection(widget.event?.title??'')
            .doc(sb.uid)
            .set({
          "name": sb.name,
          "uid": sb.uid,
          "photoProfile": sb.imageUrl
        });
      });
    }



     void userSaved() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        SharedPreferences prefs;
        prefs = await SharedPreferences.getInstance();
        FirebaseFirestore.instance
            .collection("users")
            .doc(sb.uid)
            .collection('Join Event')
            .add({
          "uid": sb.uid,
          "user": sb.name,
          "category":event.category,
          "date":event.date,
          "description":event.description,
          "id":event.id,
          "image":event.image,
          "location":event.location,
          "mapsLangLink":event.mapsLangLink,
          "mapsLatLink":event.mapsLatLink,
          "price":totalPrice,
          "title":event.title,
          "type":event.type,
          "userDesc":event.userDesc,
          "userName":event.userName,
          "userProfile":event.userProfile,
          "ticket":_itemCount
        });
      });
      Navigator.pop(context);
    }


    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getToolBar(
          () {
            backClick();
          },
          title: getCustomFont("Buy Ticket", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Divider(color: dividerColor, thickness: 1.h, height: 1.h),
              Expanded(
                  flex: 1,
                  child: ListView(
                    children: [
                      getVerSpace(30.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: getCustomFont(
                                "Price", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          ),

                          getVerSpace(10.h),
                          GestureDetector(
                            onTap: () {
                              controller.onChange(0.obs);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.h),
                                  border: Border.all(
                                      color: borderColor, width: 1.h)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.h, vertical: 18.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // GetX<BuyTicketController>(
                                      //   builder: (controller) => getSvgImage(
                                      //       controller.select.value == 0
                                      //           ? "checkRadio.svg"
                                      //           : "uncheckRadio.svg",
                                      //       width: 24.h,
                                      //       height: 24.h),
                                      //   init: BuyTicketController(),
                                      // ),
                                      getHorSpace(10.h),
                                      getCustomFont("Ticket Price", 16.sp,
                                          Colors.black, 1,
                                          fontWeight: FontWeight.w500,
                                          txtHeight: 1.5.h)
                                    ],
                                  ),
                                  getCustomFont("\$ " + event.price.toString(),
                                      18.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w600,
                                      txtHeight: 1.5.h)
                                ],
                              ),
                            ),
                          ),
                          getVerSpace(20.h),
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.onChange(1.obs);
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.symmetric(horizontal: 20.h),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         borderRadius: BorderRadius.circular(22.h),
                          //         border: Border.all(color: borderColor, width: 1.h)),
                          //     padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 18.h),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             GetX<BuyTicketController>(
                          //               builder: (controller) => getSvgImage(
                          //                   controller.select.value == 1
                          //                       ? "checkRadio.svg"
                          //                       : "uncheckRadio.svg",
                          //                   width: 24.h,
                          //                   height: 24.h),
                          //               init: BuyTicketController(),
                          //             ),
                          //             getHorSpace(10.h),
                          //             getCustomFont("Economy", 16.sp, Colors.black, 1,
                          //                 fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                          //           ],
                          //         ),
                          //         getCustomFont("\$21.00", 18.sp, Colors.black, 1,
                          //             fontWeight: FontWeight.w600, txtHeight: 1.5.h)
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      getVerSpace(30.h),
                    
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: getCustomFont(
                                "Quantity Seat", 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          ),
                          // getPaddingWidget(
                          //   EdgeInsets.symmetric(horizontal: 20.h),
                          //   Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       getCustomFont("64", 16.sp, Colors.black, 1,
                          //           fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          //       getCustomFont("People joined", 15.sp, greyColor, 1,
                          //           fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                          //     ],
                          //   ),
                          // ),
                          getVerSpace(10.h),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: borderColor, width: 1.h),
                                borderRadius: BorderRadius.circular(22.h)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.h, vertical: 6.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius:
                                            BorderRadius.circular(18.h)),
                                    height: 68.h,
                                    width: 68.h,
                                    padding: EdgeInsets.all(22.h),
                                    child: getSvgImage("minus.svg",
                                    color: Colors.white,
                                        width: 24.h, height: 24.h),
                                  ),
                                  onTap: () {
                                    if (_itemCount == 1) {
                                    } else {
                                      _itemCount--;
                                      setState(() {
                                        // totalPrice = controller.count.value * widget.price;
                                        var prices = event.price ?? 0;
                                        totalPrice = _itemCount * prices;
                                      });
                                      //  controller.countChange(controller.count.obs.value--);
                                    }
                                  },
                                ),
                                getCustomFont(_itemCount.toString(), 22.sp,
                                    Colors.black, 1,
                                    fontWeight: FontWeight.w700,
                                    txtHeight: 1.5.h),
                                GestureDetector(
                                  onTap: () {
                                    _itemCount++;
                                    // controller.countChange(controller.count.obs.value++);
                                    setState(() {
                                      var prices = event.price ?? 0;
                                      // totalPrice = controller.count.value * widget.price;
                                      totalPrice = _itemCount * prices;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius:
                                            BorderRadius.circular(18.h)),
                                    height: 68.h,
                                    width: 68.h,
                                    padding: EdgeInsets.all(22.h),
                                    child: getSvgImage("add.svg",
                                        width: 24.h,
                                        height: 24.h,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),


 Padding(
                            padding: const EdgeInsets.only(left: 20.0,top: 40.0),
                            child: getCustomFont(
                                "Who Joins event " + (event.title ??"") , 16.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                          ),
                             StreamBuilder(
                               stream: FirebaseFirestore.instance
                                   .collection("JoinEvent")
                                   .doc("user")
                                   .collection(event.title ?? '')
                                   .snapshots(),
                               builder: (BuildContext ctx,
                                   AsyncSnapshot<QuerySnapshot> snapshot) {
                                 return snapshot.hasData
                                     ? new joinEvent(
                                         list: snapshot.data?.docs,
                                       )
                                     : Container();
                               },
                             ),
                        ],
                      ),
                    ],
                  )),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                Column(
                  children: [
                   if(event.price!>0)   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont("Total", 22.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        getCustomFont("\$ " + totalPrice.toString() ?? '',
                            22.sp, accentColor, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h)
                      ],
                    ),
                    getVerSpace(30.h),
                   
                      if(event.price==0)   getButton(context, accentColor, "Booking", Colors.white,
                        () async {
                          
                          
                      Constant.sendToNext(context, Routes.paymentRoute);
                      showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                        userSaved();
                        addData();
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => TicketDetail(
                               event: event,
                              )));

                    }, 18.sp,
                        weight: FontWeight.w700,
                        buttonHeight: 60.h,
                        borderRadius: BorderRadius.circular(22.h)),
           
                   if(event.price!>0)  getButton(context, accentColor, "Checkout", Colors.white,
                        () async {
                          
                               
                      Constant.sendToNext(context, Routes.paymentRoute);
                      // showDialog(
                      //     builder: (context) {
                      //       return const TicketConfirmDialog();
                      //     },
                      //     context: context);
                       
                        userSaved();
                        addData();
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => TicketDetail(
                               event: event,
                              )));     
                // await makePayment();
                      // Constant.sendToNext(context, Routes.paymentRoute);
                      // showDialog(
                      //     builder: (context) {
                      //       return const TicketConfirmDialog();
                      //     },
                      //     context: context);
                      //   userSaved();
                      //   addData();

                      //   Navigator.of(context).push(PageRouteBuilder(
                      //     pageBuilder: (_, __, ___) => TicketDetail(
                      //           category: widget.category,
                      //           date: widget.date,
                      //           description: widget.description,
                      //           id: widget.id,
                      //           image: widget.image,
                      //           location: widget.location,
                      //           mapsLangLink: widget.mapsLangLink,
                      //           mapsLatLink: widget.mapsLatLink,
                      //           price: totalPrice,
                      //           title: widget.title,
                      //           type: widget.type,
                      //           userDesc: widget.userDesc,
                      //           userName: widget.userName,
                      //           userProfile: widget.userProfile,
                      //         )));

                    }, 18.sp,
                        weight: FontWeight.w700,
                        buttonHeight: 60.h,
                        borderRadius: BorderRadius.circular(22.h)),
                    getVerSpace(30.h), 
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
 Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(totalPrice.toString(), 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
      print(err);
    }
  }


  
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
  Column buildSeatWidget() {
    return Column(
      children: [
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              getCustomFont("Seat", 16.sp, Colors.black, 1,
                  fontWeight: FontWeight.w600, txtHeight: 1.5.h),
              getCustomFont("64/100", 15.sp, greyColor, 1,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h)
            ],
          ),
        ),
        getVerSpace(10.h),
        GetX<BuyTicketController>(
          init: BuyTicketController(),
          builder: (controller) => Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: 1.h),
                borderRadius: BorderRadius.circular(22.h)),
            padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: "#E8F6F6".toColor(),
                        borderRadius: BorderRadius.circular(18.h)),
                    height: 68.h,
                    width: 68.h,
                    padding: EdgeInsets.all(22.h),
                    child: getSvgImage("minus.svg", width: 24.h, height: 24.h),
                  ),
                  onTap: () {
                    if (controller.count.value == 0) {
                    } else {
                      controller.countChange(controller.count.obs.value--);
                    }
                  },
                ),
                getCustomFont(
                    controller.count.value.toString(), 22.sp, Colors.black, 1,
                    fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                GestureDetector(
                  onTap: () {
                    controller.countChange(controller.count.obs.value++);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: "#E8F6F6".toColor(),
                        borderRadius: BorderRadius.circular(18.h)),
                    height: 68.h,
                    width: 68.h,
                    padding: EdgeInsets.all(22.h),
                    child: getSvgImage("add.svg",
                        width: 24.h, height: 24.h, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  // Column buildTicketTypeWidget() {
  //   return Column(
  //     children: [
  //       getPaddingWidget(
  //         EdgeInsets.symmetric(horizontal: 20.h),
  //         getCustomFont("Ticket Type", 16.sp, Colors.black, 1,
  //             fontWeight: FontWeight.w600, txtHeight: 1.5.h),
  //       ),
  //       getVerSpace(10.h),
  //       GestureDetector(
  //         onTap: () {
  //           controller.onChange(0.obs);
  //         },
  //         child: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 20.h),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(22.h),
  //               border: Border.all(color: borderColor, width: 1.h)),
  //           padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 18.h),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   GetX<BuyTicketController>(
  //                     builder: (controller) => getSvgImage(
  //                         controller.select.value == 0
  //                             ? "checkRadio.svg"
  //                             : "uncheckRadio.svg",
  //                         width: 24.h,
  //                         height: 24.h),
  //                     init: BuyTicketController(),
  //                   ),
  //                   getHorSpace(10.h),
  //                   getCustomFont("VIP", 16.sp, Colors.black, 1,
  //                       fontWeight: FontWeight.w500, txtHeight: 1.5.h)
  //                 ],
  //               ),
  //               getCustomFont("\$28.00", 18.sp, Colors.black, 1,
  //                   fontWeight: FontWeight.w600, txtHeight: 1.5.h)
  //             ],
  //           ),
  //         ),
  //       ),
  //       getVerSpace(20.h),
  //       GestureDetector(
  //         onTap: () {
  //           controller.onChange(1.obs);
  //         },
  //         child: Container(
  //           margin: EdgeInsets.symmetric(horizontal: 20.h),
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(22.h),
  //               border: Border.all(color: borderColor, width: 1.h)),
  //           padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 18.h),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   GetX<BuyTicketController>(
  //                     builder: (controller) => getSvgImage(
  //                         controller.select.value == 1
  //                             ? "checkRadio.svg"
  //                             : "uncheckRadio.svg",
  //                         width: 24.h,
  //                         height: 24.h),
  //                     init: BuyTicketController(),
  //                   ),
  //                   getHorSpace(10.h),
  //                   getCustomFont("Economy", 16.sp, Colors.black, 1,
  //                       fontWeight: FontWeight.w500, txtHeight: 1.5.h)
  //                 ],
  //               ),
  //               getCustomFont("\$21.00", 18.sp, Colors.black, 1,
  //                   fontWeight: FontWeight.w600, txtHeight: 1.5.h)
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }




class joinEvent extends StatelessWidget {
  joinEvent({this.list});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15.0,top: 10.0),
          child: Container(
              height: 100.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list!.length > 3 ? 3 : list?.length,
                itemBuilder: (context, i) {
                  String? _title = list?[i]['name'].toString();
                  String? _uid = list?[i]['uid'].toString();
                  String? _img = list?[i]['photoProfile'].toString();

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0,bottom: 5.0),
                        child: Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(70.0)),
                              image: DecorationImage(
                                  image: NetworkImage(_img ?? ''),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Text((list?.length.toString()??'')+ " people joined",style: TextStyle(fontFamily: "Gilroy"),),
                    ],
                  );
                },
              )),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(
        //     top: 0.0,
        //     left: 130.0,
        //   ),
        //   child: Row(
        //     children: [
        //       Positioned(
        //           left: 22.h,
        //           child: Container(
        //             height: 36.h,
        //             width: 36.h,
        //             decoration: BoxDecoration(
        //                 color: accentColor,
        //                 borderRadius: BorderRadius.circular(30.h),
        //                 border: Border.all(color: Colors.white, width: 1.5.h)),
        //             alignment: Alignment.center,
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: [
        //                 getCustomFont(list?.length.toString() ?? '', 12.sp,
        //                     Colors.white, 1,
        //                     fontWeight: FontWeight.w600),
        //                 getCustomFont(" +", 12.sp, Colors.white, 1,
        //                     fontWeight: FontWeight.w600),
        //               ],
        //             ),
        //           )),

        //       // Text(
        //       //   list?.length.toString()??'',
        //       //   style: TextStyle(fontFamily: "Popins"),
        //       // ),
        //       //  Text(
        //       //   " People Join",
        //       //   style: TextStyle(fontFamily: "Popins"),
        //       // ),
        //     ],
        //   ),
        // )
    
      ],
    );
  }
}
