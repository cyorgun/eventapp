import 'package:event_app/app/controller/controller.dart';
import 'package:event_app/app/dialog/ticket_confirm_dialog.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../base/color_data.dart';

import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void backClick() {
    Constant.backToPrev(context);
  }

  PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
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
          title: getCustomFont("Payment", 24.sp, Colors.black, 1,
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
                      buildAddCardButton(context)
                    ],
                  )),
              getPaddingWidget(
                EdgeInsets.symmetric(horizontal: 20.h),
                getButton(context, accentColor, "Continue", Colors.white, () {
                  showDialog(
                      builder: (context) {
                        return const TicketConfirmDialog();
                      },
                      context: context);
                }, 18.sp,
                    weight: FontWeight.w700,
                    buttonHeight: 60.h,
                    borderRadius: BorderRadius.circular(22.h)),
              ),
              getVerSpace(30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddCardButton(BuildContext context) {
    return getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 92.h),
                      getButton(context, '#F4FEFE'.toColor(),
                          "+ Add New Card", accentColor, () {
                        Constant.sendToNext(
                            context, Routes.editCardScreenRoute);
                      }, 18.sp,
                          weight: FontWeight.w700,
                          borderRadius: BorderRadius.circular(22.h),
                          buttonHeight: 60.h,
                          isBorder: true,
                          borderWidth: 1.h,
                          borderColor: accentColor),
                    );
  }

  Column buildPaymentMethod() {
    return Column(
      children: [
        getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          getCustomFont("Payment Method", 16.sp, Colors.black, 1,
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
                    getCustomFont("Paypal", 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                  ],
                ),
                GetX<PaymentController>(
                  builder: (controller) => getSvgImage(
                      controller.select.value == 0
                          ? "checkRadio.svg"
                          : "uncheckRadio.svg",
                      width: 24.h,
                      height: 24.h),
                  init: PaymentController(),
                )
              ],
            ),
          ),
        ),
        getVerSpace(20.h),
        GestureDetector(
          onTap: () {
            controller.onChange(1.obs);
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
                    getAssetImage("mastercard.png", width: 40.h, height: 40.h),
                    getHorSpace(10.h),
                    getCustomFont("Master Card", 16.sp, Colors.black, 1,
                        fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                  ],
                ),
                GetX<PaymentController>(
                  builder: (controller) => getSvgImage(
                      controller.select.value == 1
                          ? "checkRadio.svg"
                          : "uncheckRadio.svg",
                      width: 24.h,
                      height: 24.h),
                  init: PaymentController(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
