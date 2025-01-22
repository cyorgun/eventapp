import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/featured_event/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evente/evente.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/ticket_confirm_dialog.dart';
import '../bloc/sign_in_bloc.dart';
import '../ticket/ticket_detail.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

class BuyTicket extends StatefulWidget {
  EventBaru? event;
  BuyTicket({Key? key, this.event}) : super(key: key);

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
 

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
    final EventBaru event = widget.event!;
    final sb = context.watch<SignInBloc>();
    void addData() {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        FirebaseFirestore.instance
            .collection("JoinEvent")
            .doc("user")
            .collection(widget.event?.title ?? '')
            .doc(sb.uid)
            .set({"name": sb.name, "uid": sb.uid, "photoProfile": sb.imageUrl});
      });
    }

    void addEvent() {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        final eventDocRef = FirebaseFirestore.instance
            .collection("event")
            .doc(widget.event?.id ?? '');
        final snapshot = await transaction.get(eventDocRef);

        if (snapshot.exists) {
          final existingData = snapshot.data();
          final newData = {
            "name": sb.name,
            "uid": sb.uid,
            "photoProfile": sb.imageUrl,
          };

          if (existingData != null && existingData.containsKey("joinEvent")) {
            final joinEventData =
                Map<String, dynamic>.from(existingData["joinEvent"]);
            FirebaseFirestore.instance
                .collection('event')
                .doc(widget.event?.id)
                .update({'join': FieldValue.increment(1)});
            if (!joinEventData.containsKey(sb.uid)) {
              joinEventData[sb.uid ?? ''] = newData;
            } else {
              // Jika user sudah ada, update field yang sesuai
              joinEventData[sb.uid]["name"] = sb.name;
              joinEventData[sb.uid]["uid"] = sb.uid;
              joinEventData[sb.uid]["photoProfile"] = sb.imageUrl;
            }

            transaction.update(eventDocRef, {"joinEvent": joinEventData});
            FirebaseFirestore.instance
                .collection('event')
                .doc(widget.event?.id)
                .update({'join': FieldValue.increment(1)});
            // transaction.update(eventDocRef, {"paymentType": "COD"});
          } else {
            transaction.update(eventDocRef, {
              "joinEvent": {sb.uid: newData}
            });
            FirebaseFirestore.instance
                .collection('event')
                .doc(widget.event?.id)
                .update({'join': FieldValue.increment(1)});
            // transaction.update(eventDocRef, {"paymentType": "COD"});
          }
        }
      }).then((value) {
        print('Data map dengan array berhasil ditambahkan ke joinEvent.');
      }).catchError((error) {
        print('Error: $error');
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
          "category": event.category,
          "date": event.date,
          "description": event.description,
          "id": event.id,
          "image": event.image,
          "location": event.location,
          "mapsLangLink": event.mapsLangLink,
          "mapsLatLink": event.mapsLatLink,
          "price": totalPrice,
          "title": event.title,
          "type": event.type,
          "userDesc": event.userDesc,
          "userName": event.userName,
          "userProfile": event.userProfile,
          "ticket": _itemCount
        });
      });
      Navigator.pop(context);
    }

    setStatusBarColor(Colors.white);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getToolBar(
        () {
          Navigator.of(context).pop();
        },
        title: getCustomFont(("buyTicket").tr(), 24.sp, Colors.black, 1,
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
                              ("price").tr(), 16.sp, Colors.black, 1,
                              fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                        ),

                        getVerSpace(10.h),
                        GestureDetector(
                          onTap: () {},
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
                                    getCustomFont(("ticketPrice").tr(), 16.sp,
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
                              ("quantitySeat").tr(), 16.sp, Colors.black, 1,
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
                                      width: 24.h,
                                      height: 24.h),
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
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 40.0),
                          child: getCustomFont(
                              ("WhoJoinsevent").tr() + (event.title ?? ""),
                              16.sp,
                              Colors.black,
                              1,
                              fontWeight: FontWeight.w600,
                              txtHeight: 1.5.h),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, top: 10.0),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("JoinEvent")
                                .doc("user")
                                .collection(event.title ?? '')
                                .snapshots(),
                            builder: (BuildContext ctx,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return snapshot.hasData
                                  ? new joinEvents(
                                      list: snapshot.data?.docs,
                                    )
                                  : Container();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            getPaddingWidget(
              EdgeInsets.symmetric(horizontal: 20.h),
              Column(
                children: [
                  if (event.price! > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomFont(("total").tr(), 22.sp, Colors.black, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                        getCustomFont("\$ " + totalPrice.toString() ?? '',
                            22.sp, accentColor, 1,
                            fontWeight: FontWeight.w700, txtHeight: 1.5.h)
                      ],
                    ),
                  getVerSpace(30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      getButton(
                          context, accentColor, ("Checkout COD").tr(), Colors.white,
                          buttonWidth: MediaQuery.of(context).size.width /
                              2.5, () async {
                                   Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PaymentScreen()));
               
                        // Constant.sendToNext(context, Routes.paymentRoute);
                        showDialog(
                            builder: (context) {
                              return const TicketConfirmDialog();
                            },
                            context: context);
                        userSaved();
                        addEvent();
                        addData();

                        Navigator.of(context)
                            .pushReplacement(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => TicketDetail(
                                      event: widget.event,
                                    )));
                      }, 18.sp,
                          weight: FontWeight.w700,
                          buttonHeight: 60.h,
                          borderRadius: BorderRadius.circular(22.h)),
                      getVerSpace(30.h),
                      if (event.price! > 0)
                        getButton(context, accentColor, ("Checkout Payment").tr(),
                            Colors.white,
                            buttonWidth: MediaQuery.of(context).size.width /
                                2.5, () async {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => PaymentScreen(
                                    event: event,
                                  )));
                          // await makePayment();
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                      getVerSpace(30.h),
                      if (event.price == 0)
                        getButton(
                            context, accentColor, ("Booking").tr(), Colors.white,
                            buttonWidth: MediaQuery.of(context).size.width /
                                2.5, () async {
                          userSaved();
                          addData();
                             Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PaymentScreen()));
               
                          // Constant.sendToNext(context, Routes.paymentRoute);
                          showDialog(
                              builder: (context) {
                                return const TicketConfirmDialog();
                              },
                              context: context);
                          Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => TicketDetail(
                                        event: event,
                                      )));
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                    ],
                  ),
                  getVerSpace(30.h),
                ],
              ),
            )
          ],
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
                      Text(("Payment Successful!").tr()),
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
              children:  [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text(("Payment Failed").tr()),
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

class joinEvents extends StatelessWidget {
  joinEvents({this.list});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Container(
              height: 25.0,
              width: 54.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list!.length > 3 ? 3 : list?.length,
                itemBuilder: (context, i) {
                  String? _title = list?[i]['name'].toString();
                  String? _uid = list?[i]['uid'].toString();
                  String? _img = list?[i]['photoProfile'].toString();

                  return Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(70.0)),
                          image: DecorationImage(
                              image: NetworkImage(_img ?? ''),
                              fit: BoxFit.cover)),
                    ),
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 3.0,
            left: 0.0,
          ),
          child: Row(
            children: [
              Container(
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(30.h),
                    border: Border.all(color: Colors.white, width: 1.5.h)),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getCustomFont(
                        list?.length.toString() ?? '', 12.sp, Colors.white, 1,
                        fontWeight: FontWeight.w600),
                    getCustomFont(" +", 12.sp, Colors.white, 1,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
