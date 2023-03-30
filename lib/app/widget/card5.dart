
import 'package:event_app/app/modal/modal_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/constant.dart';
import '../../base/widget_utils.dart';
import '../view/featured_event/featured_event_detail2.dart';

class Card5 extends StatelessWidget {
  final Event d;
  final String heroTag;
  const Card5({Key? key, required this.d, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            boxShadow: [
            BoxShadow(
                        color: shadowColor,
                        offset: const Offset(0, 8),
                        blurRadius: 27) ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))
                      ),
                      child: Hero(
                        tag: heroTag,
                        child: Image.network( d.image??'',fit: BoxFit.cover,),)
                      ),

                      // VideoIcon(contentType: d.contentType, iconSize: 40,)
                    ],
              ),
              Container(
                  padding: EdgeInsets.only(left: 15, right: 15,top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          d.title!,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                            fontFamily: Constant.fontsFamily,
              fontSize: 16,
              fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 5,),

                            getVerSpace(5.h),

                      Row(
                        children: <Widget>[
                         
                      getSvgImage("location.svg",
                          height: 20.h, width: 20.h, color: greyColor),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            d.location!,
                            style: TextStyle(
                              
                            fontFamily: Constant.fontsFamily,
                              color:Colors.black54, fontSize: 13),
                          ),
                         
              
                        ],
                      ),
                            getVerSpace(5.h),
                          Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                    decoration: BoxDecoration(
                        color: lightAccent,
                        borderRadius: BorderRadius.circular(12.h)),
                    child: Row(
                      children: 
                            [
                                getCustomFont(
                           "\$ ", 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600),
                              getCustomFont(
                            d.price.toString(), 15.sp, accentColor, 1,
                            fontWeight: FontWeight.w600),
                          ],
                    ),
                  )
                    ],
                  ),
                ),
                Spacer(),
                 getAssetImage("favourite_select.png",
                            width: 35.h, height: 35.h)
            ],
          ),
        ),
      
       onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> new FeaturedEvent2Detail(event: d,))),
    );
  }
}
