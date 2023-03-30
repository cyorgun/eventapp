import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/app/widget/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../base/widget_utils.dart';
import '../view/bloc/sign_in_bloc.dart';



  class BuildLoveIcon extends StatelessWidget {
    final String collectionName;
    final String? uid;
    final String? timestamp;

    const BuildLoveIcon({
      Key? key, 
      required this.collectionName, 
      required this.uid,
      required this.timestamp
      
      }) : super(key: key);
  
    @override
    Widget build(BuildContext context) {
      final sb = context.watch<SignInBloc>();
      String _type = 'bookmarked items';
      if(sb.isSignedIn == false) return LoveIcon().normal;
      return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, AsyncSnapshot snap) {
        if (uid == null) return LoveIcon().normal;
        if (!snap.hasData) return LoveIcon().normal;
        List d = snap.data[_type];

        if (d.contains(timestamp)) {
          return    getAssetImage("favourite_select.png",
                            width: 35.h, height: 35.h);
        } else {
          return LoveIcon().normal;
        }
      },
    );
    }
  }