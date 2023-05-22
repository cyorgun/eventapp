import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:dotted_line/dotted_line.dart';
import 'package:evente/evente.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import 'package:screenshot/screenshot.dart';


class TicketDetail extends StatefulWidget {
  Event? event;
  TicketDetail({Key? key, this.event}) : super(key: key);

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  void backClick() {
    Constant.sendToNext(context, Routes.homeScreenRoute);
  }

  ScreenshotController _screenshotController = ScreenshotController();

  ScreenshotController screenshotController = ScreenshotController();

  final GlobalKey _key = GlobalKey();
  var scr = new GlobalKey();
  GlobalKey _globalKey = GlobalKey();

  Future<void> _takeScreenshot() async {
    final image = await _screenshotController.capture();

    final directory = await getApplicationDocumentsDirectory();
    if (directory == null) return; // tambahkan null check

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';

    final filePath = '${directory.path}/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(image?.toList() ?? []);
  }

  void _CaptureScreenShot() async {
    //get paint bound of your app screen or the widget which is wrapped with RepaintBoundary.
    RenderRepaintBoundary bound =
        _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    if (bound.debugNeedsPaint) {
      Timer(Duration(seconds: 1), () => _CaptureScreenShot());
      return null;
    }
    ui.Image image = await bound.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // this will save image screenshot in gallery
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final resultsave = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 90,
          name: 'screenshot-${DateTime.now()}.png');
      print(resultsave);
    }
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  
  Future<void> buildSingleNotification(String absenDesc) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      priority: Priority.high,
      importance: Importance.max,
      icon: "app_icon",
      channelShowBadge: true,
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
    );

    NotificationDetails notificationDetail =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        // ignore: prefer_interpolation_to_compose_strings
        0,
        'Save Image Ticket',
        absenDesc +
            ' event ' +
           widget.event!.title!,
        notificationDetail);
  }



  @override
  Widget build(BuildContext context) {
    
          DateTime? dateTime = widget.event?.date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);
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
          title: getCustomFont("Ticket", 24.sp, Colors.black, 1,
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
            InkWell(
                onTap: () {
                  _CaptureScreenShot();
                  buildSingleNotification("Ticket has been saved to gallery");
                },
                child: getSvgImage("download.svg", width: 24.h, height: 24.h,color: accentColor)),
            getHorSpace(20.h)
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: [
              getDivider(
                dividerColor,
                1.h,
              ),
              RepaintBoundary(
                key: _key,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20.h),
                      boxShadow: [
                        BoxShadow(
                            color: shadowColor,
                            offset: const Offset(0, 8),
                            blurRadius: 27)
                      ]),
                  padding: EdgeInsets.only(left: 8.h, right: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              height: 203.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.event?.image ?? ''),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 15.0, right: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getCustomFont(
                                              widget.event?.title ?? '',
                                              25.sp,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w800,
                                              txtHeight: 1.46.h),
                                          getVerSpace(4.h),
                                        ],
                                      ),
                                    ),
                                getVerSpace(15.h),
                                Row(
                                  children: [
                                    Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(80),
                                            bottomRight: Radius.circular(80)),
                                      ),
                                    ),
                                    Expanded(
                                      child: DottedLine(
                                        dashColor: borderColor,
                                        dashGapLength: 6.h,
                                        lineThickness: 3.h,
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(80),
                                            bottomLeft: Radius.circular(80)),
                                      ),
                                    ),
                                  ],
                                ),
                             
                                getVerSpace(26.5.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [SizedBox(height: 5.0,),
                                            getCustomFont(
                                                "Category", 15.sp, greyColor, 1,
                                                fontWeight: FontWeight.w500,
                                                txtHeight: 1.46.h),
                                            getCustomFont(
                                                widget.event?.category ?? '',
                                             18.sp,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w600,
                                              txtHeight: 1.5.h),
                                                
                                getVerSpace(16.5.h),
                                            getCustomFont(
                                                "Location", 15.sp, greyColor, 1,
                                                fontWeight: FontWeight.w500,
                                                txtHeight: 1.46.h),
                                            getVerSpace(4.h),
                                            getCustomFont(
                                                widget.event?.location ?? '',
                                                18.sp,
                                                Colors.black,
                                                1,
                                                fontWeight: FontWeight.w600,
                                                txtHeight: 1.5.h),
                                            getVerSpace(30.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getCustomFont(
                                              "Date", 15.sp, greyColor, 1,
                                              fontWeight: FontWeight.w500,
                                              txtHeight: 1.46.h),
                                          getVerSpace(4.h),
                                          getCustomFont(
                                             date ??
                                                  '',
                                           18.sp,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w600,
                                              txtHeight: 1.5.h),
                                              
                                getVerSpace(16.5.h),
                                          getCustomFont(
                                              "Price", 15.sp, greyColor, 1,
                                              fontWeight: FontWeight.w500,
                                              txtHeight: 1.46.h),
                                          getVerSpace(4.h),
                                          getCustomFont(
                                              "\$ ${widget.event?.price}",
                                              18.sp,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w600,
                                              txtHeight: 1.5.h),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                getVerSpace(20.h),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:15.0),
                                      child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget.event?.image ?? ''),
                                          radius: 20.0),
                                    ),
                                    // getAssetImage("image.png", width: 58.h, height: 58.h),
                                    getHorSpace(10.h),

                                  
                                    Padding(
                                      padding: const EdgeInsets.only(left:15.0,right: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                           
                                          getCustomFont(
                                              widget.event?.userName ?? '',
                                              18.sp,
                                              Colors.black,
                                              1,
                                              fontWeight: FontWeight.w600,
                                              txtHeight: 1.5.h),
                                          getVerSpace(1.h),
                                          getCustomFont(
                                              widget.event?.userDesc ?? '',
                                              15.sp,
                                              greyColor,
                                              1,
                                              fontWeight: FontWeight.w500,
                                              txtHeight: 1.46.h)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                getVerSpace(46.h),
                                Row(
                                  children: [
                                    Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(80),
                                            bottomRight: Radius.circular(80)),
                                      ),
                                    ),
                                    Expanded(
                                      child: DottedLine(
                                        dashColor: borderColor,
                                        dashGapLength: 6.h,
                                        lineThickness: 3.h,
                                      ),
                                    ),
                                    Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(80),
                                            bottomLeft: Radius.circular(80)),
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: QrImage(
                                    data: sb.name ?? '${widget.event?.title}',
                                    version: QrVersions.auto,
                                    size: 200.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
