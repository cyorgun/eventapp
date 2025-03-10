import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evente/evente.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../base/color_data.dart';
import '../../base/widget_utils.dart';
import '../modal/users_model.dart';
import '../view/admin_specific/user_detail.dart';

class CardUSer extends StatelessWidget {
  final UserModel user;
  final String heroTag;
  const CardUSer({Key? key, required this.user, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 90.0,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: shadowColor,
                  blurRadius: 27,
                  offset: const Offset(0, 8))
            ],
            borderRadius: BorderRadius.circular(22  )),
        padding: EdgeInsets.only(top: 7  , left: 7  , bottom: 6  , right: 20  ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        image: DecorationImage(
                            image: NetworkImage(
                              user?.imageurl ?? '',
                            ),
                            fit: BoxFit.cover)),
                  ),
                  // Image.network(event.image??'',height: 82,width: 82,),
                  // getAssetImage(event.image ?? "",
                  //     width: 82  , height: 82  ),
                  getHorSpace(10  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          child: getCustomFont(
                              user?.name ?? "", 17.5  , Colors.black, 1,
                              fontWeight: FontWeight.w700,
                              txtHeight: 1.5  ,
                              fontFamily: "Sofia",
                              overflow: TextOverflow.ellipsis),
                        ),
                       
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Row(
                          children: [
                            Icon(
                              Icons.email,
                              color: accentColor,
                              size: 15  ,
                            ),
                            getHorSpace(5  ),
                            Container(
                              width: 200,
                              child: getCustomFont(
                                  user?.email ?? "", 15  , Colors.black, 1,
                                  fontWeight: FontWeight.w300,
                                  txtHeight: 1.5  ,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            
        
                          ],
                        ),
                          ],
                        ),
                       
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
           Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new UserDetail(
                user: user,
              )));      
      }
    );
  }
}

class joinEvents extends StatelessWidget {
  joinEvents({this.list});
  final List<DocumentSnapshot>? list;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Container(
              height: 25.0,
              width: 54.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(top: 0.0, left: 5.0, right: 5.0),
                itemCount: list!.length > 3 ? 3 : list?.length,
                itemBuilder: (context, i) {
                  String? _title = list?[i]['name'].toString();
                  String? _uid = list?[i]['uid'].toString();
                  String? _img = list?[i]['photoProfile'].toString();

                  return Padding(
                    padding: const EdgeInsets.only(left: 0.0),
                    child: Container(
                      height: 24.0,
                      width: 24.0,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(70.0)),
                          image: DecorationImage(
                              image: NetworkImage(_img ?? ''),
                              fit: BoxFit.cover)),
                    ),
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 3.0,
            left: 0.0,
          ),
          child: Row(
            children: [
              Container(
                height: 32  ,
                width: 32  ,
                decoration: BoxDecoration(
                                color: accentColor,
                    borderRadius: BorderRadius.circular(30  ),
                    border: Border.all(color: Colors.white, width: 1.5  )),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getCustomFont(list?.length.toString() ?? '', 12  ,
                        Colors.white, 1,
                        fontWeight: FontWeight.w600),
                    getCustomFont(" +", 12  , Colors.white, 1,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),

            ],
          ),
        )
      ],
    );
  }
}


