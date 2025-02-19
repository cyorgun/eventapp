import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class NumberWidget extends StatelessWidget {
  NumberWidget({required this.count, this.isExactNumber = false});

  final int? count;
  final bool isExactNumber;

  @override
  Widget build(BuildContext context) {
    if (count != null && count != 0) {
      var roundedCount = isExactNumber ? count : roundLeftMost(count!);
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(30.h),
          border: Border.all(color: Colors.white, width: 1.5.h),
        ),
        alignment: Alignment.center,
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getCustomFont(roundedCount.toString(), 12.sp, Colors.white, 1,
                      fontWeight: FontWeight.w600),
                  !isExactNumber
                      ? getCustomFont(" +", 12.sp, Colors.white, 1,
                      fontWeight: FontWeight.w600)
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      )
      ;
    } else {
      return Text("none".tr());
    }
  }

  int roundLeftMost(int number) {
    String numStr = number.abs().toString(); // Sayıyı stringe çevir
    String firstDigit = numStr[0]; // İlk basamağı al
    String zeros = '0' * (numStr.length - 1); // Geri kalan basamakları sıfır yap

    int result = int.parse(firstDigit + zeros); // Yeni sayıyı oluştur
    return number < 0 ? -result : result; // Negatifse işareti koru
  }
}