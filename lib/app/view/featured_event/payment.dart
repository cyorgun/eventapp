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
  const PaymentScreen();

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late int? totalPrice;
  late EventBaru event;
  late int? itemCount;
  late SignInProvider sb;

  @override
  Widget build(BuildContext context) {
    sb = context.watch<SignInProvider>();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    totalPrice =  args?["totalPrice"];
    itemCount = args?["itemCount"];
    event = args?["event"];

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
                    //buildPaymentMethod(),
                    getVerSpace(40.h),
                  ],
                )),
            getVerSpace(30.h),
          ],
        ),
      ),
    );
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    toasty(context, "SUCCESS: " + response.paymentId.validate());
    showDialog(
        builder: (context) {
          return const TicketConfirmDialog();},
        context: context);
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) => TicketDetail(
          event: event,
        )));
    addEvent();
    userSaved("deneme"); //TODO
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
    var time = DateTime.now();
    String timestamp = DateFormat('yyyyMMddHHmmss').format(time);

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
          "price": totalPrice,
          "ticketCount": itemCount,
          "paymentMethod": paymentMethod,
          "timestamp": timestamp,
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
