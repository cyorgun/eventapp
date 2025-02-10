// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../../../base/color_data.dart';
// import '../../../base/constant.dart';
// import '../../../base/widget_utils.dart';

// class SelectCountryScreen extends StatefulWidget {
//   const SelectCountryScreen({Key? key}) : super(key: key);

//   @override
//   State<SelectCountryScreen> createState() => _SelectCountryScreenState();
// }

// class _SelectCountryScreenState extends State<SelectCountryScreen> {
//   void  {
//     Constant.backToPrev(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     setStatusBarColor(Colors.white);
//     return WillPopScope(
//       onWillPop: () async {
//         ;
//         return false;
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.white,
//         app_bar: getToolBar(() {
//           ;
//         },
//             title: getCustomFont(
//               "Select Country",
//               24.sp,
//               Colors.black,
//               1,
//               fontWeight: FontWeight.w700,
//             )),
//         body: SafeArea(
//           child: Column(
//             children: [
//               getDivider(
//                 dividerColor,
//                 1.h,
//               ),
//               getVerSpace(20.h),
//               getPaddingWidget(
//                 EdgeInsets.symmetric(horizontal: 20.h),

//               ),
//               getVerSpace(30.h),
//               Expanded(
//                   // flex: 1,
//                   child: GetBuilder<SignUpController>(
//                     init: SignUpController(),
//                     builder: (controller) => ListView.builder(
//                       padding: EdgeInsets.symmetric(horizontal: 20.h),
//                       primary: true,
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: controller.newCountryLists.length,
//                       itemBuilder: (context, index) {
//                         ModelCountry modelCountry =
//                             controller.newCountryLists[index];
//                         return GestureDetector(
//                           onTap: () {
//                             controller.getImage(modelCountry.image ?? "",
//                                 modelCountry.code ?? "");
//                             ;
//                           },
//                           child: Container(
//                             margin: EdgeInsets.only(bottom: 20.h),
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(22.h),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: "#2690B7B9".toColor(),
//                                       offset: const Offset(0, 8),
//                                       blurRadius: 27)
//                                 ]),
//                             padding: EdgeInsets.only(
//                                 left: 3.h, top: 3.h, bottom: 3.h, right: 16.h),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Container(
//                                       decoration: BoxDecoration(
//                                         color: dividerColor,
//                                         borderRadius:
//                                             BorderRadius.circular(22.h),
//                                       ),
//                                       height: 54.h,
//                                       width: 54.h,
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 11.h, vertical: 16.h),
//                                       child: getAssetImage(
//                                           modelCountry.image ?? "",
//                                           height: 22.h,
//                                           width: 32.h),
//                                     ),
//                                     getHorSpace(12.h),
//                                     getCustomFont(modelCountry.name ?? "",
//                                         16.sp, Colors.black, 1,
//                                         fontWeight: FontWeight.w500)
//                                   ],
//                                 ),
//                                 getCustomFont(modelCountry.code ?? '', 16.sp,
//                                     Colors.black, 1,
//                                     fontWeight: FontWeight.w600)
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
