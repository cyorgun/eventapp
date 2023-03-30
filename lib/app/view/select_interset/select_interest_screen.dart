import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/data/data_file.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:event_app/base/pref_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../base/color_data.dart';
import '../../../base/constant.dart';
import '../../../base/widget_utils.dart';
import '../../modal/modal_select_interest.dart';
import '../bloc/bookmark_bloc.dart';
import '../bloc/sign_in_bloc.dart';

class SelectInterestScreen extends StatefulWidget {
  const SelectInterestScreen({Key? key}) : super(key: key);

  @override
  State<SelectInterestScreen> createState() => _SelectInterestScreenState();
}

class _SelectInterestScreenState extends State<SelectInterestScreen> {
  void backClick() {
    Constant.sendToNext(context, Routes.loginRoute);
  }

   List<ModalSelectInterest> selectIntersetList = DataFile.selectInterestList;



  final _multiSelectKey = GlobalKey<FormFieldState>();
      
  List<String> _selectedInterest = [];


  Future addDataInterest(List v) async {
    
    final BookmarkBloc sb = Provider.of<BookmarkBloc>(context, listen: false);
   sb.saveDataToSP(v);
    sb.saveInterestToFirebase(v);
 
    Constant.sendToNext(
                                context, Routes.homeScreenRoute);
    
  }

  @override
  Widget build(BuildContext context) { 
    final BookmarkBloc sb = Provider.of<BookmarkBloc>(context, listen: false);
   
    setStatusBarColor(Colors.white);
    return WillPopScope(
      onWillPop: () async {
        backClick();
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: getToolBar(
          () {
            backClick();
          },
          title: getCustomFont("Select Interests", 24.sp, Colors.black, 1,
              fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ),
        body: SafeArea(
          child: Stack(
            children: [
               Positioned(
                      top: 0,
                      right: 0,
                      height: 150,
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.asset('assets/images/login1.png'))),
              
              Column(
                children: [
                  getDivider(
                    dividerColor,
                    1.h,
                  ),
                  getVerSpace(30.h),
                  getPaddingWidget(
                    EdgeInsets.symmetric(horizontal: 20.h),
                    getMultilineCustomFont(
                        "Select the event you are interested in",
                        16.sp,
                        Colors.black,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.center,
                        txtHeight: 1.5.h),
                  ),
                  getVerSpace(30.h),
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(34.h)),
                            boxShadow: [
                              BoxShadow(
                                  color: "#2B9CC3C6".toColor(),
                                  blurRadius: 24,
                                  offset: const Offset(0, -2))
                            ]),
                        child: Column(
                          children: [
                            getVerSpace(20.h),
                
                            Expanded(
                              flex: 1,
                              child: GridView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 20.h),
                                itemCount: selectIntersetList.length,
                                itemBuilder: (context, index) {
                                  ModalSelectInterest modalSelect =
                                      selectIntersetList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (modalSelect.select == true) {
                                          modalSelect.select = false;
                          _selectedInterest.remove(modalSelect.name!);
                                        } else {
                                          modalSelect.select = true;
                          _selectedInterest.add(modalSelect.name!);
                                        }
                                      });
                      print("$index : $_selectedInterest");
                                    },
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        SizedBox(
                                          height: 123.h,
                                          width: double.infinity,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: modalSelect.color!.toColor(),
                                                borderRadius:
                                                    BorderRadius.circular(22.h),
                                                border: modalSelect.select == true
                                                    ? Border.all(
                                                        color: accentColor,
                                                        width: 2.h)
                                                    : null),
                                            height: 111.h,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                getVerSpace(20.h),
                                                getAssetImage(
                                                    modalSelect.image ?? '',
                                                    height: 44.h,
                                                    width: 44.h)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          child: Container(
                                            height: 42.h,
                                            decoration: BoxDecoration(
                                              color: modalSelect.select == true
                                                  ? accentColor
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(22.h),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: "#2690B7B9".toColor(),
                                                    offset: const Offset(0, 8),
                                                    blurRadius: 27)
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: getCustomFont(
                                                modalSelect.name ?? '',
                                                15.sp,
                                                modalSelect.select == true
                                                    ? Colors.white
                                                    : Colors.black,
                                                1,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisExtent: 123.h,
                                        crossAxisSpacing: 19.h,
                                        mainAxisSpacing: 20.h),
                              ),
                            ),
                            getPaddingWidget(
                              EdgeInsets.symmetric(horizontal: 20.h),
                              getButton(
                                  context, accentColor, "Continue", Colors.white,
                                  ()async {
                                    addDataInterest(_selectedInterest);
                                  
                             context.read<SignInBloc>().checkSignIn();
                                
                              }, 18.sp,
                                  weight: FontWeight.w700,
                                  buttonHeight: 60.h,
                                  borderRadius: BorderRadius.circular(22.h)),
                            ),
                            getVerSpace(30.h)
                          ],
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
