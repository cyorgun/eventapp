import 'package:easy_localization/easy_localization.dart';
import 'package:event_app/app/routes/app_routes.dart';
import 'package:evente/evente.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../provider/bookmark_provider.dart';
import '../../provider/sign_in_provider.dart';

class SelectInterestScreen extends StatefulWidget {
  const SelectInterestScreen({Key? key}) : super(key: key);

  @override
  State<SelectInterestScreen> createState() => _SelectInterestScreenState();
}

class _SelectInterestScreenState extends State<SelectInterestScreen> {
  List<ModalSelectInterest> selectIntersetList = DataFile.selectInterestList;

  final _multiSelectKey = GlobalKey<FormFieldState>();

  List<String> _selectedInterest = [];

  Future addDataInterest(List v) async {
    final BookmarkProvider sb =
        Provider.of<BookmarkProvider>(context, listen: false);
    sb.saveDataToSP(v);
    sb.saveInterestToFirebase(v);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.homeScreenRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final BookmarkProvider sb =
        Provider.of<BookmarkProvider>(context, listen: false);

    setStatusBarColor(accentColor);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                getVerSpace(30.h),
                getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: getMultilineCustomFont(
                        ("Please Select the event you are interested in").tr(),
                        21.sp,
                        Colors.black,
                        fontWeight: FontWeight.w800,
                        textAlign: TextAlign.center,
                        txtHeight: 1.5.h),
                  ),
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
                                        _selectedInterest
                                            .remove(modalSelect.name!);
                                      } else {
                                        modalSelect.select = true;
                                        _selectedInterest
                                            .add(modalSelect.name!);
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
                                              color:
                                                  modalSelect.color!.toColor(),
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
                            getButton(context, accentColor, ("Continue").tr(),
                                Colors.white, () async {
                              addDataInterest(_selectedInterest);

                              //TODO: Is this needed?
                              context.read<SignInProvider>().checkIfUserIsAuthenticated;
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
    );
  }
}
