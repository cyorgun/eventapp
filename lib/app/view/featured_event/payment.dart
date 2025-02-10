import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/dialog/ticket_confirm_dialog.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../provider/sign_in_provider.dart';
import '../ticket/ticket_detail.dart';

class PaymentScreen extends StatefulWidget {
  EventBaru? event;

  PaymentScreen({this.event, Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Client client;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  int _itemCount = 1;

  Map<String, dynamic>? paymentIntent;

  //  var prices = price?? 0
  int? prices;
  int? totalPrice;
  late Razorpay _razorpay;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    prices = widget.event?.price ?? 0;
    totalPrice = widget.event?.price ?? 0;
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': totalPrice! * 100,
      "currency": "USD",
      'name': 'Checkout',
      'description': widget.event?.title ?? "0",
      'prefill': {'contact': '8232378987', 'email': "event_official@gmail.com"},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    toasty(context, "SUCCESS: " + response.paymentId.validate());
    showDialog(
        builder: (context) {
          return const TicketConfirmDialog();
        },
        context: context);
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => TicketDetail(
              event: widget.event,
            )));
    final EventBaru event = widget.event!;
    final sb = context.watch<SignInProvider>();
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      FirebaseFirestore.instance
          .collection("JoinEvent")
          .doc("user")
          .collection(widget.event?.title ?? '')
          .doc(sb.uid)
          .set({"name": sb.name, "uid": sb.uid, "photoProfile": sb.imageUrl});
    });
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
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
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    toasty(
        context,
        "ERROR: " +
            response.code.toString() +
            " - " +
            response.message.validate());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    toasty(context, "EXTERNAL_WALLET: " + response.walletName.validate());
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInProvider>();
    final EventBaru event = widget.event!;
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

            if (!joinEventData.containsKey(sb.uid)) {
              joinEventData[sb.uid ?? ''] = newData;
            } else {
              // Jika user sudah ada, update field yang sesuai
              joinEventData[sb.uid]["name"] = sb.name;
              joinEventData[sb.uid]["uid"] = sb.uid;
              joinEventData[sb.uid]["photoProfile"] = sb.imageUrl;
            }
            FirebaseFirestore.instance
                .collection('event')
                .doc(widget.event?.id)
                .update({'join': FieldValue.increment(1)});
            transaction.update(eventDocRef, {"joinEvent": joinEventData});
            transaction.update(eventDocRef, {"paymentType": "Transfer Bank"});
          } else {
            FirebaseFirestore.instance
                .collection('event')
                .doc(widget.event?.id)
                .update({'join': FieldValue.increment(1)});
            transaction.update(eventDocRef, {
              "joinEvent": {sb.uid: newData}
            });
            transaction.update(eventDocRef, {"paymentType": "Transfer Bank"});
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getToolBar(
        () {
          Navigator.of(context).pop();
        },
        title: getCustomFont(("Payment").tr(), 24.sp, Colors.black, 1,
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
                    buildPaymentMethod(),
                    getVerSpace(40.h),
                  ],
                )),
            // getPaddingWidget(
            //   EdgeInsets.symmetric(horizontal: 20.h),
            //   getButton(context, accentColor, "Continue", Colors.white, () {
            //     showDialog(
            //         builder: (context) {
            //           return const TicketConfirmDialog();
            //         },
            //         context: context);
            //   }, 18.sp,
            //       weight: FontWeight.w700,
            //       buttonHeight: 60.h,
            //       borderRadius: BorderRadius.circular(22.h)),
            // ),

            getVerSpace(30.h),
          ],
        ),
      ),
    );
  }

  Column buildPaymentMethod() {
    final sb = context.watch<SignInProvider>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          getCustomFont(("Payment Method").tr(), 16.sp, Colors.black, 1,
              fontWeight: FontWeight.w600, txtHeight: 1.5.h),
        ),
        getVerSpace(10.h),
        InkWell(
          onTap: () async {
            await makePayment();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: 1.h),
                borderRadius: BorderRadius.circular(22.h)),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getAssetImage("stripe.png", width: 60.h, height: 50.h),
                    getHorSpace(10.h),
                    getCustomFont(("Stripe").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                  ],
                ),
              ],
            ),
          ),
        ),
        getVerSpace(20.h),
        InkWell(
          onTap: () {
            openCheckout();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: 1.h),
                borderRadius: BorderRadius.circular(22.h)),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getAssetImage("razor.png", width: 50.h, height: 50.h),
                    getHorSpace(10.h),
                    getCustomFont(("Razor Pay").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                  ],
                ),
              ],
            ),
          ),
        ),
        getVerSpace(20.h),

        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId:
                        "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
                    secretKey:
                        "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
                    returnURL: "https://samplesite.com/return",
                    cancelURL: "https://samplesite.com/cancel",
                    transactions: [
                      {
                        "amount": {
                          "total": widget.event?.price.toString(),
                          "currency": "USD",
                          "details": {
                            "subtotal": widget.event?.price.toString(),
                            "shipping": '0',
                            "shipping_discount": 0
                          }
                        },
                        "description": "The payment transaction description.",
                        // "payment_options": {
                        //   "allowed_payment_method":
                        //       "INSTANT_FUNDING_SOURCE"
                        // },
                        "item_list": {
                          "items": [
                            {
                              "name": widget.event?.title.toString(),
                              "quantity": 1,
                              "price": widget.event?.price.toString(),
                              "currency": "USD"
                            }
                          ],

                          // shipping address is not required though
                          "shipping_address": {
                            "recipient_name": sb.name,
                            "line1": "Travis County",
                            "line2": "",
                            "city": "Austin",
                            "country_code": "US",
                            "postal_code": "73301",
                            "phone": "+00000000",
                            "state": "Texas"
                          },
                        }
                      }
                    ],
                    note: ("Contact us for any questions on your order.").tr(),
                    onSuccess: (Map params) async {
                      showDialog(
                          builder: (context) {
                            return const TicketConfirmDialog();
                          },
                          context: context);
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => TicketDetail(
                                event: widget.event,
                              )));
                      final EventBaru event = widget.event!;
                      final sb = context.watch<SignInProvider>();
                      FirebaseFirestore.instance
                          .runTransaction((Transaction transaction) async {
                        FirebaseFirestore.instance
                            .collection("JoinEvent")
                            .doc("user")
                            .collection(widget.event?.title ?? '')
                            .doc(sb.uid)
                            .set({
                          "name": sb.name,
                          "uid": sb.uid,
                          "photoProfile": sb.imageUrl
                        });
                      });

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
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

                          if (existingData != null &&
                              existingData.containsKey("joinEvent")) {
                            final joinEventData = Map<String, dynamic>.from(
                                existingData["joinEvent"]);

                            if (!joinEventData.containsKey(sb.uid)) {
                              joinEventData[sb.uid ?? ''] = newData;
                            } else {
                              // Jika user sudah ada, update field yang sesuai
                              joinEventData[sb.uid]["name"] = sb.name;
                              joinEventData[sb.uid]["uid"] = sb.uid;
                              joinEventData[sb.uid]["photoProfile"] =
                                  sb.imageUrl;
                            }
                            FirebaseFirestore.instance
                                .collection('event')
                                .doc(widget.event?.id)
                                .update({'join': FieldValue.increment(1)});
                            transaction.update(
                                eventDocRef, {"joinEvent": joinEventData});
                            transaction.update(
                                eventDocRef, {"paymentType": "Transfer Bank"});
                          } else {
                            transaction.update(eventDocRef, {
                              "joinEvent": {sb.uid: newData}
                            });
                            transaction.update(
                                eventDocRef, {"paymentType": "Transfer Bank"});
                            FirebaseFirestore.instance
                                .collection('event')
                                .doc(widget.event?.id)
                                .update({'join': FieldValue.increment(1)});
                          }
                        }
                      }).then((value) {
                        print(
                            'Data map dengan array berhasil ditambahkan ke joinEvent.');
                      }).catchError((error) {
                        print('Error: $error');
                      });

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
                      print("onSuccess: $params");
                    },
                    onError: (error) {
                      print("onError: $error");
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
                    }),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.h),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor, width: 1.h),
                borderRadius: BorderRadius.circular(22.h)),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    getAssetImage("paypal.png", width: 40.h, height: 40.h),
                    getHorSpace(10.h),
                    getCustomFont(("Paypal").tr(), 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                  ],
                ),
              ],
            ),
          ),
        ),

//  Center(
//           child: TextButton(
//               onPressed: () => {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (BuildContext context) => UsePaypal(
//                             sandboxMode: true,
//                             clientId:
//                                 "AW1TdvpSGbIM5iP4HJNI5TyTmwpY9Gv9dYw8_8yW5lYIbCqf326vrkrp0ce9TAqjEGMHiV3OqJM_aRT0",
//                             secretKey:
//                                 "EHHtTDjnmTZATYBPiGzZC_AZUfMpMAzj2VZUeqlFUrRJA_C0pQNCxDccB5qoRQSEdcOnnKQhycuOWdP9",
//                             returnURL: "https://samplesite.com/return",
//                             cancelURL: "https://samplesite.com/cancel",
//                             transactions:  [
//                               {
//                                 "amount": {
//                                   "total": widget.event?.price,
//                                   "currency": "USD",
//                                   // "details": {
//                                   //   "subtotal":  widget.event?.price.toString(),
//                                   //   "shipping": '0',
//                                   //   "shipping_discount": 0
//                                   // }
//                                 },
//                                 "description":
//                                     "The payment transaction description.",
//                                 // "payment_options": {
//                                 //   "allowed_payment_method":
//                                 //       "INSTANT_FUNDING_SOURCE"
//                                 // },
//                                 "item_list": {
//                                   "items": [
//                                     {
//                                       "name": widget.event?.title ?? "",
//                                       "quantity": 1,
//                                       "price":  widget.event?.price,
//                                       "currency": "USD"
//                                     }
//                                   ],

//                                   // shipping address is not required though
//                                   "shipping_address": {
//                                     "recipient_name": widget.event?.title,
//                                     "line1": "",
//                                     "line2": "",
//                                     "city": "Austin",
//                                     "country_code": "US",
//                                     "postal_code": "73301",
//                                     "phone": "+00000000",
//                                     "state": "Texas"
//                                   },
//                                 }
//                               }
//                             ],
//                             note: "Contact us for any questions on your order.",
//                             onSuccess: (Map params) async {
//                               print("onSuccess: $params");
//                             },
//                             onError: (error) {
//                               print("onError: $error");
//                             },
//                             onCancel: (params) {
//                               print('cancelled: $params');
//                             }),
//                       ),
//                     )
//                   },
//               child: const Text("Make Payment")),
//         )
      ],
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
        Navigator.of(context).push(
            PageRouteBuilder(pageBuilder: (_, __, ___) => PaymentScreen()));

        // Constant.sendToNext(context, Routes.paymentRoute);
        showDialog(
            builder: (context) {
              return const TicketConfirmDialog();
            },
            context: context);

        final EventBaru event = widget.event!;
        final sb = context.watch<SignInProvider>();

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

              if (!joinEventData.containsKey(sb.uid)) {
                joinEventData[sb.uid ?? ''] = newData;
              } else {
                // Jika user sudah ada, update field yang sesuai
                joinEventData[sb.uid]["name"] = sb.name;
                joinEventData[sb.uid]["uid"] = sb.uid;
                joinEventData[sb.uid]["photoProfile"] = sb.imageUrl;
              }
              FirebaseFirestore.instance
                  .collection('event')
                  .doc(widget.event?.id)
                  .update({'join': FieldValue.increment(1)});
              transaction.update(eventDocRef, {"joinEvent": joinEventData});
              // transaction.update(eventDocRef, {"paymentType": "Transfer Bank"});
            } else {
              FirebaseFirestore.instance
                  .collection('event')
                  .doc(widget.event?.id)
                  .update({'join': FieldValue.increment(1)});
              transaction.update(eventDocRef, {
                "joinEvent": {sb.uid: newData}
              });
              // transaction.update(eventDocRef, {"paymentType": "Transfer Bank"});
            }
          }
        }).then((value) {
          print('Data map dengan array berhasil ditambahkan ke joinEvent.');
        }).catchError((error) {
          print('Error: $error');
        });
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          FirebaseFirestore.instance
              .collection("JoinEvent")
              .doc("user")
              .collection(widget.event?.title ?? '')
              .doc(sb.uid)
              .set({
            "name": sb.name,
            "uid": sb.uid,
            "photoProfile": sb.imageUrl
          });
        });

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

        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => TicketDetail(
                  event: widget.event,
                )));
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
              children: [
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
