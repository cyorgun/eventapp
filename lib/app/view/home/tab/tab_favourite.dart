import 'package:event_app/app/data/data_file.dart';
import 'package:event_app/base/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../base/color_data.dart';
import '../../../../base/widget_utils.dart';
import '../../../dialog/loading_cards.dart';
import '../../../modal/modal_favourite.dart';
import '../../../widget/card4.dart';
import '../../../widget/card5.dart';
import '../../bloc/bookmark_bloc.dart';

class TabFavourite extends StatefulWidget {
  const TabFavourite({Key? key}) : super(key: key);

  @override
  State<TabFavourite> createState() => _TabFavouriteState();
}

class _TabFavouriteState extends State<TabFavourite> {
  List<ModalFavourite> favouriteLists = DataFile.favouriteList;

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
                       return Card5(d: snapshot.data[index], heroTag: 'bookmarks$index',);
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

  Expanded buildFavouriteList() {
    return Expanded(
      flex: 1,
      child: GridView.builder(
          padding:
              EdgeInsets.only(left: 20.h, right: 20.h, bottom: 40.h, top: 20.h),
          itemCount: favouriteLists.length,
          primary: true,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            ModalFavourite modalFavourite = favouriteLists[index];
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.h),
                  boxShadow: [
                    BoxShadow(
                        color: shadowColor,
                        offset: const Offset(0, 8),
                        blurRadius: 27)
                  ]),
              padding: EdgeInsets.only(top: 10.h, right: 10.h, left: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 137.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22.h),
                        image: DecorationImage(
                            image: AssetImage(Constant.assetImagePath +
                                modalFavourite.image.toString()),
                            fit: BoxFit.fill)),
                    padding:
                        EdgeInsets.only(top: 10.h, left: 10.h, right: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: '#B2000000'.toColor(),
                                  borderRadius: BorderRadius.circular(12.h)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 10.h),
                              alignment: Alignment.center,
                              child: getCustomFont(
                                modalFavourite.date ?? '',
                                13.sp,
                                Colors.white,
                                1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        getAssetImage("favourite_select.png",
                            width: 24.h, height: 24.h)
                      ],
                    ),
                  ),
                  getVerSpace(12.h),
                  getCustomFont(
                      modalFavourite.name ?? '', 18.sp, Colors.black, 1,
                      fontWeight: FontWeight.w600, txtHeight: 1.5.h),
                  getVerSpace(2.h),
                  Row(
                    children: [
                      getSvgImage("location.svg",
                          height: 20.h, width: 20.h, color: greyColor),
                      getHorSpace(5.h),
                      getCustomFont(
                          modalFavourite.location ?? "", 15.sp, greyColor, 1,
                          fontWeight: FontWeight.w500, txtHeight: 1.5.h)
                    ],
                  ),
                  getVerSpace(10.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.h),
                    decoration: BoxDecoration(
                        color: lightAccent,
                        borderRadius: BorderRadius.circular(12.h)),
                    child: getCustomFont(
                        modalFavourite.price ?? '', 15.sp, accentColor, 1,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.h,
              mainAxisExtent: 266.h)),
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
              Container(
                height: 208.h,
                width: 208.h,
                padding: EdgeInsets.symmetric(horizontal: 52.h, vertical: 47.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(187.h),
                    color: lightColor),
                child:
                    getAssetImage("valentine.png", height: 114.h, width: 114.h),
              ),
              getVerSpace(28.h),
              getCustomFont("No Favourites Yet!", 20.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(8.h),
              getMultilineCustomFont(
                  "Explore more and shortlist events.", 16.sp, Colors.black,
                  fontWeight: FontWeight.w500, txtHeight: 1.5.h)
            ],
          ),
        ));
  }
}
