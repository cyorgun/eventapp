import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/modal/modal_event_baru.dart';
import 'package:event_app/app/view/featured_event/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../dialog/ticket_confirm_dialog.dart';
import '../../provider/sign_in_provider.dart';
import '../../routes/app_routes.dart';
import '../ticket/ticket_detail.dart';

class BuyTicket extends StatefulWidget {
  const BuyTicket({Key? key}) : super(key: key);

  @override
  State<BuyTicket> createState() => _BuyTicketState();
}

class _BuyTicketState extends State<BuyTicket> {
  late EventBaru event;
  late SignInProvider sb;
  int itemCount = 1;

  Map<String, dynamic>? paymentIntent;

  //  var prices = price?? 0
  int? prices;
  int? totalPrice;

  void initVariables() {
    prices = event.price ?? 0;
    totalPrice = prices;
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)?.settings.arguments as EventBaru;
    sb = context.watch<SignInProvider>();
    initVariables();
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
                                border:
                                Border.all(color: borderColor, width: 1.h)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 18.h, vertical: 18.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
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
                                  if (itemCount == 1) {
                                  } else {
                                    itemCount--;
                                    setState(() {
                                      // totalPrice = controller.count.value * widget.price;
                                      var prices = event.price ?? 0;
                                      totalPrice = itemCount * prices;
                                    });
                                    //  controller.countChange(controller.count.obs.value--);
                                  }
                                },
                              ),
                              getCustomFont(
                                  itemCount.toString(), 22.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w700,
                                  txtHeight: 1.5.h),
                              GestureDetector(
                                onTap: () {
                                  itemCount++;
                                  setState(() {
                                    var prices = event.price ?? 0;
                                    totalPrice = itemCount * prices;
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
                      getButton(context, accentColor, ("Payment Deneme").tr(),
                          Colors.white,
                          buttonWidth: MediaQuery.of(context).size.width / 2.5,
                              () async {
                            Navigator.pushNamed(context, Routes.paymentRoute, arguments: {"event": event, "itemCount": itemCount, "totalPrice": totalPrice});
                            showDialog(
                                builder: (context) {
                                  return const TicketConfirmDialog();
                                },
                                context: context);
                            userSaved("deneme");
                            addEvent();

                            Navigator.of(context).pushReplacement(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => TicketDetail(
                                  event: event,
                                )));
                          }, 18.sp,
                          weight: FontWeight.w700,
                          buttonHeight: 60.h,
                          borderRadius: BorderRadius.circular(22.h)),
                      getVerSpace(30.h),
                      if (event.price! > 0)
                        getButton(context, accentColor,
                            ("Checkout Payment").tr(), Colors.white,
                            buttonWidth: MediaQuery.of(context).size.width /
                                2.5, () async {
                              Navigator.pushNamed(context, Routes.paymentRoute, arguments: {"event": event, "itemCount": itemCount, "totalPrice": totalPrice});
                              // await makePayment();
                            }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                      getVerSpace(30.h),
                      if (event.price == 0)
                        getButton(context, accentColor, ("Booking").tr(),
                            Colors.white,
                            buttonWidth: MediaQuery.of(context).size.width /
                                2.5, () async {
                              userSaved("deneme");
                              addEvent();
                              Navigator.pushNamed(context, Routes.paymentRoute, arguments: {"event": event, "itemCount": itemCount, "totalPrice": totalPrice});
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

  void addEvent() async {
    final eventDocRef = FirebaseFirestore.instance.collection("event").doc(event.id);

    try {
      final snapshot = await eventDocRef.get();

      if (!snapshot.exists) return;

      // Mevcut joinEvent listesini al, yoksa boş bir liste oluştur
      List<String> joinEventList = List<String>.from(snapshot.data()?["joinEvent"] ?? []);

      // Eğer kullanıcı zaten listede yoksa ekle ve join değerini artır
      if (!joinEventList.contains(sb.uid)) {
        joinEventList.add(sb.uid!);

        await eventDocRef.update({
          "join": FieldValue.increment(1),
          "joinEvent": joinEventList,
        });

        print('UID başarıyla joinEvent listesine eklendi.');
      } else {
        print('Kullanıcı zaten etkinliğe katılmış.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void userSaved(String paymentMethod) async {
    final userEventsRef = FirebaseFirestore.instance
        .collection("users")
        .doc(sb.uid)
        .collection("joinEvent");

    try {
      // Kullanıcının daha önce bu etkinliğe katılıp katılmadığını kontrol et
      var querySnapshot = await userEventsRef
          .where("eventId", isEqualTo: event.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Eğer kullanıcı bu etkinliğe daha önce katılmamışsa kaydet
        await userEventsRef.add({
          "eventId": event.id,
          "eventTitle": event.title,
          "price": totalPrice,
          "ticketCount": itemCount,
          "paymentMethod": paymentMethod,
          "timestamp": FieldValue.serverTimestamp(),
        });

        print("Etkinliğe başarıyla katılındı.");
      } else {
        print("Kullanıcı zaten bu etkinliğe katılmış.");
      }
    } catch (error) {
      print("Hata oluştu: $error");
    }

    Navigator.pop(context);
  }
}
