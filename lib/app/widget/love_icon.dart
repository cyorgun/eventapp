import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/widget/icons.dart';
import 'package:event_app/base/color_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../base/widget_utils.dart';
import '../provider/sign_in_provider.dart';

class BuildLoveIcon extends StatelessWidget {
  final String collectionName;
  final String? uid;
  final String? timestamp;

  const BuildLoveIcon(
      {Key? key,
      required this.collectionName,
      required this.uid,
      required this.timestamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInProvider>();
    String _type = 'bookmarked items';
    if (sb.isSignedIn == false) return LoveIcon().normal;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
        if (!snap.hasData || snap.data == null || !snap.data!.exists)
          return LoveIcon().normal;
        Map<String, dynamic>? userData = snap.data!.data();
        if (userData == null) return LoveIcon().normal;
        List d = userData[_type] ?? [];
        if (d.contains(timestamp)) {
          return getSvg("hearth.svg",
              width: 27.h, height: 27.h, color: accentColor);
        } else {
          return LoveIcon().normal;
        }
      },
    );
  }
}
