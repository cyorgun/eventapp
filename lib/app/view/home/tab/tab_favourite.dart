import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../base/widget_utils.dart';
import '../../../provider/bookmark_provider.dart';
import '../../../widget/card5.dart';

class showCaseFavorite extends StatefulWidget {
  const showCaseFavorite({super.key});

  @override
  State<showCaseFavorite> createState() => _showCaseFavoriteState();
}

class _showCaseFavoriteState extends State<showCaseFavorite> {
  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(builder: (context) => TabFavourite()),
    );
  }
}

class TabFavourite extends StatefulWidget {
  const TabFavourite({Key? key}) : super(key: key);

  @override
  State<TabFavourite> createState() => _TabFavouriteState();
}

class _TabFavouriteState extends State<TabFavourite> {
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcaseVisibilityStatus =
          preferences.getBool("favoriteShowcasesssss");

      if (showcaseVisibilityStatus == null) {
        preferences
            .setBool("favoriteShowcasesssss", false)
            .then((bool success) {
          if (success)
            print("Successfull in writing showshoexase");
          else
            print("some bloody problem occured");
        });

        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context).startShowCase([
          _one,
          _two,
        ]);
      }
    });

    return KeysToBeInherited(
      notification: _one,
      search: _two,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: Container(
              child: FutureBuilder(
                future: context.watch<BookmarkProvider>().getArticles(),
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
                      return ListView.separated(
                        padding: EdgeInsets.all(15),
                        itemCount: snapshot.data.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 15,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          // return buildFavouriteList();
                          return Showcase(
                              key: _one,
                              description:
                                  "Click here to view your favorite item.",
                              child: Card5(
                                events: snapshot.data[index],
                                heroTag: 'bookmarks$index',
                              ));
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
              ),
            ),
          ),
        ],
      ),
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
              getAssetImage("empty.png", height: 300.0, width: 400.0),
              getVerSpace(28.h),
              getCustomFont(("Not have item").tr(), 20.sp, Colors.black, 1,
                  fontWeight: FontWeight.w700, txtHeight: 1.5.h),
              getVerSpace(8.h),
              getMultilineCustomFont(
                  ("Explore more events and get it to favorites.").tr(),
                  16.sp,
                  Colors.black,
                  fontWeight: FontWeight.w500,
                  txtHeight: 1.5.h)
            ],
          ),
        ));
  }
}

class KeysToBeInherited extends InheritedWidget {
  final GlobalKey notification;
  final GlobalKey search;

  KeysToBeInherited({
    required this.notification,
    required this.search,
    required Widget child,
  }) : super(child: child);

  static KeysToBeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<KeysToBeInherited>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
