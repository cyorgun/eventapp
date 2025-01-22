
import 'package:event_app/app/view/profile/edit_profile.dart';
import 'package:evente/evente.dart';
import 'package:event_app/app/dialog/delete_dialog.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({Key? key}) : super(key: key);

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
 

  CardController controller = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.white);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: getToolBar(
        () {
          
        Navigator.of(context).pop();
        },
        title: getCustomFont("My Cards", 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
      ),
      body: SafeArea(
        child: Column(
          children: [
            getDivider(
              dividerColor,
              1.h,
            ),
            controller.cardLists.isEmpty
                ? Expanded(
                    flex: 1,
                    child: getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 208.h,
                            width: 208.h,
                            decoration: BoxDecoration(
                                color: lightColor,
                                borderRadius: BorderRadius.circular(187.h)),
                            padding: EdgeInsets.all(47.h),
                            child: getAssetImage("credit-card.png",
                                height: 114.h, width: 114.h),
                          ),
                          getVerSpace(28.h),
                          getCustomFont(
                              "No Cards Yet!", 20.sp, Colors.black, 1,
                              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
                          getVerSpace(8.h),
                          getMultilineCustomFont(
                              "Add your card and lets get started.",
                              16.sp,
                              Colors.black,
                              fontWeight: FontWeight.w500,
                              txtHeight: 1.5.h)
                        ],
                      ),
                    ))
                : Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getVerSpace(20.h),
                        getPaddingWidget(
                          EdgeInsets.symmetric(horizontal: 20.h),
                          getCustomFont("Your Cards", 16.sp, Colors.black, 1,
                              fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                        ),
                        getVerSpace(10.h),
                        Expanded(
                            flex: 1,
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              primary: true,
                              shrinkWrap: true,
                              itemCount: controller.cardLists.length,
                              itemBuilder: (context, index) {
                                ModalCard modalCard =
                                    controller.cardLists[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 20.h),
                                  padding: EdgeInsets.only(
                                      top: 3.h,
                                      right: 18.h,
                                      left: 3.h,
                                      bottom: 3.h),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(22.h),
                                      boxShadow: [
                                        BoxShadow(
                                            color: shadowColor,
                                            offset: const Offset(0, 8),
                                            blurRadius: 27)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 65.h,
                                            width: 65.h,
                                            decoration: BoxDecoration(
                                                color: lightColor,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        22.h)),
                                            padding: EdgeInsets.all(17.h),
                                            child: getAssetImage(
                                                modalCard.image ?? "",
                                                height: 32.h,
                                                width: 32.h),
                                          ),
                                          getHorSpace(10.h),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getCustomFont(
                                                  modalCard.name ?? '',
                                                  16.sp,
                                                  Colors.black,
                                                  1,
                                                  fontWeight: FontWeight.w600,
                                                  txtHeight: 1.5.h),
                                              getCustomFont(
                                                  modalCard.cardNumber ?? '',
                                                  15.sp,
                                                  greyColor,
                                                  1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.46.h)
                                            ],
                                          )
                                        ],
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          dividerTheme: DividerThemeData(
                                            color: dividerColor,
                                          ),
                                        ),
                                        child: PopupMenuButton<int>(
                                          position: PopupMenuPosition.under,
                                          offset: const Offset(0, 0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      22.h)),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 0,
                                              child: getCustomFont("Edit",
                                                  16.sp, Colors.black, 1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h),
                                            ),
                                            PopupMenuDivider(
                                              height: 1.h,
                                            ),
                                            PopupMenuItem(
                                              value: 1,
                                              child: getCustomFont("Delete",
                                                  16.sp, Colors.black, 1,
                                                  fontWeight: FontWeight.w500,
                                                  txtHeight: 1.5.h),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == 0) {
                                                 Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => EditProfile()));
               
                                              // Constant.sendToNext(context,
                                              //     Routes.editCardScreenRoute);
                                            } else if (value == 1) {
                                              showDialog(
                                                      builder: (context) {
                                                        return DeleteDialog(
                                                            index);
                                                      },
                                                      context: context)
                                                  .then((value) {
                                                setState(() {});
                                              });
                                            }
                                          },
                                          child: Container(
                                            child: getSvgImage("more.svg",
                                                height: 24.h, width: 24.h),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ))
                      ],
                    )),
            controller.cardLists.isEmpty
                ? Container()
                : Column(
                    children: [
                      getPaddingWidget(
                        EdgeInsets.symmetric(horizontal: 20.h),
                        getButton(context, accentColor, "Add New Card",
                            Colors.white, () {
                          Constant.sendToNext(
                              context, Routes.editCardScreenRoute);
                        }, 18.sp,
                            weight: FontWeight.w700,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                      ),
                      getVerSpace(30.h)
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
