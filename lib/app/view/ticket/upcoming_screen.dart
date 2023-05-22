import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/ticket/ticket_detail.dart';
import 'package:event_app/base/color_data.dart';
import 'package:event_app/base/constant.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math' as math;

import '../bloc/sign_in_bloc.dart';

class UpComingScreen extends StatefulWidget {
  const UpComingScreen({Key? key}) : super(key: key);

  @override
  State<UpComingScreen> createState() => _UpComingScreenState();
}

class _UpComingScreenState extends State<UpComingScreen> {

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();

    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  right: 20.h, left: 20.h, top: 0.h, bottom: 50.h),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(sb.uid)
                    .collection('Join Event')
                    .snapshots(),
                builder: (
                  BuildContext ctx,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return noItem();
                  } else {
                    if (snapshot.data?.docs.length == 0) {
                      return noItem();
                    } else {
                      return itemData(list: snapshot.data?.docs);
                      // return new dataFirestore(list: snapshot.data.docs);
                    }
                    //  return  new noItem();
                  }
                },
              )),
          SizedBox(
            height: 40.0,
          )
        ],
      ),
    );

    // ListView.separated(
    //     primary: true,
    //     shrinkWrap: true,
    //     itemCount: upComingLists.length,
    //     separatorBuilder: (context, index) {
    //       return getVerSpace(20.h);
    //     },
    //     padding: EdgeInsets.only(
    //         right: 20.h, left: 20.h, top: 30.h, bottom: 50.h),
    //     itemBuilder: (context, index) {
    //       ModalUpComing modalUpComing = upComingLists[index];
    //       return Transform.rotate(
    //         angle: math.pi,
    //         child: GestureDetector(
    //           onTap: () {
    //             Constant.sendToNext(context, Routes.ticketDetailRoute);
    //           },
    //           child: CustomPaint(
    //             painter: RPSCustomPainter(right: 123.h, holeRadius: 16.h),
    //             child: Transform.rotate(
    //               angle: math.pi,
    //               child: Container(
    //                 padding: EdgeInsets.only(
    //                     top: 15.h, bottom: 15.h, left: 17.h, right: 16.h),
    //                 width: double.infinity,
    //                 child: Row(
    //                   children: [
    //                     SizedBox(
    //                       width: 115.h,
    //                       child: Row(
    //                         mainAxisAlignment:
    //                             MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           getAssetImage("code.png",
    //                               width: 100.h, height: 100.h),
    //                           CustomPaint(
    //                               size: Size(2.h, 105.h),
    //                               painter: DashedLineVerticalPainter())
    //                         ],
    //                       ),
    //                     ),
    //                     getHorSpace(31.h),
    //                     Expanded(
    //                       flex: 1,
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           getCustomFont(modalUpComing.name ?? "", 18.sp,
    //                               Colors.black, 1,
    //                               fontWeight: FontWeight.w600,
    //                               txtHeight: 1.5.h),
    //                           getVerSpace(6.h),
    //                           getCustomFont(modalUpComing.date ?? "", 15.sp,
    //                               greyColor, 1,
    //                               fontWeight: FontWeight.w500,
    //                               txtHeight: 1.46.h),
    //                           getVerSpace(9.h),
    //                           Row(
    //                             crossAxisAlignment: CrossAxisAlignment.end,
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               getCustomFont(
    //                                   "Ticket : 1", 15.sp, Colors.black, 1,
    //                                   fontWeight: FontWeight.w500,
    //                                   txtHeight: 1.46.h),
    //                               Container(
    //                                 decoration: BoxDecoration(
    //                                   color: lightAccent,
    //                                   borderRadius:
    //                                       BorderRadius.circular(12.h),
    //                                 ),
    //                                 padding: EdgeInsets.symmetric(
    //                                     horizontal: 12.h, vertical: 6.h),
    //                                 child: getCustomFont(
    //                                     modalUpComing.price ?? '',
    //                                     15.sp,
    //                                     accentColor,
    //                                     1,
    //                                     fontWeight: FontWeight.w600,
    //                                     txtHeight: 1.46.h),
    //                               )
    //                             ],
    //                           )
    //                         ],
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
  }

  Widget noItem() {
    return getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100.h,
          ),
          getAssetImage("ticket.png", height: 300.0, width: 400.0),
          getVerSpace(28.h),
          getCustomFont("No have Ticket", 20.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
          getVerSpace(8.h),
          getMultilineCustomFont(
              "Explore more event and join get the ticket", 16.sp, Colors.black,
              fontWeight: FontWeight.w500, txtHeight: 1.5.h)
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  RPSCustomPainter({required this.right, required this.holeRadius});

  final double right;
  final double holeRadius;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_3 = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.h;

    final path2 = Path()
      ..moveTo(size.width - right - holeRadius, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: false,
        radius: Radius.circular(1.h),
      )
      ..quadraticBezierTo(size.width * 0.86, 0, size.width * 0.94, 0)
      ..quadraticBezierTo(
          size.width * 1.00, size.height * 0.00, size.width, size.height * 0.13)
      ..lineTo(size.width, size.height * 0.88)
      ..quadraticBezierTo(
          size.width * 1.00, size.height * 1.00, size.width * 0.94, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right - holeRadius, size.height),
        clockwise: false,
        radius: Radius.circular(1.h),
      )
      ..quadraticBezierTo(size.width * 0.200000, size.height,
          size.width * 0.0625000, size.height)
      ..quadraticBezierTo(size.width * 0.0013375, size.height * 0.9976500, 0,
          size.height * 0.8750000)
      ..quadraticBezierTo(
          0, size.height * 0.1875000, 0, size.height * 0.1250000)
      ..quadraticBezierTo(size.width * 0.0031875, size.height * 0.0027500,
          size.width * 0.0625000, 0);

    path2.close();

    canvas.drawPath(path2, paint_3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5.h, dashSpace = 4.h, startY = 0;
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 2.h;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class itemData extends StatelessWidget {
  final List<DocumentSnapshot>? list;
  const itemData({this.list});

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final events = list?.map((e) {
            return Event.fromFirestore(e);
          }).toList();

          DateTime? dateTime = events![i].date?.toDate();
          String date = DateFormat('d MMMM, yyyy').format(dateTime!);

          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Transform.rotate(
              angle: math.pi,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => TicketDetail(
                            event: events?[i],
                          )));
                },
                child: CustomPaint(
                  painter: RPSCustomPainter(right: 123.h, holeRadius: 16.h),
                  child: Transform.rotate(
                    angle: math.pi,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 15.h, bottom: 15.h, left: 17.h, right: 16.h),
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 115.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                QrImage(
                                  data: sb.name ?? '${events?[i].title!}',
                                  version: QrVersions.auto,
                                  size: 90.0,
                                ),
                                CustomPaint(
                                    size: Size(2.h, 105.h),
                                    painter: DashedLineVerticalPainter())
                              ],
                            ),
                          ),
                          getHorSpace(31.h),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getCustomFont(events?[i].title ?? "", 18.sp,
                                    Colors.black, 1,
                                    fontWeight: FontWeight.w600,
                                    txtHeight: 1.5.h),
                                getVerSpace(6.h),
                                getCustomFont(
                                    date.toString() ?? "", 15.sp, greyColor, 1,
                                    fontWeight: FontWeight.w500,
                                    txtHeight: 1.46.h),
                                getVerSpace(9.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getCustomFont(
                                        "Ticket : ${events?[i].ticket.toString()}" ??
                                            '',
                                        15.sp,
                                        Colors.black,
                                        1,
                                        fontWeight: FontWeight.w500,
                                        txtHeight: 1.46.h),
                                if(events[i].price!>0)      Container(
                                      decoration: BoxDecoration(
                                        color: lightAccent,
                                        borderRadius:
                                            BorderRadius.circular(12.h),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.h, vertical: 6.h),
                                      child: getCustomFont(
                                          "\$ ${events?[i].price.toString()}" ??
                                              '',
                                          15.sp,
                                          accentColor,
                                          1,
                                          fontWeight: FontWeight.w600,
                                          txtHeight: 1.46.h),
                                    ),
                                     if(events[i].price==0)      Container(
                                      decoration: BoxDecoration(
                                        color: lightAccent,
                                        borderRadius:
                                            BorderRadius.circular(12.h),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.h, vertical: 6.h),
                                      child: getCustomFont(
                                          "Free",
                                          15.sp,
                                          accentColor,
                                          1,
                                          fontWeight: FontWeight.w600,
                                          txtHeight: 1.46.h),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
