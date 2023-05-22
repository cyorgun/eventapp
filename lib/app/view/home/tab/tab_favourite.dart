
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
import '../../bloc/bookmark_bloc.dart';

class TabFavourite extends StatefulWidget {
  const TabFavourite({Key? key}) : super(key: key);

  @override
  State<TabFavourite> createState() => _TabFavouriteState();
}

class _TabFavouriteState extends State<TabFavourite> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildAppBar(),
        Expanded(
          child: Container(
            child: FutureBuilder(
              future: context.watch<BookmarkBloc>().getArticles(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }


                   if (snapshot.hasError) {
                  return Center(child: Text('Error'));
                }
                  if (!snapshot.hasData) {
                   
                        return buildNullListWidget();
                    } else {
                      if (snapshot.data.isEmpty) {
                        return buildNullListWidget();
                      } else {
                     return  ListView.separated(
                      padding: EdgeInsets.all(15),
                      itemCount: snapshot.data.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: 15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // return buildFavouriteList();
                       return Card5(events: snapshot.data[index], heroTag: 'bookmarks$index',);
                      },
                    );

                        //  return  new noItem();
                      }
                    }
                
                // if (snapshot.hasData) {
                //   if (snapshot.data.length == 0)
                //     return buildNullListWidget();
                //     // EmptyPage(
                //     //   icon: Feather.bookmark,
                //     //   message: 'no articles found'.tr(),
                //     //   message1: 'save your favourite articles here'.tr(),
                //     // );
                //   // ignore: curly_braces_in_flow_control_structures
                //   else return ListView.separated(
                //       padding: EdgeInsets.all(15),
                //       itemCount: snapshot.data.length,
                //       separatorBuilder: (context, index) => SizedBox(
                //         height: 15,
                //       ),
                //       itemBuilder: (BuildContext context, int index) {
                //         // return buildFavouriteList();
                //        return Card5(d: snapshot.data[index], heroTag: 'bookmarks$index',);
                //       },
                //     );
                // }

                // if (snapshot.data.isNotEmpty){
                //   return ListView.separated(
                //       padding: EdgeInsets.all(15),
                //       itemCount: snapshot.data.length,
                //       separatorBuilder: (context, index) => SizedBox(
                //         height: 15,
                //       ),
                //       itemBuilder: (BuildContext context, int index) {
                //         // return buildFavouriteList();
                //        return Card5(d: snapshot.data[index], heroTag: 'bookmarks$index',);
                //       },
                //     );
                // } else {
                  
                // return buildNullListWidget();
                // }
              },
            ) ,
          ),
        ),
      ],
    );
    
   }

  AppBar buildAppBar() {
    return getToolBar(() {},
        title: getCustomFont("Favourites", 24.sp, Colors.black, 1,
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
              getCustomFont("Not have item", 20.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(8.h),
              getMultilineCustomFont(
                  "Explore more events and get it to favorites.", 16.sp, Colors.black,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h)
            ],
          ),
        ));
  }
}
