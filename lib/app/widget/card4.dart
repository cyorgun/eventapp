
import 'package:event_app/app/modal/modal_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/featured_event/featured_event_detail2.dart';

class Card4 extends StatelessWidget {
  final Event d;
  final String heroTag;
  const Card4({Key? key, required this.d, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black12.withOpacity(0.05),blurRadius: 5.0,spreadRadius: 2.0)
            ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100.0))
                      ),
                      child: Hero(
                        tag: heroTag,
                        child: Image.network( d.image??'',fit: BoxFit.cover,),)
                      ),

                      // VideoIcon(contentType: d.contentType, iconSize: 40,)
                    ],
              ),
              Container(
                  padding: EdgeInsets.only(left: 15, right: 15,top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          d.title!,
                          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 5,),


                      Row(
                        children: <Widget>[
                          Icon(
                            CupertinoIcons.location_solid,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            d.location!,
                            style: TextStyle(color:Colors.black54, fontSize: 13),
                          ),
                         
                          
                        ],
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      
       onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> new FeaturedEvent2Detail(event: d,))),
    );
  }
}
