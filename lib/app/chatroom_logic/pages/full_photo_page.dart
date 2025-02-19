import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../base/color_data.dart';
import '../constants/color_constants.dart';

class FullPhotoPage extends StatelessWidget {
  final String url;

  FullPhotoPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Full Photo",
          // ignore: prefer_const_constructors
          style: TextStyle(
              color: ColorConstants.primaryColor,
              fontFamily: "Gilroy",
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
