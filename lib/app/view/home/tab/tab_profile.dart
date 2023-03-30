import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/bloc/bookmark_bloc.dart';
import 'package:event_app/base/constant.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../base/color_data.dart';
import '../../bloc/sign_in_bloc.dart';

class TabProfile extends StatefulWidget {
  const TabProfile({Key? key}) : super(key: key);

  @override
  State<TabProfile> createState() => _TabProfileState();
}

class _TabProfileState extends State<TabProfile> with AutomaticKeepAliveClientMixin{
  var interestList = {"Art", "Music", "Food", "Technology", "Party"};

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final sb = context.watch<SignInBloc>();
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 73.h,
          elevation: 0,
          title: getCustomFont("Profile", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700),
          centerTitle: true,
          actions: [
            GestureDetector(
                onTap: () {
                  Constant.sendToNext(context, Routes.settingRoute);
                },
                child: getSvgImage("setting.svg", height: 24.h, width: 24.h)),
            getHorSpace(20.h)
          ],
        ),
        Divider(color: dividerColor, thickness: 1.h, height: 1.h),
        Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                buildProfileSection(),
                getVerSpace(20.h),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildAboutWidget(),
                      getVerSpace(30.h),
                      buildInterestWidget()
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  Column buildInterestWidget() {
    final b = context.watch<BookmarkBloc>();
    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [ getVerSpace(10.h),
                        Row(
                          children: [
                            getCustomFont("Interests", 20.sp, Colors.black, 1,
                                fontWeight: FontWeight.w600),
                            getHorSpace(3.h),
                            // getSvgImage('edit.svg',
                            //     color: Colors.black,
                            //     height: 24.h,
                            //     width: 24.h)
                          ],
                        ),
                        getVerSpace(20.h),
                       if(b.list!.isNotEmpty)    Wrap(  alignment: WrapAlignment.start,
                            spacing: 10.h,
                            runSpacing: 10.h,
  children: b.list!.map((i) =>  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25.h, vertical: 10.h),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(27.h),
                                          border: Border.all(
                                              color: accentColor,
                                              width: 1.h)),
                                      child: getCustomFont(
                                          i, 15.sp, accentColor, 1,
                                          fontWeight: FontWeight.w600),
                                    )).toList(),
),

if(b.list!.isEmpty) Text("Not Have Interest Item")
                      ],
                    );
  }

  Column buildAboutWidget() {
    final sb = context.watch<SignInBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ getVerSpace(15.h),
        getCustomFont("About", 20.sp, Colors.black, 1,
            fontWeight: FontWeight.w600, txtHeight: 1.5.h),
        getVerSpace(15.h),
        Row(
          children: [
            Icon(Icons.email,size: 25.0,color: accentColor,),
            SizedBox(width: 15.0,),
            
        getCustomFont(sb.email!, 18.sp, Color.fromARGB(255, 32, 32, 32), 1,
            fontWeight: FontWeight.w500, txtHeight: 1.5.h),
          ],
        ),   getVerSpace(15.h),
         Row(
          children: [
            Icon(Icons.phone,size: 25.0,color: accentColor,),
                     SizedBox(width: 15.0,),
            Text(sb.phone!),
          ],
        ),

        // getMultilineCustomFont(
        //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        //     15.sp,
        //     Colors.black,
        //     fontWeight: FontWeight.w500,
        //     txtHeight: 1.46.h,
        //     textAlign: TextAlign.start)
   
      ],
    );
  }

  Container buildProfileSection() {
    final sb = context.watch<SignInBloc>();
    return Container(
      color: accentColor.withOpacity(0.05),
      width: double.infinity,
      child: Column(
        children: [
          getVerSpace(31.h),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 180.h,
                width:  180.h,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                  image: DecorationImage(image: NetworkImage(sb.imageUrl!,),fit: BoxFit.cover)
                ),
              ),
              // Positioned(
              //     child: Container(
              //   height: 30.h,
              //   width: 30.h,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20.h),
              //       color: Colors.white,
              //       boxShadow: [
              //         BoxShadow(
              //             color: shadowColor,
              //             offset: const Offset(0, 8),
              //             blurRadius: 27)
              //       ]),
              //   padding: EdgeInsets.all(5.h),
              //   child: getSvgImage("edit.svg", width: 20.h, height: 20.h),
              // ))
            ],
          ),
          getVerSpace(15.h),
          getCustomFont(sb.name!, 22.sp, Colors.black, 1,
              fontWeight: FontWeight.w600, txtHeight: 1.5.h),
          getVerSpace(20.h),
          // getPaddingWidget(
          //   EdgeInsets.symmetric(horizontal: 20.h),
          //   Row(
          //     children: [
          //       Expanded(
          //           child: Container(
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(22.h),
          //             color: Colors.white,
          //             boxShadow: [
          //               BoxShadow(
          //                   color: shadowColor,
          //                   offset: const Offset(0, 8),
          //                   blurRadius: 27),
          //             ]),
          //         child: Column(
          //           children: [
          //             getVerSpace(20.h),
          //             getCustomFont("2250", 22.sp, accentColor, 1,
          //                 fontWeight: FontWeight.w700, txtHeight: 1.5.h),
          //             getVerSpace(2.h),
          //             getCustomFont("Followers", 15.sp, Colors.black, 1,
          //                 fontWeight: FontWeight.w500, txtHeight: 1.46.h),
          //             getVerSpace(20.h),
          //           ],
          //         ),
          //       )),
          //       getHorSpace(20.h),
          //       Expanded(
          //           child: Container(
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(22.h),
          //             color: Colors.white,
          //             boxShadow: [
          //               BoxShadow(
          //                   color: shadowColor,
          //                   offset: const Offset(0, 8),
          //                   blurRadius: 27),
          //             ]),
          //         child: Column(
          //           children: [
          //             getVerSpace(20.h),
          //             getCustomFont("466", 22.sp, accentColor, 1,
          //                 fontWeight: FontWeight.w700, txtHeight: 1.5.h),
          //             getVerSpace(2.h),
          //             getCustomFont("Following", 15.sp, Colors.black, 1,
          //                 fontWeight: FontWeight.w500, txtHeight: 1.46.h),
          //             getVerSpace(20.h),
          //           ],
          //         ),
          //       )),
          //       getHorSpace(20.h),
          //       Expanded(
          //           child: Container(
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(22.h),
          //             color: Colors.white,
          //             boxShadow: [
          //               BoxShadow(
          //                   color: shadowColor,
          //                   offset: const Offset(0, 8),
          //                   blurRadius: 27),
          //             ]),
          //         child: Column(
          //           children: [
          //             getVerSpace(20.h),
          //             getCustomFont("5", 22.sp, accentColor, 1,
          //                 fontWeight: FontWeight.w700, txtHeight: 1.5.h),
          //             getVerSpace(2.h),
          //             getCustomFont("Events", 15.sp, Colors.black, 1,
          //                 fontWeight: FontWeight.w500, txtHeight: 1.46.h),
          //             getVerSpace(20.h),
          //           ],
          //         ),
          //       ))
          //     ],
          //   ),
       
          // ),
          getVerSpace(30.h),
        ],
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}
