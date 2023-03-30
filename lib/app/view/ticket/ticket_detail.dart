import 'package:dotted_line/dotted_line.dart';
import 'package:event_app/app/modal/modal_event.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';

class TicketDetail extends StatefulWidget {
   Event? event;
   TicketDetail({Key? key,this.event}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  void backClick() {
    Constant.sendToNext(context, Routes.homeScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 73.h,
          title: getCustomFont("My Ticket", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700),
          centerTitle: true,
          leading: getPaddingWidget(
              EdgeInsets.only(top: 26.h, bottom: 23.h),
              GestureDetector(
                  onTap: () {
                    backClick();
                  },
                  child: getSvgImage("arrow_back.svg",
                      height: 24.h, width: 24.h))),
          actions: [
            getSvgImage("download.svg", width: 24.h, height: 24.h),
            getHorSpace(20.h)
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              getDivider(
                dividerColor,
                1.h,
              ),
              getVerSpace(20.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.h),
                    boxShadow: [
                      BoxShadow(
                          color: shadowColor,
                          offset: const Offset(0, 8),
                          blurRadius: 27)
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  children: [
                    getVerSpace(16.h),
                    Container(
                      height: 183.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22.h),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.event?.image??''),
                              fit: BoxFit.fill)),
                    ),
                    getVerSpace(15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            getCustomFont( widget.event?.title??'', 15.sp, greyColor, 1,
                                fontWeight: FontWeight.w500, txtHeight: 1.46.h),
                            getVerSpace(4.h),
                            getCustomFont(
                                 widget.event?.category??'', 18.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600, txtHeight: 1.5.h)
                          ],
                        ),
                        QrImage(
                                  data: sb.name??'${widget.event?.title}',
                                  version: QrVersions.auto,
                                  size: 60.0,
                                ),
                       ],
                    ),
                    getVerSpace(16.5.h),
                    DottedLine(
                      dashColor: borderColor,
                      dashGapLength: 3.h,
                      lineThickness: 1.h,
                    ),
                    getVerSpace(16.5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCustomFont("Date", 15.sp, greyColor, 1,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.46.h),
                              getVerSpace(4.h),
                              getCustomFont( widget.event?.date??'', 18.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600,
                                  txtHeight: 1.5.h),
                              getVerSpace(30.h),
                              getCustomFont("Location", 15.sp, greyColor, 1,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.46.h),
                              getVerSpace(4.h),
                              getCustomFont(
                                   widget.event?.location??'', 18.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600,
                                  txtHeight: 1.5.h),
                              getVerSpace(30.h),
                              getCustomFont("Sponser", 15.sp, greyColor, 1,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.46.h),
                              getVerSpace(4.h),
                              Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage( widget.event?.image?? ''),
                  radius: 20.0),
              // getAssetImage("image.png", width: 58.h, height: 58.h),
              getHorSpace(10.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getCustomFont( widget.event?.userName ?? '', 18.sp, Colors.black, 1,
                      fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                  getVerSpace(1.h),
                  getCustomFont( widget.event?.userDesc?? '', 15.sp, greyColor, 1,
                      fontWeight: FontWeight.w500, txtHeight: 1.46.h)
                ],
              )
            ],
          ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // getCustomFont("Time", 15.sp, greyColor, 1,
                              //     fontWeight: FontWeight.w500,
                              //     txtHeight: 1.46.h),
                              // getVerSpace(4.h),
                              // getCustomFont("03:00 PM", 18.sp, Colors.black, 1,
                              //     fontWeight: FontWeight.w600,
                              //     txtHeight: 1.5.h),
                              // getVerSpace(30.h),
                              // getCustomFont("Seat", 15.sp, greyColor, 1,
                              //     fontWeight: FontWeight.w500,
                              //     txtHeight: 1.46.h),
                              // getVerSpace(4.h),
                              // getCustomFont("966", 18.sp, Colors.black, 1,
                              //     fontWeight: FontWeight.w600,
                              //     txtHeight: 1.5.h),
                              // getVerSpace(30.h),
                              getCustomFont("Price", 15.sp, greyColor, 1,
                                  fontWeight: FontWeight.w500,
                                  txtHeight: 1.46.h),
                              getVerSpace(4.h),
                              getCustomFont("\$ ${widget.event?.price}", 18.sp, Colors.black, 1,
                                  fontWeight: FontWeight.w600,
                                  txtHeight: 1.5.h),
                            ],
                          ),
                        )
                      ],
                    ),
                    getVerSpace(16.h),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
