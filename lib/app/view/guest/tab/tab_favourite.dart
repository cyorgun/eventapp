
import 'package:event_app/base/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../../dialog/loading_cards.dart';
import 'package:evente/evente.dart';
import '../../../widget/card4.dart';
import '../../../widget/card5.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../bloc/bookmark_bloc.dart';
import '../../intro/welcome.dart';

class GuestTabFavourite extends StatefulWidget {
  const GuestTabFavourite({Key? key}) : super(key: key);

  @override
  State<GuestTabFavourite> createState() => _GuestTabFavouriteState();
}

class _GuestTabFavouriteState extends State<GuestTabFavourite> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAppBar(),
     getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    )
      ],
    );
    
   }


  AppBar buildAppBar() {
    return getToolBar(() {},
        title: getCustomFont(("Favourites").tr(), 24.sp, Colors.black, 1,
            fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        leading: false);
  }

  Expanded buildNullListWidget() {
    return Expanded(
        flex: 1,
        child: getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               getAssetImage("empty.png", height: 300.0,width: 400.0 ),
              getVerSpace(28.h),
              getCustomFont(("Not have item").tr(), 20.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(8.h),
              getMultilineCustomFont(
                  ("Explore more events and get it to favorites.").tr(), 16.sp, Colors.black,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h)
            ],
          ),
        ));
  }
}
