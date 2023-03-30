
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../modal/notification_model.dart';


class CustomNotificationCard extends StatelessWidget {
   CustomNotificationCard({Key? key, required this.notificationModel, required this.timeAgo, required this.date}) : super(key: key);

  final NotificationModel notificationModel;
  final String timeAgo,date;
   DateTime now = DateTime.now();
DateFormat format = DateFormat("dd.MM.yyyy");
//  String formattedDate ='${DateFormat('MMMM').format(DateTime.parse("9 Jan 2022"))} ${DateTime.now().year}';

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12.withOpacity(0.05),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0,left: 15.0),
                  child:  getCustomFont(
                                                        date.toString(),
                                                        18.sp,
                                                        Colors.black,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        txtHeight: 1.5.h),
                  
),
              ),
              Padding(
                padding: const EdgeInsets.only(top:23.0,bottom: 10.0,left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                                                height: 60.h,
                                                width: 60.h,
                                                decoration: BoxDecoration(
                                                    color: Color(0XFF46BCC3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.h)),
                                                padding: EdgeInsets.all(18.h),
                                                child: getSvgImage(
                                                    "notification-image.svg",
                                                    color: Colors.white,
                                                    width: 24.h,
                                                    height: 24.h),
                                              ),
                                             
                                              // getHorSpace(12.h),
                    Padding(
                      padding: const EdgeInsets.only(left:10.0,top: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: 
                        [Container(
                          width:MediaQuery.of(context).size.width-170,
                          child:  getCustomFont(
                                                       notificationModel.title!,
                                                        19.sp,
                                                        Colors.black,
                                                        1,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        txtHeight: 1.5.h),
                       
                        ),
                        SizedBox(height: 1.0,),
                         Container(
                          width:MediaQuery.of(context).size.width-170,
                           child: Text(notificationModel.body!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                     style: TextStyle(
                      fontFamily: Constant.fontsFamily,
                               fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5),fontSize: 14),
                       ),
                         ),
                
                      ]),
                    ),
                    // IconButton(
                    //     constraints: BoxConstraints(minHeight: 40),
                    //     alignment: Alignment.centerRight,
                    //     padding: EdgeInsets.all(0),
                    //     icon: Icon(
                    //       Icons.close,
                    //       size: 20,
                    //     ),
                    //     onPressed: () =>null),
                        
                        //  NotificationService().deleteNotificationData(notificationModel.timestamp))
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right:15.0,top: 10),
                      child: Text(
                        timeAgo,
                      style: TextStyle(
                      fontFamily: Constant.fontsFamily,
                               fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5),fontSize: 14),
                         ),
                    ),
                  ],
                ),
              ),



        //        SafeArea(
        //   child: Column(
        //     children: [
        //       getDivider(
        //         dividerColor,
        //         1.h,
        //       ),
        //       notificationLists.isEmpty
        //           ? Expanded(
        //               flex: 1,
        //               child: getPaddingWidget(
        //                 EdgeInsets.symmetric(horizontal: 20.h),
        //                 Column(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Container(
        //                       height: 208.h,
        //                       width: 208.h,
        //                       decoration: BoxDecoration(
        //                           color: lightColor,
        //                           borderRadius: BorderRadius.circular(187.h)),
        //                       padding: EdgeInsets.all(47.h),
        //                       child: getAssetImage("bell.png",
        //                           height: 114.h, width: 114.h),
        //                     ),
        //                     getVerSpace(28.h),
        //                     getCustomFont(
        //                         "No Notifications Yet!", 20.sp, Colors.black, 1,
        //                         fontWeight: FontWeight.w700, txtHeight: 1.5.h),
        //                     getVerSpace(8.h),
        //                     getMultilineCustomFont(
        //                         "We’ll notify you when something arrives.",
        //                         16.sp,
        //                         Colors.black,
        //                         fontWeight: FontWeight.w500,
        //                         txtHeight: 1.5.h)
        //                   ],
        //                 ),
        //               ))
        //           : Expanded(
        //               child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 getVerSpace(20.h),
        //                 getPaddingWidget(
        //                   EdgeInsets.symmetric(horizontal: 20.h),
        //                   getCustomFont("Today", 16.sp, greyColor, 1,
        //                       fontWeight: FontWeight.w500, txtHeight: 1.5.h),
        //                 ),
        //                 getVerSpace(10.h),
        //                 Expanded(
        //                   flex: 1,
        //                   child: ListView.separated(
        //                       itemCount: notificationLists.length,
        //                       separatorBuilder: (context, index) {
        //                         return getPaddingWidget(
        //                             EdgeInsets.symmetric(horizontal: 20.h),
        //                             Container(
        //                               height: 1.h,
        //                               color: dividerColor,
        //                               width: double.infinity,
        //                             ));
        //                       },
        //                       itemBuilder: (context, index) {
        //                         ModalNotification modalNotification =
        //                             notificationLists[index];
        //                         return Container(
        //                           color: index == 0 || index == 1
        //                               ? lightColor
        //                               : Colors.white,
        //                           child: getPaddingWidget(
        //                             EdgeInsets.symmetric(
        //                                 horizontal: 20.h, vertical: 20.h),
        //                             Row(
        //                               children: [
        //                                 Expanded(
        //                                   flex: 1,
        //                                   child: Row(
        //                                     children: [
        //                                       Container(
        //                                         height: 60.h,
        //                                         width: 60.h,
        //                                         decoration: BoxDecoration(
        //                                             color: modalNotification
        //                                                 .color!
        //                                                 .toColor(),
        //                                             borderRadius:
        //                                                 BorderRadius.circular(
        //                                                     22.h)),
        //                                         padding: EdgeInsets.all(18.h),
        //                                         child: getSvgImage(
        //                                             "notification-image.svg",
        //                                             color: Colors.white,
        //                                             width: 24.h,
        //                                             height: 24.h),
        //                                       ),
        //                                       getHorSpace(12.h),
        //                                       Expanded(
        //                                         flex: 1,
        //                                         child: Column(
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment.start,
        //                                           mainAxisAlignment:
        //                                               MainAxisAlignment.center,
        //                                           children: [
        //                                             getCustomFont(
        //                                                 modalNotification
        //                                                         .name ??
        //                                                     " ",
        //                                                 18.sp,
        //                                                 Colors.black,
        //                                                 1,
        //                                                 fontWeight:
        //                                                     FontWeight.w700,
        //                                                 txtHeight: 1.5.h),
        //                                             getVerSpace(4.h),
        //                                             getCustomFont(
        //                                                 "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        //                                                 16.sp,
        //                                                 Colors.black,
        //                                                 1,
        //                                                 fontWeight:
        //                                                     FontWeight.w500,
        //                                                 txtHeight: 1.5.h)
        //                                           ],
        //                                         ),
        //                                       )
        //                                     ],
        //                                   ),
        //                                 ),
        //                                 getCustomFont(
        //                                     modalNotification.time ?? '',
        //                                     15.sp,
        //                                     "#7D7883".toColor(),
        //                                     1,
        //                                     fontWeight: FontWeight.w400,
        //                                     txtHeight: 1.46.h)
        //                               ],
        //                             ),
        //                           ),
        //                         );
        //                       }),
        //                 )
        //               ],
        //             ))
        //     ],
        //   ),
        // ),


        
            ],
          ),
        ),
        onTap: () {
        //  navigateToNotificationDetailsScreen(context, notificationModel);
        });
  }
}
