import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../base/color_data.dart';
import '../../../base/widget_utils.dart';
import '../../modal/users_model.dart';

class JoinEventDetailListScreen extends StatefulWidget {
  final List<DocumentSnapshot>? list;

   JoinEventDetailListScreen({super.key,this.list});

  @override
  State<JoinEventDetailListScreen> createState() => _JoinEventDetailListScreenState();
}

class _JoinEventDetailListScreenState extends State<JoinEventDetailListScreen> {
  @override
  Widget build(BuildContext context) {
   List<DocumentSnapshot>? list = widget.list;
    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Join Event List',
          style: TextStyle(
            fontFamily: "Sofia",
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
       
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body:ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        itemCount: list?.length,
        itemBuilder: (context, i) {
          final user = list?.map((e) {
            return UserModel.fromFirestore(e);
          }).toList();
          
          return Container(
            height: 120.0,
            margin: const EdgeInsets.only(
                bottom: 10, left: 20.0, right: 20.0, top: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      blurRadius: 27,
                      offset: const Offset(0, 8))
                ],
                borderRadius: BorderRadius.circular(22)),
            padding: EdgeInsets.only(top: 7, left: 7, bottom: 6, right: 20),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image: NetworkImage(
                            user?[i].photoProfile ?? '',
                          ),
                          fit: BoxFit.cover)),
                ),
                // Image.network(event.image??'',height: 82,width: 82,),
                // getAssetImage(event.image ?? "",
                //     width: 82 , height: 82 ),
                getHorSpace(10),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: 210,
                        child: getCustomFont(
                            user?[i].name ?? "", 17.5, Colors.black, 1,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Sofia",
                            overflow: TextOverflow.ellipsis,
                            txtHeight: 1.5),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 200.0,
                            // color: Colors.yellow,
                            child: getCustomFont(
                                user?[i].id ?? "", 15, greyColor, 1,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Sofia",
                                txtHeight: 1.5),
                          ),
                        ],
                      ),
                      getVerSpace(0),
                    ],
                  ),
                )
              ],
            ),
          );
        })   );
  }
}