import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/app/view/Multiple_Language/Multiple_Language_Screen.dart';
import 'package:event_app/app/view/bloc/bookmark_bloc.dart';
import 'package:event_app/app/view/notification/notification_screen.dart';
import 'package:event_app/app/view/profile/edit_profile.dart';
import 'package:event_app/app/view/setting/privacy_screen.dart';
import 'package:event_app/base/constant.dart';
import 'package:event_app/base/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../base/color_data.dart';
import '../../bloc/sign_in_bloc.dart';
import '../../create_event/create_event_screen.dart';
import '../../intro/welcome.dart';
import '../../profile/change_password.dart';

class GuestTabProfile extends StatefulWidget {
  const GuestTabProfile({Key? key}) : super(key: key);

  @override
  State<GuestTabProfile> createState() => _GuestTabProfileState();
}

class _GuestTabProfileState extends State<GuestTabProfile>
    with AutomaticKeepAliveClientMixin {
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
          title: getCustomFont(("Profile").tr(), 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700),
          centerTitle: true,
          actions: [
            // GestureDetector(
            //     onTap: () {
            //       Constant.sendToNext(context, Routes.settingRoute);
            //     },
            //     child: getSvgImage("setting.svg", height: 24.h, width: 24.h)),
            // getHorSpace(20.h)
          ],
        ),
        Divider(color: dividerColor, thickness: 1.h, height: 1.h),
      if(sb.name==null)  Column(
      children: [
          SizedBox(
            height: 100.h,
          ),
         getAssetImage("guest.png", height: 300.0, width: 400.0),
          getVerSpace(28.h),
          getCustomFont(("Guest User").tr(), 22.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, txtHeight: 1.5.h),
          getVerSpace(8.h),
          getMultilineCustomFont(
              ("Please login to view this screen").tr(), 18.sp, Colors.black,
              fontWeight: FontWeight.w500, txtHeight: 1.5.h),
              Padding(
             padding: const EdgeInsets.only(left:20.0,right: 20.0,top: 15.0),
             child: InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=>WelcomePage()));
              },
               child: Container(
                height: 45.0,
                width: 130,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(50.0))
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
               ),
             ),
           ),
      ],
     ) else  Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              shrinkWrap: true,
              children: [
                buildProfileSection(),
                getVerSpace(5.h),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getVerSpace(20.h),
                      getCustomFont(("Account Settings").tr(), 16.sp, greyColor, 1,
                          fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      getVerSpace(12.h),
                      settingContainer(() {
                           Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => EditProfile()));
               
                        // Constant.sendToNext(context, Routes.editProfileRoute);
                      }, ("Edit Profile").tr(), "edit_profile.svg"),
                      getVerSpace(20.h),
                      settingContainer(() {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => ChangePassword()));
                      }, ("Change Password").tr(), "change_password.svg"),
                      // getVerSpace(30.h),
                      // getCustomFont("Preferences", 16.sp, greyColor, 1,
                      //     fontWeight: FontWeight.w500, txtHeight: 1.5.h),
                      getVerSpace(20.h),
                        settingContainer(() {
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => CreateEventScreen()));
                        // Constant.sendToNext(context, Routes.createEventRoute);
                      }, ("Create Event").tr(), "add.svg"),
                      getVerSpace(20.h),
                      settingContainer(() {
                           Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => NotificationScreen()));
               
                        // Constant.sendToNext(
                        //     context, Routes.notificationScreenRoute);
                      }, ("Notification").tr(), "notification-image.svg"),
                      getVerSpace(20.h),
                      settingContainer(() {
                       Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => MultipleLanguageScreen()));
                        // Constant.sendToNext(context, Routes.changeLanguageRoute
                      }, ("Change Language").tr(), "language.svg"),
                      getVerSpace(20.h),
                      // settingContainer(() {
                      //   Constant.sendToNext(context, Routes.myCardScreenRoute);
                      // }, "My Cards", "card.svg"),
                      // getVerSpace(20.h),
                      settingContainer(() {
                           Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => PrivacyScreen()));
               
                        // Constant.sendToNext(context, Routes.privacyScreenRoute);
                      }, ("Privacy").tr(), "privacy.svg"),
                      getVerSpace(20.h),

                      GestureDetector(
                        onTap: () async {
                          await context
                              .read<SignInBloc>()
                              .userSignout()
                              .then((value) =>
                                  context.read<SignInBloc>().afterUserSignOut())
                              .then((value) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              Routes.welcomePage, (route) => false);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22.h),
                              boxShadow: [
                                BoxShadow(
                                    color: shadowColor,
                                    offset: const Offset(0, 8),
                                    blurRadius: 27)
                              ]),
                          padding: EdgeInsets.only(
                              bottom: 3.h, left: 3.h, top: 3.h, right: 18.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 54.h,
                                    width: 54.h,
                                    decoration: BoxDecoration(
                                        color: dividerColor,
                                        borderRadius:
                                            BorderRadius.circular(22.h)),
                                    padding: EdgeInsets.all(15.h),
                                    child: getSvg("Logout.svg",
                                        width: 24.h,
                                        height: 24.h,
                                        color: accentColor),
                                  ),
                                  getHorSpace(16.h),
                                  getCustomFont(
                                      ("Logout").tr(), 16.sp, Colors.black, 1,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                              getSvgImage("arrow_right.svg",
                                  height: 24.h, width: 24.h)
                            ],
                          ),
                        ),
                      ),
                      getVerSpace(50.h),
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget buildInterestWidget() {
    final b = context.watch<BookmarkBloc>();
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getVerSpace(10.h),
          Row(
            children: [
              getCustomFont(("Interests").tr(), 16.sp, greyColor, 1,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h),
              getHorSpace(3.h),
              // getSvgImage('edit.svg',
              //     color: Colors.black,
              //     height: 24.h,
              //     width: 24.h)
            ],
          ),
          getVerSpace(10.h),
          if (b.list != null && b.list!.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 10.h,
              runSpacing: 10.h,
              children: b.list!
                  .map((i) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 10.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(27.h),
                            border: Border.all(color: accentColor, width: 1.h)),
                        child: getCustomFont(i, 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600),
                      ))
                  .toList(),
            ),
          if (b.list!.isEmpty) Text(("Not Have Interest Item").tr()),
          SizedBox(
            width: 15.0,
          ),
        ],
      ),
    );
  }

  Widget buildAboutWidget() {
    final sb = context.watch<SignInBloc>();
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getCustomFont(("About").tr(), 16.sp, greyColor, 1,
              fontWeight: FontWeight.w500, txtHeight: 1.5.h),
          getVerSpace(10.h),
          Row(
            children: [
              Icon(
                Icons.email,
                size: 25.0,
                color: accentColor,
              ),
              SizedBox(
                width: 15.0,
              ),
              getCustomFont(
                  sb.email??"", 16.sp, Color.fromARGB(255, 32, 32, 32), 1,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h),
            ],
          ),
          getVerSpace(15.h),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 25.0,
                color: accentColor,
              ),
              SizedBox(
                width: 15.0,
              ),
              getCustomFont(
                  sb.phone??("Not have phone number").tr(), 16.sp, Color.fromARGB(255, 32, 32, 32), 1,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h),
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
      ),
    );
  }

  Widget buildProfileSection() {
    final sb = context.watch<SignInBloc>();
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(30.h),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 8),
                  blurRadius: 27)
            ]),
        child: Column(
          children: [
            getVerSpace(21.h),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 120.h,
                  width: 120.h,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100.0)),
                      image: DecorationImage(
                          image: NetworkImage(
                            sb.imageUrl??"",
                          ),
                          fit: BoxFit.cover)),
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
            getVerSpace(5.h),
            getCustomFont(sb.name??"", 22.sp, Colors.black, 1,
                fontWeight: FontWeight.w700, txtHeight: 1.5.h),
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

            buildAboutWidget(),
            buildInterestWidget(),
            getVerSpace(30.h),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
